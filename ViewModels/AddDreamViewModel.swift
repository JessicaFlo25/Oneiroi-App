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
    
}
