//
//  Validate+Auth.swift
//  App Authorization
//
//  Created by Mike on 12/19/18.
//  Copyright © 2018 William Nau. All rights reserved.
//

import UIKit

class Validate {
    public static func isEmpty(text: String?) -> (data: String?, error: String?) {
        guard let txt = text , txt != "" else { return (nil, "text field is required.") }
        return (txt, nil)
    }
}
