//
//  ViewController.swift
//  SingpostStoreSample
//
//  Created by odnairy on 11.11.22.
//

import UIKit
import OSLog
import MapKit
import os

class ViewController: UIViewController {

    let poster = OSSignposter()
    var state: OSSignpostIntervalState!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let mapView = MKMapView(frame: view.bounds)
        view.addSubview(mapView)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        let signpostID = poster.makeSignpostID()
        state = poster.beginInterval("View", id: signpostID)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        poster.endInterval("View", state)

        let env = ProcessInfo.processInfo.environment

        let s = env.map({ "\($0.key) \($0.value)\n" }).sorted().joined()
        print(s)

        if RunMode() == .uiTest {
            runExecution()
        }
    }

    func runExecution() {
        let runner = SignpostLoggerTestRunner(loggerMode: .logger)
        runner.executeOSLog()
        runner.executeLegacyOSLog()
    }

    enum RunMode {
        case debugRun
        case unitTest
        case uiTest

        var isTest: Bool { self == .unitTest || self == .uiTest }

        init() {
            let env = ProcessInfo.processInfo.environment
            if env["XCTestBundlePath"] != nil {
                self = .unitTest
            } else if env["DYLD_LIBRARY_PATH"] != nil {
                self = .debugRun
            } else {
                self = .uiTest
            }
        }
    }

}
