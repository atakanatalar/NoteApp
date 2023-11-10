//
//  IQKeyboardService.swift
//  NoteApp
//
//  Created by Atakan Atalar on 10.11.2023.
//

import IQKeyboardManagerSwift

class IQKeyboardService: AppDelegateServiceProtocol {
    func application(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 80
        IQKeyboardManager.shared.toolbarTintColor = .systemPurple
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        return true
    }
}
