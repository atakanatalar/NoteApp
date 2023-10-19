//
//  NotesVC.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import UIKit

class NotesVC: UIViewController {
    
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
        view.backgroundColor = .systemRed
        
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
        let getMyNotesModel = GetMyNotesModel()
        APIManager.sharedInstance.callingGetMyNotesAPI(getMyNotesModel: getMyNotesModel) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                data = (APIManager.sharedInstance.getMyNotesModelResponse?.data.data)!
                toolbarTitleLabel.text = "\(data.count) Notes"
                print("data: \(data)")
                updateUI(with: data)
            } else {
                print("failure")
            }
        }
    }
    
    func updateUI(with data: [Datum]) {
        if self.data.isEmpty {
            print("data empty")
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
        let activeArray = isSearching ? filteredData : data
        let data = activeArray[indexPath.row]
        
        let getNoteModel = GetNoteModel()
        
        APIManager.sharedInstance.callingGetNoteAPI(noteId: data.id, getNoteModel: getNoteModel) { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                let code = APIManager.sharedInstance.getNoteResponse?.code
                let data = APIManager.sharedInstance.getNoteResponse?.data
                let message = APIManager.sharedInstance.getNoteResponse?.message
                
                if let message = message, let code = code {
                    print("code: \(code), message: \(message)")
                }
                
                if code == "common.success" {
                    let destinationVC = NoteVC(data: data!)
                    navigationController?.pushViewController(destinationVC, animated: true)
                } else {
                    print("alert")
                }
            } else {
                print("failure")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
    
        let deleteNoteModel = DeleteNoteModel()
        
        APIManager.sharedInstance.callingDeleteNoteAPI(noteId: data[indexPath.row].id, deleteNoteModel: deleteNoteModel) { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                let code = APIManager.sharedInstance.deleteNoteResponse?.code
                let message = APIManager.sharedInstance.deleteNoteResponse?.message
                
                if let message = message, let code = code {
                    print("code: \(code), message: \(message)")
                }
                
                if code == "common.delete" {
                    self.data.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                    getNotes()
                } else {
                    print("alert")
                }
            } else {
                print("failure")
            }
        }
    }
}
