//
//  AddNoteVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 16.10.2023.
//

import UIKit

class AddNoteVC: NADataLoadingVC {
    
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

        configureUIElements()
        configureToolbar()
        layoutUI()
        KeyboardHelper.createDismissKeyboardTapGesture(view: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureViewController()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let addNoteButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNoteButton))
        setToolbarItems([spaceItem, addNoteButton, spaceItem], animated: true)
    }
    
    func configureUIElements() {
        addNoteVC = NAAddNoteVC(delegate: self)
        
        addNoteVC.noteItemViewOne.textView.delegate = self
        addNoteVC.noteItemViewTwo.textView.delegate = self
        
        self.add(childVC: addNoteVC, to: self.noteView)
    }
    
    func configureToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        toolbar.sizeToFit()
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeKeyboard))
        doneButton.tintColor = .systemPurple
        
        toolbar.items = [spaceItem, doneButton]

        addNoteVC.noteItemViewOne.textView.inputAccessoryView = toolbar
        addNoteVC.noteItemViewTwo.textView.inputAccessoryView = toolbar
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
    
    @objc func addNoteButton() {
        guard let title = addNoteVC.noteItemViewOne.textView.text,
              let note = addNoteVC.noteItemViewTwo.textView.text else { return }
        
        if addNoteVC.noteItemViewOne.textView.textColor == .secondaryLabel || addNoteVC.noteItemViewTwo.textView.textColor == .secondaryLabel {
            ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: "The fields are required.")
            return
        }
        
        showLoadingView()
        
        let createNoteModel = CreateNoteModel(title: title, note: note)
        
        APIManager.sharedInstance.callingCreateNoteAPI(createNoteModel: createNoteModel) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                let code = APIManager.sharedInstance.createNoteResponse?.code
                let message = APIManager.sharedInstance.createNoteResponse?.message
                
                if code == "common.success" {
                    dismissLoadingView()
                    navigationController?.popViewController(animated: true)
                    ToastMessageHelper().createToastMessage(toastMessageType: .success, message: message ?? "Success.")
                } else {
                    dismissLoadingView()
                    ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: message ?? "Something went wrong.")
                }
            } else {
                dismissLoadingView()
                ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: "Something went wrong.")
            }
        }
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
}

extension AddNoteVC: NAAddNoteVCDelegate {}

extension AddNoteVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = ""
            textView.textColor = .label
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            if textView == addNoteVC.noteItemViewOne.textView {
                textView.text = "Enter your note title"
            } else {
                textView.text = "Enter your note"
            }
            textView.textColor = .secondaryLabel
        }
        textView.resignFirstResponder()
    }
}
