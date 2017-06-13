//
//  UITextFieldExtension.swift
//  My Car
//
//  Created by Axel Lefaux on 05/06/2017.
//  Copyright © 2017 ITomorrow. All rights reserved.
//

import UIKit

private var kAssociationKeyNextField: UInt8 = 0
    
extension UITextField {
    @IBOutlet var nextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

