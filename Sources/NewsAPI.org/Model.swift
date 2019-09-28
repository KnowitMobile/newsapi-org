//
//  File.swift
//  
//
//  Created by magwis on 2019-09-28.
//

import Foundation

public struct NewsAPIResponse: Decodable {
    public var status: String
    public var totalResults: Int
    public var articles: [Article]
}

public struct Article: Decodable {
    public var source: Source
    public var author: String?
    public var title: String
    public var description: String
    public var url: String
    public var urlToImage: String?
    public var publishedAt: Date
    public var content: String?
}

public struct Source: Decodable {
    public var id: String?
    public var name: String
}
