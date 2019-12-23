//
//  HtmlParserUtils.swift
//  OmniMobileApp
//
//  Created by Bonam, Sasikant on 4/4/19.
//  Copyright © 2019 U.S.Bank. All rights reserved.
//

import UIKit

/// Utility class to help html parsing.
class HtmlParserUtils: NSObject {
    
    /// Maximum size of tag string that is expected from server.
    static let maxTagSize = 12

    /// Trim the entire html tag string of its start and end tags. If you pass "<p>This is the string</p>", this method will return "This is the string"
    static func trimStartAndEndTags(_ value: String?, type: HtmlElementType?) -> String? {
        
        guard let typeUnwrapped = type, let valueUnwrapped = value else {
            
            return nil
        }
        
        var returnValue = valueUnwrapped.hasPrefix(typeUnwrapped.startTag()) ? String(valueUnwrapped.dropFirst(typeUnwrapped.startTag().count)) : valueUnwrapped
        returnValue = returnValue.hasSuffix(typeUnwrapped.endTag()) ? String(returnValue.dropLast(typeUnwrapped.endTag().count)) : returnValue
        
        return returnValue
    }
    
    /// Method to return the tag type based on what the string starts with.
    /// **Note** this method returns the matching tag type based on independent tags. For ptags and unordered list. but nit list item. Since list item wont be seen independently.
    /// - Parameter string: String that needs to be checked if it starts with possible start tag type.
    static func startTag(string: String) -> HtmlElementType? {
        
        if string.hasPrefix(HtmlElementType.paragraph.startTag()) {
            return HtmlElementType.paragraph
        } else if string.hasPrefix(HtmlElementType.unorderedList.startTag()) {
            return HtmlElementType.unorderedList
        } else if string.hasPrefix(HtmlElementType.orderedList.startTag()) {
            return HtmlElementType.orderedList
        }
        return nil
    }
    
    /// Method to return the type based on what the string ends with.
    /// **Note** this method returns the matching tag type based on independent tags (ptags, unordered list, orderedlit but not list item). Since list item wont be seen independently.
    /// - Parameter string: String that needs to be checked if it starts with possible end tag type.
    static func endTag(string: String) -> HtmlElementType? {
        
        if string.hasPrefix(HtmlElementType.paragraph.endTag()) {
            return HtmlElementType.paragraph
        } else if string.hasPrefix(HtmlElementType.unorderedList.endTag()) {
            return HtmlElementType.unorderedList
        } else if string.hasPrefix(HtmlElementType.orderedList.endTag()) {
            return HtmlElementType.orderedList
        }
        return nil
    }
    
    /// Method to return the html string to display the appropriate bullet based on level.
    /// - Parameters:
    /// - forLevel: Level based on which the bulleted string is constructed.
    static func bulletUnicode(forLevel: Int) -> String? {
        
        var code: String?
        
        switch forLevel {
        case 1:
            // "•"
            code = "\u{2022}"
        case 2:
            // "◦"
            code = "\u{25E6}"
        case 3...:
            // "▪"
            code = "\u{25AA}"
        default:
            break
        }
        
        return code
    }
    
    /// - Tag: filterSpecialCharecters
    /// Method to remove "\r\n" and stripe off inline styles.
    /// - Parameter rawString: Raw html string that needs to be filtered
    static func filterSpecialCharacters(_ rawHtml: String) -> String {
        
        let mutableString = NSMutableString(string: rawHtml.replacingOccurrences(of: HtmlParserConstants.specialCharectersString, with: ""))
        let pattern = HtmlParserConstants.regexForReplacingInlineStyle
        let regex = try? NSRegularExpression(pattern: pattern)
        regex?.replaceMatches(in: mutableString,
                              options: .reportProgress,
                              range: NSRange(location: 0, length: mutableString.length),
                              withTemplate: "$1$2")
        
        return mutableString as String
    }
}
