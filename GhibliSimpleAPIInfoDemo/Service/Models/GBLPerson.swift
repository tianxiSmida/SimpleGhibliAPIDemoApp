//
//  GBLPerson.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/12.
//

import Foundation

struct GBLPerson: Identifiable, Decodable, Equatable, Encodable {
    let id: String
    let name: String
    let gender: String
    let age: String
    let eyeColor: String
    let hairColor: String
    let films: [String]
    let species: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, gender, age, films, species, url
        case eyeColor = "eye_color"
        case hairColor = "hair_color"
    }
}

extension GBLPerson {
    static var sample1 = GBLPerson(id: "598f7048-74ff-41e0-92ef-87dc1ad980a9",
                                   name: "Lusheeta Toel Ul Laputa",
                                   gender: "Female", age: "13",
                                   eyeColor: "Black",
                                   hairColor: "Black",
                                   films: ["https://swapi.dev/api/films/1/"],
                                   species: "Wookiee",
                                   url: "https://swapi.dev/api/people/598f7048-74ff-41e0-92ef-87dc1ad980a9/")
    
    static var sample2 = GBLPerson(
        id: "fe93adf2-2f3a-4ec4-9f68-5422f1b87c01",
        name: "Pazu",
        gender: "Male",
        age: "13",
        eyeColor: "Black",
        hairColor: "Brown",
        films: ["https://swapi.dev/api/films/1/"],
        species: "Wookiee",
        url: "https://swapi.dev/api/people/fe93adf2-2f3a-4ec4-9f68-5422f1b87c01/")
}

