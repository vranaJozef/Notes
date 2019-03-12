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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testURL() {
        let url = URL(string: "https://private-anon-19453e7412-note10.apiary-mock.com/notes")!
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            XCTAssert(error == nil, "Error")
        }
        dataTask.resume()
    }
}
