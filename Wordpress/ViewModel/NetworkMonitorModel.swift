//
//  NetworkMonitorModel.swift
//  Wordpress
//
//  Created by Asil Arslan on 19.08.2021.
//

import Foundation
import Network

final class NetworkMonitorModel: ObservableObject {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected = true
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }
    
}

