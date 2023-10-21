//
//  NotesVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

class NotesVC: NADataLoadingVC {
    
    let tableView = UITableView()
    
    let toolbarTitleLabel = NABodyLabel(textAlignment: .center)
    
    var data: [Datum] = []
    var filteredData: [Datum] = []
    
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureViewController()
        getNotes()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        
        title = "Notes"
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemPurple
        
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.toolbar.tintColor = .systemPurple
        
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(profileButtonTapped))
        navigationItem.rightBarButtonItem = profileButton
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let createNoteButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(createNoteButtonTapped))
        let title = UIBarButtonItem(customView: toolbarTitleLabel)
        setToolbarItems([spaceItem, title, spaceItem, createNoteButton], animated: true)
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
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
    
    func getNotes() {
        showLoadingView()
        
        let getMyNotesModel = GetMyNotesModel()
        
        APIManager.sharedInstance.callingGetMyNotesAPI(getMyNotesModel: getMyNotesModel) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                data = (APIManager.sharedInstance.getMyNotesModelResponse?.data.data)!
                toolbarTitleLabel.text = "\(data.count) Notes"
                updateUI(with: data)
                
                dismissLoadingView()
            } else {
                dismissLoadingView()
                //Although the request was successful, I could not understand how it entered here. That's why I covered the events here too.
                let message = "There are no notes here. Let's add a note 🥲."
                showEmptyStateView(with: message, in: self.view)
            }
        }
    }
    
    func updateUI(with data: [Datum]) {
        if self.data.isEmpty {
            let message = "There are no notes here. Let's add a note 🥲."
            showEmptyStateView(with: message, in: self.view)
        } else {
            self.data = data
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    @objc func createNoteButtonTapped() {
        let destinationVC = AddNoteVC()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func profileButtonTapped() {
        let destinationVC = ProfileVC()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func makeDeleteAlert(title: String, message: String, index: IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        let deleteButton = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) { (UIAlertAction) in
            let deleteNoteModel = DeleteNoteModel()
            
            APIManager.sharedInstance.callingDeleteNoteAPI(noteId: self.data[index.row].id, deleteNoteModel: deleteNoteModel) { [weak self] isSuccess in
                guard let self = self else { return }
            
                if isSuccess {
                    let code = APIManager.sharedInstance.deleteNoteResponse?.code
                    let message = APIManager.sharedInstance.deleteNoteResponse?.message
            
                    if code == "common.delete" {
                        self.data.remove(at: index.row)
                        tableView.deleteRows(at: [index], with: .left)
                        getNotes()
                        ToastMessageHelper().createToastMessage(toastMessageType: .success, message: message ?? "Resource has been deleted.")
                    } else {
                        ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: message ?? "Something went wrong.")
                    }
                } else {
                    ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: "Something went wrong.")
                }
            }
        }
        
        alert.addAction(cancelButton)
        alert.addAction(deleteButton)
        
        present(alert, animated: true)
    }
}

extension NotesVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredData.removeAll()
            isSearching = false
            updateUI(with: data)
            return
        }
        
        isSearching = true
        filteredData = data.filter { $0.title.lowercased().contains(filter.lowercased()) }
        updateUI(with: filteredData)
    }
}

extension NotesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NANotesListCell.reuseID) as! NANotesListCell
        let data = data[indexPath.row]
        cell.set(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoadingView()
        
        let activeArray = isSearching ? filteredData : data
        let data = activeArray[indexPath.row]
        
        let getNoteModel = GetNoteModel()
        
        APIManager.sharedInstance.callingGetNoteAPI(noteId: data.id, getNoteModel: getNoteModel) { [weak self] isSuccess in
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
                    ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: message ?? "Not found.")
                }
            } else {
                dismissLoadingView()
                ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: "Not found.")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        makeDeleteAlert(title: "Delete Note", message: "Are you sure you want to delete this note.", index: indexPath)
    }
}
