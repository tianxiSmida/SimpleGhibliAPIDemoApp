//
//  Film.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/12.
//

import Foundation

struct Film {
    // 會在此物件初始化時, 做部分資料前處理
    // 例如 API的命名與本地不相同, 部分資訊需要拼接 ...etc
    let id: String
    let title: String
    let description: String
    let director: String
    let producer: String
    let releaseYear: String
    let score: String
    let duration: String
    let image: String
    let bannerImage: String
    let people: [String]
    
    init(film: GBLFilm) {
        self.id = film.id
        self.title = film.title
        self.description = film.description
        self.director = film.director
        self.producer = film.producer
        self.releaseYear = film.releaseYear
        self.score = film.score
        self.duration = film.duration
        self.image = film.image
        self.bannerImage = film.bannerImage
        self.people = film.people
    }
}
