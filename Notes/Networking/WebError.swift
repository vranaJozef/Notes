//
//  ServiceError.swift
//  Notes
//
//  Created by Jozef Vrana on 10/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

public enum WebError<CustomError>: Error {
    case noInternetConnection
    case custom(CustomError)
    case unauthorized
    case other
}
