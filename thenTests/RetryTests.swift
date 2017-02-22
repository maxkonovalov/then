//
//  RetryTests RetryTests.swift
//  then
//
//  Created by Sacha Durand Saint Omer on 22/02/2017.
//  Copyright © 2017 s4cha. All rights reserved.
//

import XCTest
import then

class RetryTests: XCTestCase {
    
    var tryCount = 0
    
    func testRetryNumberWhenKeepsFailing() {
        let e = expectation(description: "")
        testPromise()
        .retry(5).then {
            
        }.onError { _ in
            e.fulfill()
            XCTAssertEqual(5, self.tryCount)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testRetrySucceedsAfter3times() {
        let e = expectation(description: "")
        succeedsAfter3Times()
            .retry(10).then {
                e.fulfill()
                XCTAssertEqual(3, self.tryCount)
            }.onError { _ in
                XCTFail()
            }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testRetryFailsIfNumberOfRetriesposisitethan1() {
        let e = expectation(description: "")
        testPromise()
            .retry(0).onError { _ in
            e.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testPromise() -> Promise<Void> {
        return Promise { _, reject in
            self.tryCount += 1
            reject(ARandomError())
        }
    }
    
    func succeedsAfter3Times() -> Promise<Void> {
        return Promise { resolve, reject in
            self.tryCount += 1
            if self.tryCount == 3 {
                resolve()
            } else {
                reject(ARandomError())
            }
        }
    }
    
}

struct ARandomError: Error { }
