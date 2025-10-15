//
//  RandomView.swift
//  LotteryRandomNumbers
//
//  Created by Chris Milne on 06/10/2025.
//

import SwiftUI
import SwiftData

struct RandomView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var numbers: [LotteryFile]
    let pickerSelected: String
    @State var mainLength: Int = 0  // 5, 6
    @State var extraLength: Int = 0 // 0, 1, 2
    @State var mainMax: Int = 0     // 39, 47, 50, 59
    @State var extraMax: Int = 0    // 10, 12, 39
    @State var mainArray: String = ""
    @State var extraArray: String = ""
    @State var LSelected: lottoData = .Lotto
    enum lottoData: String, CaseIterable {
        case Lotto = "Lotto"
        case EuroMillions = "EuroMillions"
        case ThunderBall   = "ThunderBall"
        case SetforLife = "SetforLife"

        var mainLength: Int {
            switch self {
            case .Lotto: return (5)
            case .EuroMillions: return (4)
            case .ThunderBall: return (4)
            case .SetforLife: return (4)

            }
        }
        var extraLength: Int {
                switch self {
                case .Lotto: return 0
                case .EuroMillions: return 2
                case .ThunderBall: return 1
                case .SetforLife: return 1

                }
            }
            
            var mainMax: Int {
                switch self {
                case .Lotto: return 59
                case .EuroMillions: return 50
                case .ThunderBall: return 39
                case .SetforLife: return 47
                }
            }
        var extraMax: Int {
                switch self {
                case .Lotto: return 50
                case .EuroMillions: return 12
                case .ThunderBall: return 14
                case .SetforLife: return 10
                }
            }
    }
    var body: some View {
VStack {
    Text(pickerSelected)
        .font(.title)
        .frame(alignment: .center)
        }
        List {
            ForEach(numbers) { number in
                if number.lotName == pickerSelected {
                    NavigationLink {
                        Image(number.lotName)
                        Text("\(number.lotName)")
                            .font(.title)
                                Text("Main:\(number.Main)").font(.title2)
                        if extraLength > 0 { Text("Extra:\(number.Extra)") }

                    } /// navLink
                    
                    label: {
                            Text("\(number.savedDate, format: Date.FormatStyle(date: .numeric))")
                    } /// label
                } /// if
            } /// For Each
            .onDelete(perform: deleteItems)
    } /// List

        .onAppear { updateLotteryProperties() }
        .navigationTitle(
                     "Lottery Dates")
                 .navigationBarTitleDisplayMode(.inline)
                 .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                } /// toolbaritem
                ToolbarItem {
                    Button(action: {
                        addMain(mainLength: mainLength, mainMax: mainMax, extraMax: extraMax, extraLength: extraLength)
                    }) {
                        Text("Add")
                            .fontWeight(.bold)
                    }
                    .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10.0)
                } /// toolbaritem
                } /// Toolbar
    } /// Body
    
    func addMain(mainLength: Int, mainMax: Int, extraMax: Int, extraLength: Int) {
        var long = [Int]()
        
        for _ in 0...mainLength {
            let Randlong = Int.random(in:1...mainMax)
            long.append(Randlong)
        }
        let setlong = Set(long)
        if setlong.count != long.count {
            addMain(mainLength: mainLength, mainMax: mainMax, extraMax: extraMax, extraLength: extraLength)
        } else {
        let resultlong: [Int] = long.sorted()
            addExtra(resultlong: resultlong, extraMax: extraMax, extraLength: extraLength)
       }
    } /// func
    
    func addExtra(resultlong: [Int], extraMax: Int, extraLength: Int) {
        var short = [Int]()
        var resultshort = [Int]()
    
        if extraLength < 2 {
          resultshort = [Int.random(in: 1...extraMax)]
        } else {
            for _ in 0...extraLength - 1 {
                let Randextra = Int.random(in:1...extraMax)
                short.append(Randextra)
            } ///  For
            let setextra = Set(short)
            if setextra.count != short.count {
                addExtra(resultlong: resultlong, extraMax: extraMax, extraLength: extraLength)
            } /// If
            resultshort  = short.sorted()
        } /// else 1
      if extraLength == 0 { resultshort.remove(at:0) }
        fileUpdate(resultlong: resultlong, resultshort: resultshort)
    } /// func
            
    func fileUpdate(resultlong: [Int], resultshort: [Int]) {
                let newSelection = LotteryFile(lotName: pickerSelected, savedDate: Date(), Main: resultlong, Extra: resultshort)
                modelContext.insert(newSelection)
            }   /// func fileupdate
    
   func updateLotteryProperties() {
        if let selected = lottoData(rawValue: pickerSelected) {
            LSelected = selected
            mainLength = LSelected.mainLength
            extraLength = LSelected.extraLength
            mainMax = LSelected.mainMax
            extraMax = LSelected.extraMax
            
        }
    }

       func deleteItems(offsets: IndexSet) {
            withAnimation {
                for index in offsets {
                    modelContext.delete(numbers[index])
                }
            }
        }
   
    } /// Struct
     

        #Preview {
            RandomView(pickerSelected: "Lotto")
                .modelContainer(for: LotteryFile.self, inMemory: true)
        }

