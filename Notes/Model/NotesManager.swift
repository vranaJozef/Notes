//
//  NotesManager.swift
//  Notes
//
//  Created by Jozef Vrana on 11/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

protocol NotesManagerDelegate {
    func updateNotes(_ notes: Notes?)
}

class NotesManager {
    
    let client = Client.init(baseUrl: "https://private-anon-19453e7412-note10.apiary-mock.com")
    var notesTask: URLSessionTask?
    var notes: Notes? {
        didSet {
            self.delegate?.updateNotes(self.notes)
        }
    }
    var delegate: NotesManagerDelegate?
    
    func getAllNotes(completion: @escaping ((_ error: WebError<APIError>?) -> Void)) {
        self.notesTask?.cancel()
        let resource = RequestBuilder.getAllNotes()
        self.notesTask = client.load(resource: resource) {[weak self] response in
            if let notes = response.value {
                completion(nil)
                self?.notes = notes
            } else if let error = response.error {
                completion(error)
            }
        }
    }
    
    func getNoteByID(id: Int, completion: @escaping ((_ error: WebError<APIError>?) -> Void)) {
        self.notesTask?.cancel()
        let resource = RequestBuilder.getNoteByID(id)
        self.notesTask = client.load(resource: resource) {[weak self] response in
            if let note = response.value {
                completion(nil)
                if let index = self?.notes?.index(where: {$0.id == id}) {
                    self?.notes?[index] = note
                }
            } else if let error = response.error {
                completion(error)
            }
            
        }
    }
    
    func createNote() {
        let note = Note(id: (self.notes?.count)! + 1, title: "")
        self.notes?.append(note)
    }
    
    func postNote(text: String, completion: @escaping ((_ error: WebError<APIError>?) -> Void)) {
        self.notesTask?.cancel()
        var resource = RequestBuilder.createNote()
        resource.params = ["title": text]
        self.notesTask = client.load(resource: resource) {[weak self] response in
            if let note = response.value {
                self?.notes?.append(note)
                completion(nil)
            } else if let error = response.error {
                completion(error)
            }
        }
    }
    
    func updateNoteByID(id: Int, completion: @escaping ((_ note: Note?, _ error: WebError<APIError>?) -> Void)) {
        self.notesTask?.cancel()
        let resource = RequestBuilder.updateNoteByID(id)
        self.notesTask = client.load(resource: resource) {[weak self] response in
            if let note = response.value {
                if self?.notes != nil {                    
                    self?.notes?[id - 1] = note
                    completion(note, nil)
                }
            } else if let error = response.error {
                completion(nil, error)
            }            
        }
    }
    
    func deleteNoteByID(id: Int, completion: @escaping ((_ error: WebError<APIError>?) -> Void)) {
        self.notesTask?.cancel()
        let resource = RequestBuilder.deleteNoteByID(id)
        self.notesTask = client.load(resource: resource) {[weak self] response in
            self?.notes?.remove(at: id)
            if let error = response.error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }    
}
