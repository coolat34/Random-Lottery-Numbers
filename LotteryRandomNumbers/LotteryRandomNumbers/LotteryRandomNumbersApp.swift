//
//  LotteryRandomNumbersApp.swift
//  LotteryRandomNumbers
//
//  Created by Chris Milne on 06/10/2025.
//

import SwiftUI
import SwiftData

@main
struct LotteryRandomNumbersApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            LotteryFile.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
   //         RandomView(pickerSelected: "Lotto")
        }
        .modelContainer(sharedModelContainer)
    }
}
