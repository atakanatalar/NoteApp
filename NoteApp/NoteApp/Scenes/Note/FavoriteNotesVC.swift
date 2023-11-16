//
//  FavoriteNotesVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 22.10.2023.
//

import UIKit

class FavoriteNotesVC: NADataLoadingVC {
    
    let tableView = UITableView()
    
    var data: [GetNoteDataClass] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationController()
        getUserData()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configureNavigationController() {
        title = "Favorite Notes"
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 64
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NANotesListCell.self, forCellReuseIdentifier: NANotesListCell.reuseID)
    }
    
    func getUserData() {
        showLoadingView()
        
        let getMeModel = GetMeModel()
        
        APIManager.sharedInstance.callingGetMeAPI(getMeModel: getMeModel) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                let code = APIManager.sharedInstance.getMeResponse?.code
                let data = APIManager.sharedInstance.getMeResponse?.data
                let message = APIManager.sharedInstance.getMeResponse?.message
                
                if code == "common.success" {
                    dismissLoadingView()
                    getNotes()
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
    
    func getNotes() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favoriteNotes):
                self.updateUI(with: favoriteNotes)
            case .failure(let error):
                ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: error.rawValue)
            }
        }
    }
    
    func updateUI(with data: [GetNoteDataClass]) {
        self.data = data
        
        if self.data.isEmpty {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
                
                let message = "There are no notes here. Let's add a note 🥲."
                self.showEmptyStateView(with: message, in: self.view)
            }
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    @objc func makeDeleteAlert(title: String, message: String, index: IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        let deleteButton = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) { (UIAlertAction) in
            let favoriteNote = self.data[index.row]
            
            PersistenceManager.updateWith(favoriteNote: favoriteNote, actionType: .remove) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    self.data.remove(at: index.row)
                    tableView.deleteRows(at: [index], with: .left)
                    ToastMessageHelper().createToastMessage(toastMessageType: .success, message: "Successfully deleted your note 🫡")
                    
                    if self.data.isEmpty {
                        let message = "There are no favorite notes here. Let's add a note 🥲."
                        showEmptyStateView(with: message, in: self.view)
                    }
                    return
                }
                ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: error.rawValue)
            }
        }
        
        alert.addAction(cancelButton)
        alert.addAction(deleteButton)
        
        present(alert, animated: true)
    }
}

extension FavoriteNotesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NANotesListCell.reuseID) as! NANotesListCell
        let data = data[indexPath.row]
        cell.setFavoriteNotes(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoadingView()
        
        let favoriteNote = data[indexPath.row]
        
        let getNoteModel = GetNoteModel()
        
        APIManager.sharedInstance.callingGetNoteAPI(noteId: favoriteNote.id, getNoteModel: getNoteModel) { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                let code = APIManager.sharedInstance.getNoteResponse?.code
                let data = APIManager.sharedInstance.getNoteResponse?.data
                let message = APIManager.sharedInstance.getNoteResponse?.message
                
                if code == "common.success" {
                    dismissLoadingView()
                    
                    let destinationVC = NoteVC(data: data!)
                    navigationController?.pushViewController(destinationVC, animated: true)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        makeDeleteAlert(title: "Delete Note", message: "Are you sure you want to delete this note from favorite notes?", index: indexPath)
    }
}
