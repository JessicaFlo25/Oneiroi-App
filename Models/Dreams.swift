//
//  Dreams.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 3/19/25.
//

import Foundation
import SwiftData

@Model
final class Dream {
    @Attribute(.unique) var id: UUID//ensures no repeats
    var dreamDescription: String
    var title: String
    var date: Date
    //initializer
    init(description: String, title: String, date: Date = Date()) {
        self.id = UUID()
        self.dreamDescription = description
        self.title = title
        self.date = date
    }
}
