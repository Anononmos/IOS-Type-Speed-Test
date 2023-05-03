//
//  Time.swift
//  Type Test
//
//  Created by Kashif Mushtaq on 2021-06-05.
//

import Foundation

class Time {

    var seconds: Int
    var minutes: Int
    var asString: String {
        return String(format: "%02d:%02d", self.minutes, self.seconds)
    }
    
    init(minutes: Int = 0, seconds: Int = 0) {
        self.seconds = seconds
        self.minutes = minutes
    }
    
    func add(T: Time) {
        
        seconds += T.seconds
        minutes += T.minutes
        
        if seconds >= 60 {
            minutes += seconds / 60
            seconds %= 60
        }
        
        if minutes >= 60 {
            minutes %= 60
        }
    }
    
    func increment() {
        add(T: Time(seconds: 1))
    }
}
