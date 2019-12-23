//
//  HtmlULElement.swift
//  OmniMobileApp
//
//  Created by Bonam, Sasikant on 4/4/19.
//  Copyright © 2019 U.S.Bank. All rights reserved.
//

import UIKit

/// Html Element to represent Unordered List. As an unordered list supports display of list items using bullets, the class returns with list of elements that represent the list items. Each list item can also contain unordered list which will be handled by [HtmlListElement](x-source-tag://HtmlListElement)
/// - Currently supports lists with default html bulleting based on the depth of nesting. Please refer to [HtmlParserUtils.filterSpecialCharacters()](x-source-tag://filterSpecialCharecters) for bulleted string codes.
final class HtmlULElement: HtmlBaseElement {
    
    var listElements: [HtmlListElement] = []
    var level: Int = 0
    
    init(level: Int, type: HtmlElementType) {
        super.init(type: type == .unorderedList ? .unorderedList : .orderedList)
        self.level = level
    }
    
    override func printOp() {
        //LogUtil.logInfo("HTML:: <ul>:L\(self.level):")

        for listItem in listElements {
            listItem.printOp()
        }
    }
    
    override func getUIModels() -> [HtmlElementUIModel]? {
        
        var models: [HtmlElementUIModel] = []
        
        for listElement in listElements {
            if let listElementModels = listElement.getUIModels() {
                models.append(contentsOf: listElementModels)
            }
        }
        
        return models
    }
    
    override func process() {
        // Parse the underlying listed element strings. Nested parsing of list item will be handled by HtmlListElement class.
        
        self.value = HtmlParserUtils.trimStartAndEndTags(self.value, type: self.elementType) ?? ""
        
        var index = 0
        let sizeOfString = value.count
        
        var listIndex = 0
        var currentEle: HtmlListElement?
        
        while index < value.count {
            
            let startIndex = String.Index(utf16Offset: index, in: value)
            let endIndex = String.Index(utf16Offset: (index + HtmlParserUtils.maxTagSize < sizeOfString ? index + HtmlParserUtils.maxTagSize : sizeOfString), in: value)
            let substring = String(value[startIndex..<endIndex])

            if substring.hasPrefix(HtmlElementType.listItem.startTag()) {
                
                if currentEle == nil {
                    currentEle = HtmlListElement(level: self.level + 1, listIndex: listIndex, parentType: self.elementType)
                    listIndex += 1
                }
                currentEle?.value.append(HtmlElementType.listItem.startTag())
                currentEle?.pushTag(.listItem)
                index += HtmlElementType.listItem.startTag().count
                
            } else if substring.hasPrefix(HtmlElementType.listItem.endTag()) {
                
                guard let currentEleUnwrapped = currentEle, currentEle?.topTag() == HtmlElementType.listItem else {
                    //LogUtil.logInfo("Parser Error. invalid termination of tag.")
                    return
                }
                _ = currentEleUnwrapped.popTag()
                currentEleUnwrapped.value.append(HtmlElementType.listItem.endTag())
                if currentEleUnwrapped.topTag() == nil {
                    self.listElements.append(currentEleUnwrapped)
                    currentEle = nil
                }
                index += HtmlElementType.listItem.endTag().count
                
            } else {
                if currentEle == nil {
                    currentEle = HtmlListElement(level: self.level + 1, listIndex: listIndex, parentType: self.elementType)
                    listIndex += 1
                }
                
                if let firstChar = substring.first {
                    currentEle?.value.append(firstChar)
                }
                index += 1
            }
        }
        
        for listEle in listElements {
            listEle.process()
        }
    }
}
