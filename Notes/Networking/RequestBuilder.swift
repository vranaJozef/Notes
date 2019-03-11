//
//  RequestBuilder.swift
//  Notes
//
//  Created by Jozef Vrana on 10/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

class RequestBuilder {
    
    class func getAllNotes() -> Resource<Notes, APIError> {
        var resource = Resource<Notes, APIError>(jsonDecoder: JSONDecoder(), path: "/notes")
        resource.method = .get
        return resource
    }
    
    class func getNoteByID(_ id: Int) -> Resource<Note, APIError> {
        var resource = Resource<Note, APIError>(jsonDecoder: JSONDecoder(), path: "/notes/\(id)")
        resource.method = .get
        return resource
    }
    
    class func createNote() -> Resource<Note, APIError> {
        var resource = Resource<Note, APIError>(jsonDecoder: JSONDecoder(), path: "/notes")
        resource.method = .post
        return resource
    }

    class func updateNoteByID(_ id: Int) -> Resource<Note, APIError> {
        var resource = Resource<Note, APIError>(jsonDecoder: JSONDecoder(), path: "/notes/\(id)")
        resource.method = .put
        return resource
    }

    class func deleteNoteByID(_ id: Int) -> Resource<Note, APIError> {
        var resource = Resource<Note, APIError>(jsonDecoder: JSONDecoder(), path: "/notes/\(id)")
        resource.method = .delete
        return resource
    }
}
