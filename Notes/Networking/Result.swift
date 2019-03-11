//
//  Result.swift
//  Notes
//
//  Created by Jozef Vrana on 10/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

public enum Result<A, CustomError> {
    case success(A?)
    case failure(WebError<CustomError>?)
}

extension Result {
    init(value: A?, or error: WebError<CustomError>?) {
        
        guard let value = value else {
            guard let error = error else {
                self = .success(nil)
                return
            }
            
            self = .failure(error)
            return
        }
        
        self = .success(value)
    }
    
    var value: A? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    var error: WebError<CustomError>? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}
