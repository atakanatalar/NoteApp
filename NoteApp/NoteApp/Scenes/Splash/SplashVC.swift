//
//  SplashVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 11.10.2023.
//

import UIKit

class SplashVC: UIViewController {
    
    private var navController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemMint
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            let viewController = NotesVC()
            self.navController = UINavigationController(rootViewController: viewController)
        } else {
            let viewController = LoginVC()
            self.navController = UINavigationController(rootViewController: viewController)
        }
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window else { return }
        
        window.rootViewController = self.navController
        window.makeKeyAndVisible()
    }
}
