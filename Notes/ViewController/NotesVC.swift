//
//  ViewController.swift
//  Notes
//
//  Created by Jozef Vrana on 10/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import UIKit

class NotesVC: UIViewController, NotesManagerDelegate, NoteDetailVCDelegate, NoteCreateVCDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let notesManager = NotesManager()
    var notes: [Note]? {
        didSet {
            self.updateUI()
        }
    }
    var selectedNote: Note?
    
    let cellID = "notesCellID"
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()                
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255, green: 94/255, blue: 42/255, alpha: 1)
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.notesManager.delegate = self
        self.notesManager.getAllNotes { error in
            if let error = error {
                self.handleError(error)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailNoteVC" {
            let destinationVC = segue.destination as! NoteDetailVC
            if let notes = self.notes, let noteID = self.tableView.indexPathForSelectedRow?.row {
                destinationVC.delegate = self
                destinationVC.notesManager = self.notesManager
                destinationVC.note = notes[noteID]
            }
        }
        if segue.identifier == "createNoteVC" {
            let destinationVC = segue.destination as! NoteCreateVC
            destinationVC.delegate = self
            destinationVC.notesManager = self.notesManager
        }
    }
    
    // MARK: - Actions
    
    func loadNotes() {
        self.notesManager.getAllNotes { error in
            if let error = error {
                self.handleError(error)
            }
        }
    }

    @IBAction func onReload(_ sender: UIBarButtonItem) {
        self.loadNotes()
    }
            
    func updateNoteByID(id: Int) {
        self.notesManager.updateNoteByID(id: id, completion: { note, error in
            if let error = error {
                self.handleError(error)
            }
        })
    }
    
    func deleteNoteByID(id: Int) {
        self.notesManager.deleteNoteByID(id: id) { error in
            if let error = error {
                self.handleError(error)
            }
        }
    }
    
    @IBAction func onDeleteAllNotes(_ sender: UIBarButtonItem) {
        self.notesManager.deleteAllNotes()
    }
    
    // MARK: - UI handling 
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func refresh() {
        self.loadNotes()
        self.refreshControl.endRefreshing()
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - NotesManager delegate
    
    func updateNotes(_ notes: Notes?) {
        self.notes = notes
    }
    
    // MARK: - NoteCreate delegate
    
    func didPostNote(_ error: WebError<APIError>?) {
        if let error = error {
            self.handleError(error)
        } 
    }
    
    // MARK: - NoteDetail delegate
    
    func didUpdateNote(_ error: WebError<APIError>?) {
        if let error = error {
            self.handleError(error)
        }
    }
    
    // MARK: - Error handling
    
    func handleError(_ error: WebError<APIError>) {
        switch error {
        case .noInternetConnection:
            showAlert(message: "No internet connection.")
        case .unauthorized:
            showAlert(message: "Unathorized.")
        case .other:
            showAlert(message: "Unfortunately, something went wrong.")
        case .custom(let error):
            showAlert(message: error.message)
        }
    }
    
    // MARK: - TableView datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if let notes = notes {
            cell.textLabel?.text = notes[indexPath.row].title
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.minimumScaleFactor = 0.5
        }
        
        return cell
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            self.deleteNoteByID(id: indexPath.row)
        }
        deleteAction.backgroundColor = .red
        
        return [deleteAction]
    }
}

