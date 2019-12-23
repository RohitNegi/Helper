//
//  HtmlPTagElement.swift
//  OmniMobileApp
//
//  Created by Bonam, Sasikant on 4/5/19.
//  Copyright © 2019 U.S.Bank. All rights reserved.
//

import UIKit

/// Html Element for Paragraph. Supports only font and color styling. If there is any <ul> within the text, it will be ignored for processing and rendered as any other html.
final class HtmlPTagElement: HtmlBaseElement {
    
    init() {
        super.init(type: .paragraph)
    }
    
    override func process() {
        super.process()
        if let retValUnwrapped = HtmlParserUtils.trimStartAndEndTags(self.value, type: self.elementType) {
            //LogUtil.logInfo("HTML:: PTag Value\(retValUnwrapped)")
            self.value = retValUnwrapped
        }
    }
    
    override func printOp() {
        //LogUtil.logInfo("HTML:: <p> \(self.value)")
    }
    
    override func getUIModels() -> [HtmlElementUIModel]? {
        // Append br tag to add new line which is default behaving or ptag element.
        guard let trimmedString = HtmlParserUtils.trimStartAndEndTags(self.value, type: self.elementType) else {
            return nil
        }
        //LogUtil.logInfo("HTML:: PTag Value \(self.value) ")
        return [HtmlElementUIModel(type: .paragraph, htmlString: trimmedString + "<br>", prefix: "")]
    }
}
