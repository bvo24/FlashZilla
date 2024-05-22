//
//  Card.swift
//  FlashZilla
//
//  Created by Brian Vo on 5/21/24.
//

import Foundation


struct Card : Codable{
    //We should add an id here
    
    var prompt : String
    var answer : String
    
    static let example = Card(prompt: "Hi im..", answer: "Spongebob")
    
}
