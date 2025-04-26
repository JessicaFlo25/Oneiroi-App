//
//  DreamHomeViewModel.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/25/25.
//

import Foundation
import SwiftData

//methods to fetch all objects and dispaly them
//
//class DreamHomeViewModel: ObservableObject {
//    private let modelContext: ModelContext
//    @Published var dreams: [Dream] = []
//    
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//        displayAllDreams()
//    }
//    
//    func displayAllDreams() {
//        do {
//            let descriptor = FetchDescriptor<Dream>(sortBy: [SortDescriptor(\.date, order: .reverse)])
//            dreams = try modelContext.fetch(descriptor)
//        } catch {
//            print("Failed to fetch dreams: \(error.localizedDescription)")
//            dreams = []
//        }
//    }
//}
//
