//
//  NetworkMonitor.swift
//  ChatCompanion
//
//  Created by Nazik on 7.04.2024.
//

import Network

class NetworkMonitor {
    private let monitor = NWPathMonitor()

    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                Logger.log("Internet connection is active")
            } else {
                Logger.log("No internet connection")
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
