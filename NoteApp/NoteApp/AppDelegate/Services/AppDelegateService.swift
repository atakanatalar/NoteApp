//
//  AppDelegateService.swift
//  NoteApp
//
//  Created by Atakan Atalar on 10.11.2023.
//

import UIKit

protocol AppDelegateServiceProtocol {
    @discardableResult func application(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
}
