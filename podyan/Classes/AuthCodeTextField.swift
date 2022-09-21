//
//  AuthCodeTextField.swift
//  NovaDAX
//
//  Created by Peixue Yan on 2022/7/26.
//

import UIKit

class AuthCodeTextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.isMenuVisible = false
        return false
    }
}
