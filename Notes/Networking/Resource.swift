//
//  Resource.swift
//  Notes
//
//  Created by Jozef Vrana on 10/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

public struct Resource<A, CustomError> {
    let path: Path
    var method: HTTPMethods
    var headers: HTTPHeaders
    var params: JSON
    let parse: (Data) -> A?
    let parseError: (Data) -> CustomError?
    
    init(path: String,
         method: HTTPMethods = .get,
         params: JSON = [:],
         headers: HTTPHeaders = [:],
         parse: @escaping (Data) -> A?,
         parseError: @escaping (Data) -> CustomError?) {
        
        self.path = Path(path)
        self.method = method
        self.params = params
        self.headers = headers
        self.parse = parse
        self.parseError = parseError
    }
}

extension Resource where A: Decodable, CustomError: Decodable {
    init(jsonDecoder: JSONDecoder,
         path: String,
         method: HTTPMethods = .get,
         params: JSON = [:],
         headers: HTTPHeaders = [:]) {
        
        var newHeaders = headers
        newHeaders["Content-Type"] = "application/json"
        
        self.path = Path(path)
        self.method = method
        self.params = params
        self.headers = newHeaders
        self.parse = {
            try? jsonDecoder.decode(A.self, from: $0)
        }
        self.parseError = {
            try? jsonDecoder.decode(CustomError.self, from: $0)
        }
    }
}
