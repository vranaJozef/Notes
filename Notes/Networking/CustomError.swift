//
//  CustomError.swift
//  Notes
//
//  Created by Jozef Vrana on 11/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

struct CustomError: Error, Decodable {
    var message: String
}
