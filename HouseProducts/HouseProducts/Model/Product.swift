//
//  Product.swift
//  HouseProducts
//
//  Created by Pran Kishore on 26/07/18.
//  Copyright © 2018 Sample Projects. All rights reserved.
//

import Foundation

//User responses for product
enum UserChoice : String {
    case liked
    case unliked
    case undetermined
}

struct Media : Codable {
    let  uri : String
    let  mimeType : String
    
    var url : URL? {
        return URL.init(string: uri)
    }
}

class Product : Codable {
    
    let  sku : String
    let  title : String
    let  description : String?
    let  media : [Media]?
    
    enum CodingKeys: String, CodingKey {
        case sku
        case title
        case description
        case media
    }
    
    var choice = UserChoice.undetermined
    
    //Finding the first available image from the list of media and presenting to user
    var imageMedia : Media? {
        let item = media?.first(where: { (item) -> Bool in
            item.mimeType == "image/png"
        })
        return item
    }
    
    init(serial: String , text : String , describing : String? ) {
        sku = serial
        title = text
        description = describing
        media = []
    }
}

//Generic structue that accepts a codable data type as array
struct Results<Item : Codable> : Codable {
    let articles : [Item]?
    
    enum CodingKeys: String, CodingKey {
        case articles = "articles"
    }
}

//Generic structue that accepts a codable data type as array embedded in a dictionary
struct Response<Item : Codable> : Codable {
    let data : Results<Item>?
    
    enum CodingKeys: String, CodingKey {
        case data = "_embedded"
    }
}
