//
//  NoteVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 13.10.2023.
//

import UIKit

class NoteVC: UIViewController {

    init(data: GetNoteDataClass) {
        super.init(nibName: nil, bundle: nil)
        
        print(data.title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }
}
