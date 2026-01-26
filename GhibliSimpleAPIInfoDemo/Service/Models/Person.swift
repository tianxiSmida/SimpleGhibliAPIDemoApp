//
//  Person.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/22.
//

struct Person: Identifiable, Decodable, Equatable {
    let id: String
    let name: String
    let gender: String
    let age: String
    let eyeColor: String
    let hairColor: String
    
    init(person: GBLPerson) {
        self.id = person.id
        self.name = person.name
        self.gender = person.gender
        self.age = person.age
        self.eyeColor = person.eyeColor
        self.hairColor = person.hairColor
    }
}
