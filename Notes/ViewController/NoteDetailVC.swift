//
//  NoteDetailVC.swift
//  Notes
//
//  Created by Jozef Vrana on 11/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import UIKit

class NoteDetailVC: UIViewController {
    
    var note: Note?
    @IBOutlet weak var noteTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = self.note {
            self.noteTV.text = note.title
        }
    }
}
