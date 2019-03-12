//
//  NoteCreateVC.swift
//  Notes
//
//  Created by Jozef Vrana on 12/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import UIKit

protocol NoteCreateVCDelegate {
    func didPostNote(_ error: WebError<APIError>?)
}

class NoteCreateVC: UIViewController {
    
    var notesManager: NotesManager?
    var delegate: NoteCreateVCDelegate?    
    @IBOutlet weak var noteTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noteTV.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.notesManager?.postNote(text: self.noteTV.text, completion: { error in
            if let error = error {
                self.delegate?.didPostNote(error)
            } else {
                self.delegate?.didPostNote(nil)
            }
        })
    }
}
