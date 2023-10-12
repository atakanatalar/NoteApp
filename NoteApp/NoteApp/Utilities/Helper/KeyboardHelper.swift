//
//  KeyboardHelper.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

enum KeyboardHelper {
    
    static func createDismissKeyboardTapGesture(view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
    }
}
