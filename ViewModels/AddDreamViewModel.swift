//
//  AddDreamViewModel.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/19/25.
//

import Foundation
import Combine
//logic pertaining to user inputs in the add dream view

class AddDreamViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var dreamDescription: String = ""
    @Published var date: Date = Date()
    @Published var titleIsValid: Bool = false
    @Published var dreamDescriptionIsValid: Bool = false
    
    @Published var titleErrorMessage: String = ""
    @Published var dreamDescriptionErrorMessage: String = ""
    
    //check title input to provide more detailed UI error messages
    func validateTitle() -> Bool {
        //check if empty
        if title.isEmpty {
            titleErrorMessage = "Title is required"
            return false
        }
        //valid
        titleIsValid = true
        titleErrorMessage = ""
        return true
    }
    
    //check description
    func validateDescription() -> Bool {
        if dreamDescription.isEmpty {
            dreamDescriptionErrorMessage = "Description is required"
            return false
        }
        dreamDescriptionIsValid = true
        dreamDescriptionErrorMessage = ""
        return true
    }
    
    
    
}
