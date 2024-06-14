//
//  Int+Extensions.swift
//  
//
//  Created by Nikolai Nobadi on 6/14/24.
//

extension Int {
    var formattedString: String {
        let interval = self
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        if hours > 0 {
            return String(format: "%d hours, %d minutes, %d seconds", hours, minutes, seconds)
        } else if minutes > 0 {
            return String(format: "%d minutes, %d seconds", minutes, seconds)
        } else {
            return String(format: "%d seconds", seconds)
        }
    }
}
