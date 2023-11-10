//
//  NotesVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

class NotesVC: NADataLoadingVC {
    
    let tableView = UITableView()

    let searchController = UISearchController()
    
    let toolbarTitleLabel = NABodyLabel(textAlignment: .center)
    
    var data: [Datum] = []
    var filteredData: [Datum] = []
    
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        configureTableView()
        refreshNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureViewController()
        getNotes()
        clearSearchBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        clearSearchBar()
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
        let favoriteNotesButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoriteNotesButtonTapped))
        let createNoteButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(createNoteButtonTapped))
        let title = UIBarButtonItem(customView: toolbarTitleLabel)
        setToolbarItems([favoriteNotesButton, spaceItem, title, spaceItem, createNoteButton], animated: true)
    }
    
    func configureSearchController() {
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
    
    private func refreshNotes(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getNotes), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func getNotes() {
        showLoadingView()
        
        let getMyNotesModel = GetMyNotesModel()
        
        APIManager.sharedInstance.callingGetMyNotesAPI(getMyNotesModel: getMyNotesModel) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                let code = APIManager.sharedInstance.getMyNotesModelResponse?.code
                let message = APIManager.sharedInstance.getMyNotesModelResponse?.message
                
                if code == "common.success" {
                    dismissLoadingView()
                    data = APIManager.sharedInstance.getMyNotesModelResponse?.data.data ?? []
                    toolbarTitleLabel.text = "\(data.count) Notes"
                    updateUI(with: data)
                } else {
                    dismissLoadingView()
                    ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: message ?? "Something went wrong.")
                }
            } else {
                dismissLoadingView()
                ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: "Something went wrong.")
            }
        }
        
        tableView.refreshControl?.endRefreshing()
    }
    
    func updateUI(with data: [Datum]) {
        if self.data.isEmpty {
            let message = "There are no notes here. Let's add a note 🥲."
            showEmptyStateView(with: message, in: self.view)
        } else {
            self.filteredData = data
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    @objc func favoriteNotesButtonTapped() {
        let destinationVC = FavoriteNotesVC()
        navigationController?.pushViewController(destinationVC, animated: true)
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
            
            APIManager.sharedInstance.callingDeleteNoteAPI(noteId: self.filteredData[index.row].id ?? 0, deleteNoteModel: deleteNoteModel) { [weak self] isSuccess in
                guard let self = self else { return }
            
                if isSuccess {
                    let code = APIManager.sharedInstance.deleteNoteResponse?.code
                    let message = APIManager.sharedInstance.deleteNoteResponse?.message
            
                    if code == "common.delete" {
                        removeFromFavoriteNotes(index: index)
                        filteredData.remove(at: index.row)
                        tableView.deleteRows(at: [index], with: .left)
                        getNotes()
                        clearSearchBar()
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
    
    func removeFromFavoriteNotes(index: IndexPath) {
        let favoriteNote = GetNoteDataClass(title: data[index.row].title ?? "", note: data[index.row].note ?? "", id: data[index.row].id ?? 0)
        
        PersistenceManager.updateWith(favoriteNote: favoriteNote, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            ToastMessageHelper().createToastMessage(toastMessageType: .failure, message: error.rawValue)
        }
    }
    
    func clearSearchBar() {
        if let text = searchController.searchBar.text, !text.isEmpty {
            searchController.searchBar.text = .none
            searchController.searchBar.becomeFirstResponder()
            
        }
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
        filteredData = data.filter { $0.title?.lowercased().contains(filter.lowercased()) ?? false}
        updateUI(with: filteredData)
    }
}

extension NotesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NANotesListCell.reuseID) as! NANotesListCell
        let data = filteredData[indexPath.row]
        cell.setNotes(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoadingView()
        
        let getNoteModel = GetNoteModel()
        
        APIManager.sharedInstance.callingGetNoteAPI(noteId: filteredData[indexPath.row].id ?? 0, getNoteModel: getNoteModel) { [weak self] isSuccess in
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
        
        makeDeleteAlert(title: "Delete Note", message: "Are you sure you want to delete this note.", index: indexPath)
    }
}
