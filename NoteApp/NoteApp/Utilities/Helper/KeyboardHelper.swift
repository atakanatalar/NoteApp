//
//  KeyboardHelper.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

enum KeyboardHelper {
    static func closeKeyboard(view: UIView) {
        view.endEditing(true)
    }
}
