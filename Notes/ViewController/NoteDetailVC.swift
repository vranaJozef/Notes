//
//  NoteDetailVC.swift
//  Notes
//
//  Created by Jozef Vrana on 11/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import UIKit

protocol NoteDetailVCDelegate {
    func didUpdateNote(_ error: WebError<APIError>?)
}

class NoteDetailVC: UIViewController {
    
    var note: Note?
    var notesManager: NotesManager?
    var delegate: NoteDetailVCDelegate?
    
    @IBOutlet weak var noteTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noteTV.becomeFirstResponder()        
        if let note = self.note {
            self.noteTV.text = note.title            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                
        if let id = self.note?.id {
            if self.note?.title != self.noteTV.text {
                self.notesManager?.updateNoteByID(id: id, completion: { (note, error) in
                    if let error = error {
                        self.delegate?.didUpdateNote(error)
                    } else {
                        self.delegate?.didUpdateNote(nil)
                    }
                })
            }
        }
    }
}
