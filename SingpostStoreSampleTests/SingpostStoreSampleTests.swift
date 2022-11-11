//
//  SingpostStoreSampleTests.swift
//  SingpostStoreSampleTests
//
//  Created by odnairy on 11.11.22.
//

import XCTest
@testable import SingpostStoreSample
import OSLog

final class SingpostStoreSampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let logStore = try OSLogStore(scope: .currentProcessIdentifier)

        let obj = TestClass()
        obj.executeRandom()

        XCTAssertTrue(obj.signposter.isEnabled)
        obj.signposter.emitEvent("Hello World")
        

        try logStore.getEntries().forEach { entry in

            switch entry {
            case let signpost as OSLogEntrySignpost:
                print(signpost)
                assertionFailure()
            case let logEntry as OSLogEntryLog:
                print("""
                        subsystem: \(logEntry.subsystem)
                        \(logEntry.date)
                        \(logEntry.composedMessage)
""")

            default:
                assertionFailure()
                break
            }

//            print("OSSignposter.disabled:", OSSignposter.isEnabled)

            
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
