import XCTest
@testable import SingpostStoreSample
import OSLog

final class SingpostStoreSampleTests: XCTestCase {
    var logStore: OSLogStore!

    override func setUpWithError() throws {
        logStore = try OSLogStore(scope: .currentProcessIdentifier)
    }

    override func tearDownWithError() throws {
        logStore = nil
    }

    func testSignpostIntervalWithDefaultSignposter() async throws {
        let obj = SignpostLoggerTestRunner(loggerMode: .default)
        obj.executeOSLog()

        let signpostLogs = try logStore.getEntries().map({ $0 })
            .filter { $0 is OSLogEntrySignpost }
        XCTAssertGreaterThan(signpostLogs.count, 0)
    }

    func testSignpostIntervalWithOSLogSignposter() async throws {
        let obj = SignpostLoggerTestRunner(loggerMode: .oslog)
        obj.executeOSLog()

        let signpostLogs = try logStore.getEntries().map({ $0 })
            .filter { $0 is OSLogEntrySignpost }
        XCTAssertGreaterThan(signpostLogs.count, 0)
    }

    func testSignpostIntervalWithLoggerSignposter() async throws {
        let obj = SignpostLoggerTestRunner(loggerMode: .logger)
        obj.executeOSLog()

        let signpostLogs = try logStore.getEntries().map({ $0 })
            .filter { $0 is OSLogEntrySignpost }
        XCTAssertGreaterThan(signpostLogs.count, 0)
    }

    func testSignpostIntervalWithLegacyAPI() async throws {
        let obj = SignpostLoggerTestRunner(loggerMode: .default)
        obj.executeLegacyOSLog()

        let signpostLogs = try logStore.getEntries().map({ $0 })
            .filter { $0 is OSLogEntrySignpost }
        XCTAssertGreaterThan(signpostLogs.count, 0)
    }

}
