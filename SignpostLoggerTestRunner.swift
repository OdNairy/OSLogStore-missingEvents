import Foundation
import OSLog

public class SignpostLoggerTestRunner {

    public let log: OSLog
    public let logger: Logger
    public let loggerMode: LoggerMode

    public enum LoggerMode {
        case `default`
        case oslog
        case logger
        case legacy
    }

    public init(loggerMode: LoggerMode,
                subsystem: String = "com.personal.sample",
                category: String = "General") {
        log = OSLog(subsystem: subsystem, category: category)
        logger = Logger(subsystem: subsystem, category: category)

        self.loggerMode = loggerMode
    }

    func makeSignposter(loggerMode: LoggerMode) -> OSSignposter {
        let signposter: OSSignposter!
        switch loggerMode {
        case .default:
            signposter = OSSignposter()
        case .oslog:
            signposter = OSSignposter(logHandle: log)
        case .logger:
            signposter = OSSignposter(logger: logger)
        case .legacy:
            signposter = nil
        }
        return signposter
    }

    private func executeSleep() {
        let duration = Double.random(in: 1..<4)
        print("Going to sleep for \(duration)s")

        usleep(useconds_t(duration * 1_000_000))
    }

    public func executeOSLog() {
        let signposter = makeSignposter(loggerMode: loggerMode)
        let signpostID = signposter.makeSignpostID()
        let state = signposter.beginInterval(#function, id: signpostID, "loggerMode: \(String(describing: self.loggerMode))")

        signposter.emitEvent("Going to sleep", id: signpostID)
        executeSleep()

        signposter.endInterval(#function, state)
        print("signposter.isEnabled: ", signposter.isEnabled)
    }

    public func executeLegacyOSLog() {
        let osSignpostID = OSSignpostID(log: log)
        os_signpost(.begin, log: log, name: "os_signpost", signpostID: osSignpostID)

        executeSleep()

        os_signpost(.end, log: log, name: "os_signpost", signpostID: osSignpostID)
    }
}

