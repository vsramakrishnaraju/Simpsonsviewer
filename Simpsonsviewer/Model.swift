//
//  Model.swift
//  Simpsonsviewer
//
//  Created by Venkata K on 4/26/23.
//

import Foundation

class Character {
    let name: String
    let description: String
    let imageUrl: String?

    init(name: String, description: String, imageUrl: String?) {
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
    }
}
