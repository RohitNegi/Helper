//
//  HtmlListElement.swift
//  OmniMobileApp
//
//  Created by Bonam, Sasikant on 4/5/19.
//  Copyright © 2019 U.S.Bank. All rights reserved.
//

import UIKit

/// - Tag: HtmlListElement
/// Html Element for List item. Supports single paragraph and single unordered list.
final class HtmlListElement: HtmlBaseElement {
    
    private var level: Int = 0
    private var parentElementType = HtmlElementType.unorderedList
    private var listIndex: Int = 0
    private var pString: String = ""
    
    private var unorderedList: HtmlULElement?
    
    init(level: Int, listIndex: Int, parentType: HtmlElementType) {
        super.init(type: .listItem)
        self.level = level
        self.listIndex = listIndex
        self.parentElementType = parentType == .unorderedList ? .unorderedList : .orderedList
    }
    
    override func getUIModels() -> [HtmlElementUIModel]? {
        // Based on the level of list element, we need to display appropriate bulleted string.
        
        var models: [HtmlElementUIModel] = []
        
        var bulletText = ""
        for _ in 0..<level - 1 {
            bulletText += "&emsp;&emsp;"
        }
        // If list element is part of
        bulletText += self.parentElementType == .orderedList ? "&emsp;\(listIndex+1)&emsp;" : "&emsp;\(HtmlParserUtils.bulletUnicode(forLevel: level) ?? "")&emsp;"
        
        models.append(HtmlElementUIModel(type: HtmlElementType.listItem,
                                         htmlString: self.pString,
                                         prefix: bulletText))
        
        if let ulistModels = unorderedList?.getUIModels() {
            models.append(contentsOf: ulistModels)
        } else {
            //LogUtil.logInfo("No ul list found")
        }
        
        return models
    }
    
    override func printOp() {
        super.printOp()
        //LogUtil.logInfo("HTML:: <li>L\(self.level): \(self.pString)")
        unorderedList?.printOp()
    }
    
    // Read for possible unordered list objects within the parser.
    override func process() {
        
        super.process()
        
        guard let trimmedString = HtmlParserUtils.trimStartAndEndTags(self.value, type: self.elementType) else {
            //LogUtil.logInfo("Parser Error:: List element content not found.")
            return
        }
        
        self.value = trimmedString
        
        // Variables to process over the tag string and convert to string to list element.
        var index = 0
        let sizeOfString = self.value.count
        var currentEle: HtmlULElement?
        var isInPlainText: Bool = true
        
        while index < value.count {
            
            let startIndex = String.Index(utf16Offset: index, in: self.value)
            let endIndex = String.Index(utf16Offset: (index + HtmlParserUtils.maxTagSize < sizeOfString ? index + HtmlParserUtils.maxTagSize : sizeOfString), in: self.value)
            let substring = String(value[startIndex..<endIndex])
            
            // Create a new html ul element if it is part of <ul> or <il>
            if let elementType = HtmlParserUtils.startTag(string: substring), [HtmlElementType.orderedList, HtmlElementType.unorderedList].contains(elementType) {
                if currentEle == nil {
                    currentEle = HtmlULElement(level: self.level, type: elementType)
                }
                currentEle?.value.append(elementType.startTag())
                index += elementType.startTag().count
                isInPlainText = false
                currentEle?.pushTag(elementType)
                
            } else if let elementType = HtmlParserUtils.endTag(string: substring) {
                
                guard currentEle != nil, currentEle?.topTag() == elementType else {
                    //LogUtil.logInfo("Parser Error List Element - invalid end tag")
                    return
                }
                currentEle?.value.append(elementType.endTag())
                index += elementType.endTag().count
                isInPlainText = false
                
                _ = currentEle?.popTag()
                
                if currentEle?.topTag() == nil {
                    self.unorderedList = currentEle
                    currentEle = nil
                    isInPlainText = true
                }
            } else if let character = substring.first {
                if isInPlainText {
                    pString.append(character)
                } else {
                    currentEle?.value.append(character)
                }
                index += 1
            }
        }
        
        self.unorderedList?.process()
    }
}
