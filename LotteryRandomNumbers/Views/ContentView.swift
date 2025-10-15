//
//  ContentView.swift
//  LotteryRandomNumbers
//
//  Created by Chris Milne on 06/10/2025.
//
/*// 1. User taps a lottery button (e.g., "Lotto")
 Button {
 tabIndex = idx
 pickerSelected = tabBarDataList[idx].lable  // pickerSelected = "Lotto"
 }
 
 // 2. User taps "Continue" button
 .onTapGesture {
 if !pickerSelected.isEmpty {
 navPath.append(pickerSelected)  // Adds "Lotto" to the navigation path
 }
 }
 
 // 3. NavigationStack detects something was added to navPath
 .navigationDestination(for: String.self) { selectedGame in
 // selectedGame automatically receives the String value from navPath
 // In this case: selectedGame = "Lotto"
 RandomView(pickerSelected: selectedGame)  // Passes "Lotto" to RandomView
 }
 */

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var numbers: [LotteryFile]
    @State private var navPath = NavigationPath()
    let topText = ["Random Lottery Numbers", "Generate random numbers \nfor your favourite lotteries", "Choose your Numbers for\n EuroMillions, Lotto\n Thunderball, Set for Life"]
    @State private var tabIndex: Int? = nil
    @State var pickerSelected: String = ""
    
    let tabBarDataList = [
        barData(lable: "Lotto", img: "Lotto", drawDays: "Draw Days: Wed, Sat", costPerPlay: "£2.00 per play", prize: "Max Win: £5 Million"),
        barData(lable: "EuroMillions", img: "EuroMillions", drawDays: "Draw Days: Tues, Fri", costPerPlay: "£2.50 per play", prize: "Max Win: £14 Million"),
        barData(lable: "ThunderBall", img: "ThunderBall", drawDays: "Draw Days: Tues, Wed, Fri, Sat", costPerPlay: "£1.00 per play", prize: "Max Win: £500K"),
        barData(lable: "SetforLife", img: "SetforLife", drawDays: "Draw Days: Mon, Thurs", costPerPlay: "£1.50 per play", prize: "£10K per week for 30 years")
        
    ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(spacing: 5) {
                    topTextSection
                    
                    lotterySelectionGrid
                }
                .navigationDestination(for: String.self) { selectedGame in
                    RandomView(pickerSelected: selectedGame)
                }  /// Nav Dest
            } // VStack
        } /// ScrollView
    } /// Nav Stack
    
    // Break into computed properties
        var topTextSection: some View {
            VStack(spacing: 10) {
                ForEach(topText, id: \.self) { text in
                    Text(text)
                       .padding(5)
                        .background(.blue)
                        .foregroundColor(.white)
                        .font(.title3)
                        .cornerRadius(8)
                    
                } /// For Each
            }/// VStack
            } /// VAR
    
   var lotterySelectionGrid: some View {
        VStack(spacing: -12) {
            ForEach(0 ..< tabBarDataList.count, id: \.self) { idx in
                lotteryRow(for: idx)
            } /// For Each
        } /// VStack
        .padding()
    } /// VAR
    
   func lotteryRow(for idx: Int) -> some View {
       HStack {
            lotteryInfo(for: idx)

            lotteryButton(for: idx)
        } /// HStack
        .background(tabIndex == idx ? Color.blue.opacity(0.3) : Color.clear)
        .cornerRadius(8)
        .padding()
    } /// Func
    
    func lotteryInfo(for idx: Int) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(tabBarDataList[idx].lable)
                .font(.headline)
            Text(tabBarDataList[idx].prize)
                .font(.subheadline)
            Text(tabBarDataList[idx].costPerPlay)
            Text(tabBarDataList[idx].drawDays)
        } /// VStack
        .frame(maxWidth: .infinity, alignment: .leading)
    } /// Func
    
     func lotteryButton(for idx: Int) -> some View {
        Button {
            tabIndex = idx
            pickerSelected = tabBarDataList[idx].lable
            navPath.append(pickerSelected)
        } label: {
            Image(tabBarDataList[idx].img)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 50)
        } /// Label
    } /// Func
} /// Struct
struct barData: Identifiable {
    var id = UUID()
    var lable: String
    var img: String
    var drawDays: String
    var costPerPlay: String
    var prize: String
    
}

#Preview {
    ContentView()
        .modelContainer(for: LotteryFile.self, inMemory: true)
}

