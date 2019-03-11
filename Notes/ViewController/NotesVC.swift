//
//  ViewController.swift
//  Notes
//
//  Created by Jozef Vrana on 10/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import UIKit

class NotesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let client = Client.init(baseUrl: "https://private-anon-19453e7412-note10.apiary-mock.com")
    var notesTask: URLSessionTask?
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
                
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.loadNotes()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC" {
            let destinationVC = segue.destination as! NoteDetailVC
            if let notes = self.notes, let noteID = self.tableView.indexPathForSelectedRow?.row {
                destinationVC.note = notes[noteID]
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onReload(_ sender: UIBarButtonItem) {
        self.loadNotes()
    }
    
    func onGetNoteByID(_ id: Int) -> Note? {
        self.notesTask?.cancel()
        var result: Note?
        let resource = RequestBuilder.getNoteByID(id)
        self.notesTask = client.load(resource: resource) {[weak self] response in
            DispatchQueue.main.async {
                if let note = response.value {
                    result = note
                } else if let error = response.error {
                    self?.handleError(error)
                    result = nil
                }
            }
        }
        
        return result
    }
    
    @IBAction func onPut(_ sender: UIBarButtonItem) {
        self.notesTask?.cancel()
        let resource = RequestBuilder.updateNoteByID(1)
        self.notesTask = client.load(resource: resource) {[weak self] response in
            DispatchQueue.main.async {
                if let note = response.value {
                    self?.showAlert(message: "\(note.title ?? "No title")")                    
                } else if let error = response.error {
                    self?.handleError(error)
                }
            }
        }
    }
    
    @IBAction func onPost(_ sender: UIBarButtonItem) {
        self.notesTask?.cancel()
        var resource = RequestBuilder.createNote()        
        resource.params = ["title": "new update"]
        self.notesTask = client.load(resource: resource) {[weak self] response in
            DispatchQueue.main.async {
                if let note = response.value {
                    self?.notes?.append(note)
                } else if let error = response.error {
                    self?.handleError(error)
                }
            }
        }
    }
    
    @IBAction func onDelete(_ sender: UIBarButtonItem) {
        self.notesTask?.cancel()
        let resource = RequestBuilder.deleteNoteByID(1)
        self.notesTask = client.load(resource: resource) {[weak self] response in
            self?.notes?.remove(at: 1)
        }
    }
    
    // MARK: - Notes handling
    
    func loadNotes() {
        self.notesTask?.cancel()
        let resource = RequestBuilder.getAllNotes()
        self.notesTask = client.load(resource: resource) {[weak self] response in
            self?.notes = response.value
        }
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
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
        }
        
        return cell
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

