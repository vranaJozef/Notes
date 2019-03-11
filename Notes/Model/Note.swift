//
//  Note.swift
//  Notes
//
//  Created by Jozef Vrana on 10/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

typealias Notes = [Note]

struct Note: Decodable {
    
    let id: Int?
    let title: String?
}

