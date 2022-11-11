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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let mapView = MKMapView(frame: view.bounds)
        view.addSubview(mapView)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        TestClass().executeRandom()
    }


}

public class TestClass {

    public let log: OSLog
    public let oslog: os.OSLog

    public let signposter: OSSignposter

    public init() {
        log = OSLog(subsystem: "com.personal.sample", category: "General")
        oslog = os.OSLog(subsystem: "com.personal.sample", category: "General")
//        signposter = OSSignposter(logHandle: log)
        signposter = OSSignposter()
    }

    public func executeRandom() {
        let state = signposter.beginInterval("Random execution")

        let osSignpostID = os.OSSignpostID(log: oslog)
        os_signpost(.begin, log: oslog, name: "os_signpost", signpostID: osSignpostID)

        let duration = Double.random(in: 1..<4)
        print("Going to sleep for \(duration)s")
//        let duration = 5.0
        usleep(useconds_t(duration * 1_000_000))
        signposter.endInterval("Random execution", state)
        os_signpost(.end, log: oslog, name: "os_signpost", signpostID: osSignpostID)
        print("signposter.isEnabled: ", signposter.isEnabled)
    }
}
