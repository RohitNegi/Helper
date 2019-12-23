//
//  HtmlElements.swift
//  OmniMobileApp
//
//  Created by Bonam, Sasikant on 4/4/19.
//  Copyright © 2019 U.S.Bank. All rights reserved.
//

import UIKit

/// Base class for all the html base elements.
/// Uses stack internally to track the start and end of the tag element.
class HtmlBaseElement: NSObject {
    
    //Disabling default constructor
    private override init() {
        self.elementType = .paragraph
        super.init()
    }
    
    init(type: HtmlElementType) {
        self.elementType = type
        super.init()
    }
    
    /// Element type represented by the class
    var elementType: HtmlElementType
    var value: String = ""
    
    // MARK: Stack Variables and Methods
    /// Stack to track the start and end of the tags
    private var tags: [HtmlElementType] = []
    
    /// Push the tag element to stack
    func pushTag(_ tag: HtmlElementType) {
        self.tags.append(tag)
    }
    
    /// Pop the tag element from stack and return it.
    func popTag() -> HtmlElementType? {
        return self.tags.popLast()
    }
    
    /// Top of the stack element.
    func topTag() -> HtmlElementType? {
        return self.tags.last
    }
    
    // MARK: Abstract Methods
    /// Abstract method that need to be overriden by sub class.
    /// Method to be invoked by respective html element to process the html content within the tag. Currently the method is marked for throwing error, because the sub classes might be throwing error
    func process() {
        //LogUtil.logInfo("Empty Method. Should be overridden by base classes")
    }
    
    /// Abstract method that need to be overriden by sub class.
    /// Method to be invoked by respective html element to print output.
    func printOp() {
        //LogUtil.logInfo("HtmlBaseElement:: Raw Value \(self.value)")
    }
    
    /// Abstract method that need to be overriden by sub class.
    /// Method to return the html content in array of strings. Implementation will be dependent on the element type. If element is list type <l1>, prepend \t and also bulleted charecter,
    func getUIModels() -> [HtmlElementUIModel]? {
        return nil
    }
}
