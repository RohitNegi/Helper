//
//  HtmlParserWorker.swift
//  OmniMobileApp
//
//  Created by Bonam, Sasikant on 4/2/19.
//  Copyright © 2019 U.S.Bank. All rights reserved.
//

import UIKit

/// * Reads raw html parser element and returns the ui model objects to display on the individual cells.
/// * Splits the data based on the line based styling (p tag, unorderedlist). If text has bold or strong styling, no new model is created and will be part of the ptag or ul or il list element.
/// * This currently supports tag with out internal styling (for eg `<ol style=list-style-type: lower-alpha;>`) is ignored and breaks parsing. This needs to be done as enhancement.
/// # How it works
/// * String is navigated horizontally and split into individual elements on top level.
/// * Once the elements are formed, [HtmlBaseElement.process()](x-source-tag://HtmlBaseElement.process()) method is called to recursively parse and construct the required structure. Every element has its own process() method overridden to handling the constructing of the structure appropriately.
/// * For usage, refer to HelpCenterDetailViewController.
final class HtmlParserWorker: NSObject {
    
    var stackElements: [HtmlBaseElement] = []
    
    /// Reads raw html parser element and returns the ui model objects to display on the individual cells.
    /// Splits the data based on the line based styling (p tag, unorderedlist). If text has bold or strong styling, no new model is created and will be part of the ptag or ul or il list element.
    /// For usage, refer to HelpCenterDetailViewController.
    func parse(htmlString html: String) throws -> [HtmlElementUIModel] {
        
        var currentElement: HtmlBaseElement?
        
        let htmlString = HtmlParserUtils.filterSpecialCharacters(html)
        let sizeOfString = htmlString.count
        
        var index: Int = 0

        while index < htmlString.count {
            
            let startIndex = String.Index(utf16Offset: index, in: htmlString)
            let endIndex = String.Index(utf16Offset: (index + HtmlParserUtils.maxTagSize < sizeOfString ? index + HtmlParserUtils.maxTagSize : sizeOfString), in: htmlString)
            let substring = String(htmlString[startIndex..<endIndex])
            
            if let elementType = HtmlParserUtils.startTag(string: substring) {
                
                if currentElement == nil {
                    currentElement = elementType.tagElement(level: 0)
                }
                
                currentElement?.value.append(elementType.startTag())
                
                currentElement?.pushTag(elementType)
                
                index += elementType.startTag().count
                
            } else if let elementType = HtmlParserUtils.endTag(string: substring) {
                
                guard let currentEle = currentElement, currentElement?.topTag() == elementType else {
                    throw NSError(domain: "Parser Error. Ending with a tag that is different than start tag.", code: 1, userInfo: nil)
                }
                currentElement?.value.append(elementType.endTag())
                index += elementType.endTag().count
                
                _ = currentEle.popTag()
                
                // If we reached the end of the tag, a one tag is reached.
                if currentEle.topTag() == nil {
                    self.stackElements.append(currentEle)
                    currentElement = nil
                } else {
                }
            } else {
                // If it is a plain tag, start with a p-tag element.
                if currentElement == nil {
                    currentElement = HtmlPTagElement()
                }
                let character = String(htmlString[String.Index(utf16Offset: index, in: htmlString)..<String.Index(utf16Offset: (index+1 < sizeOfString ? index+1 : sizeOfString), in: htmlString)])
               currentElement?.value.append(character)
                index += 1
            }
        }
        
        processElements()
        
        return self.getUIModels()
    }
    
    private func getUIModels() -> [HtmlElementUIModel] {
        var models: [HtmlElementUIModel] = []
        
        for element in self.stackElements {
            if let eleModels = element.getUIModels() {
                models.append(contentsOf: eleModels)
            }
        }
        
        return models
    }
    
    private func processElements() {
        for element in self.stackElements {
            element.process()
        }
    }
}
