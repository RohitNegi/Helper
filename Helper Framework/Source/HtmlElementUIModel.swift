//
//  HtmlElementUIModel.swift
//  OmniMobileApp
//
//  Created by Bonam, Sasikant on 4/5/19.
//  Copyright © 2019 U.S. Bank. All rights reserved.
//

import UIKit

/// UI Model class to hold the display data needed for a11y element cell.
struct HtmlElementUIModel {

    /// Html element type that needs to be displayed.
    var type: HtmlElementType
    /// Html string that needs to be displayed.
    var htmlString: String
    /// Prefix/bullet string that needs to be displayed.
    var prefix: String
}
