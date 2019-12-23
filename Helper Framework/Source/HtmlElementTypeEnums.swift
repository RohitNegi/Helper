//
//  HtmlElementTypeEnums.swift
//  OmniMobileApp
//
//  Created by Bonam, Sasikant on 4/4/19.
//  Copyright © 2019 U.S.Bank. All rights reserved.
//

import UIKit

/// Enumeration to hold html element type that need to be displayed. Currently supporting p tags, nested unordered list but can be expanded for ordered list and tables if needed.
enum HtmlElementType {
    
    case paragraph
    case unorderedList
    case orderedList
    case listItem
    
    /// Factory Method to construct corresponding element type based on the information needed for corresponding element type.
    /// - Parameter level: Level/depth of the element. Specific to Unordered list and list elements.
    /// - Parameter parentType: Parent element type. (Required for only list element type)
    /// - Parameter list index: Indexing needed for nested element. (Required for only list element type)
    func tagElement(level: Int = 0, parentType: HtmlElementType = .unorderedList, listIndex: Int = 0) -> HtmlBaseElement {
        switch self {
        case .paragraph:
            return HtmlPTagElement()
        case .unorderedList:
            return  HtmlULElement(level: level, type: .unorderedList)
        case .orderedList:
            return  HtmlULElement(level: level, type: .orderedList)
        case .listItem:
            return HtmlListElement(level: level, listIndex: listIndex, parentType: parentType)
        }
    }
    
    /// Start tag representation of html element
    func startTag() -> String {
        switch self {
        case .paragraph:
            return "<p>"
        case .unorderedList:
            return "<ul>"
        case .orderedList:
            return "<ol>"
        case .listItem:
            return "<li>"
        }
    }
    
    /// End tag representation of html element
    func endTag() -> String {
        switch self {
        case .paragraph:
            return "</p>"
        case .unorderedList:
            return "</ul>"
        case .orderedList:
            return "</ol>"
        case .listItem:
            return "</li>"
        }
    }
}
