//
//  NotesTests.swift
//  NotesTests
//
//  Created by Jozef Vrana on 10/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import XCTest
@testable import Notes

class NotesTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testGET() {
        let url = URL(string: "https://private-anon-19453e7412-note10.apiary-mock.com/notes")!
        let request = URLRequest(url: url)
        let testExpectation = expectation(description: "GET \(url)")
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            XCTAssert(httpResponse?.statusCode == 200, "Status code is not matching the server data")
            testExpectation.fulfill()
        }
        dataTask.resume()
        waitForExpectations(timeout: 5){ error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
