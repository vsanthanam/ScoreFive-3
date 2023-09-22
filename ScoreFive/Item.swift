//
//  Item.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 9/21/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
