//
//  Dreams.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/19/25.
//

import Foundation
import SwiftData

@Model
class Dream {
    var dreamDescription: String
    var title: String
    var date: Date
    //initializer
    init(description: String, title: String, date: Date) {
        self.dreamDescription = description
        self.title = title
        self.date = date
    }
}
