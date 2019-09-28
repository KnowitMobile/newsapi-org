//
//  File.swift
//  
//
//  Created by magwis on 2019-09-28.
//

import Foundation

struct NewsAPIResponse: Decodable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

struct Article: Decodable {
    var source: Source
    var author: String?
    var title: String
    var description: String
    var url: String
    var urlToImage: String?
    var publishedAt: Date
    var content: String?
}

struct Source: Decodable {
    var id: String?
    var name: String
}
