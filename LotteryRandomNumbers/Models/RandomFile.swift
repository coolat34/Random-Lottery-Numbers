//
//  RandomFile.swift
//  LotteryRandomNumbers
//
//  Created by Chris Milne on 06/10/2025.
//

import Foundation
import SwiftData

@Model
final class LotteryFile {
    var id: UUID = UUID()
    var lotName: String = ""
    var savedDate: Date = Date()
    var Main: [Int] = []
    var Extra: [Int] = []

    init(lotName: String,
         savedDate: Date,
         Main: [Int],
         Extra: [Int]
        ) {
    self.lotName = lotName
    self.savedDate = Date()
    self.Main = Main
    self.Extra = Extra
    
}
}
