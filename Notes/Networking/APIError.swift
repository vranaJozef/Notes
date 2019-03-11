//
//  Error.swift
//  Notes
//
//  Created by Jozef Vrana on 10/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

struct APIError: Error, Decodable {
    var message: String
}
