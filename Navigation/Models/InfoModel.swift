//
//  InfoModel.swift
//  Navigation
//
//  Created by Toha Shilin on 4.11.25.
//
import Foundation


struct ToDoTask: Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case completed
    }
}

struct Planet: Decodable {
    var name: String
    var rotation_period: String
    var orbital_period: String
    var diameter: String
    var climate: String
    var gravity: String
    var terrain: String
    var surface_water: String
    var population: String
    var residents: [String]
    var films: [String]
    var created: String
    var edited: String
    var url: String
}
