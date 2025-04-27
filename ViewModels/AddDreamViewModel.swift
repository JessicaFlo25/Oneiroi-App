//
//  AddDreamViewModel.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/19/25.
//

import Foundation
import Combine
import SwiftData
//logic pertaining to user inputs in the add dream view

class AddDreamViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var dreamDescription: String = ""
    @Published var date: Date = Date()
    @Published var titleErrorMessage: String = ""
    @Published var dreamDescriptionErrorMessage: String = ""
    //booleans to determine popup/call to gemini
    @Published var allValid: Bool = false //need before proceeding
    @Published var navigateToDreamAnalysis : Bool = false  //will determine if call to gemini will be made
    @Published var dreamDescriptionForAnalysis: String = "" //after passing down full dream to dreamanayliss view need to save the description so it is accesible from dreamanalysis view
    @Published var currentDream: Dream?
    
    //check title input to provide more detailed UI error messages
    func validateTitle() -> Bool {
        //check if empty
        if title.isEmpty {
            titleErrorMessage = "Title is required"
            return false
        }
        //valid
//        titleIsValid = true
        titleErrorMessage = ""
        return true
    }
    
    //check description
    func validateDescription() -> Bool {
        if dreamDescription.isEmpty {
            dreamDescriptionErrorMessage = "Description is required"
            return false
        }
//        dreamDescriptionIsValid = true
        dreamDescriptionErrorMessage = ""
        return true
    }
    //function to display dream counts only in preview since on build, data will not persist
    func printSavedDreams(modelContext: ModelContext) {
        do {
            //create a query to fetch data with the the most recent additions first i.e., ".reverse"
            let descriptor = FetchDescriptor<Dream>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            
            //manually save to avoid stale data
            modelContext.autosaveEnabled = true
            //executes the query above that fetches data with most recent being at the top
            let dreams = try modelContext.fetch(descriptor)
            //print to console
            print("\n=== Saved Dreams ===")
            if dreams.isEmpty {
                print("No dreams found in database")
            } else {
                dreams.forEach { dream in
                    print("""
                    Title: \(dream.title)
                    Description: \(dream.dreamDescription)
                    Date: \(dream.date.formatted())
                    ----------------------
                    """)
                }
            }
            print("Total dreams: \(dreams.count)\n")
        } catch {
            print("Failed to fetch dreams: \(error.localizedDescription)")
        }
    }
    
    
}
