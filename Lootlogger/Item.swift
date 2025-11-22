//
//  Item.swift
//  Lootlogger
//
//  Created by Amath Benoit Gaye on 11/7/25.
//

//
//  Item.swift
//  Lootlogger
//
//  Created by Amath Benoit Gaye on 11/7/25.
//

import UIKit

// 1. Add conformance to the Equatable protocol
class Item: Equatable, Codable {
    
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: Date
    
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        
        return lhs.name == rhs.name &&
               lhs.valueInDollars == rhs.valueInDollars &&
               lhs.serialNumber == rhs.serialNumber &&
               lhs.dateCreated == rhs.dateCreated
    }
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
    }
    
    
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]

            let randomAdjective = adjectives.randomElement()!
            let randomNoun = nouns.randomElement()!

            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int.random(in: 0..<100)
            let randomSerialNumber =
                UUID().uuidString.components(separatedBy: "-").first!

            self.init(name: randomName,
                      serialNumber: randomSerialNumber,
                      valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
}
