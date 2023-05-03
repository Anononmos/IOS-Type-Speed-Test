//
//  StopWatchManager.swift
//  Type Test
//
//  Created by Kashif Mushtaq on 2021-06-07.
//

import Foundation
import SwiftUI

class StopWatchManager: ObservableObject {
    
    private var timer = Timer()
    private var time = Time()
    
    @Published var timeString = "00:00"
    @Published var mode: stopWatchMode = .stopped
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            self.time.increment()
            self.timeString = self.time.asString
            self.mode = .running
        }
    }
    
    func pause() {
        timer.invalidate()
        mode = .paused
    }
    
    func stop() {
        timer.invalidate()
        time = Time()
        timeString = "00:00"
        mode = .stopped
    }
    
    func calculateRate(_ n: Int) -> Double {
        let time = Double(time.minutes) + Double(time.seconds) / 60
        return Double(n) / time
    }
}

enum stopWatchMode {
    case running, stopped, paused
}
