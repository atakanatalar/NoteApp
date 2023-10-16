//
//  AddNoteVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 16.10.2023.
//

import UIKit

class AddNoteVC: UIViewController {
    
    let noteView = UIView()
    
    var addNoteVC: NAAddNoteVC!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureUIElements()
        layoutUI()
        KeyboardHelper.createDismissKeyboardTapGesture(view: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureUIElements() {
        addNoteVC = NAAddNoteVC(delegate: self)
        
        self.add(childVC: addNoteVC, to: self.noteView)
    }
    
    func layoutUI() {
        view.addSubview(noteView)
        
        noteView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            noteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            noteView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            noteView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            noteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension AddNoteVC: NAAddNoteVCDelegate {
    func didTapAddNoteButton() {
        guard let title = addNoteVC.noteItemViewOne.textView.text,
              let note = addNoteVC.noteItemViewTwo.textView.text else { return }
        
        let createNoteModel = CreateNoteModel(title: title, note: note)
        
        APIManager.sharedInstance.callingCreateNoteAPI(createNoteModel: createNoteModel) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                let code = APIManager.sharedInstance.createNoteResponse?.code
                let message = APIManager.sharedInstance.createNoteResponse?.message
                
                if let message = message, let code = code {
                    print("code: \(code), message: \(message)")
                }
                
                if code == "common.success" {
                    navigationController?.popViewController(animated: true)
                } else {
                    print("alert")
                }
            } else {
                print("failure")
            }
        }
    }
}
