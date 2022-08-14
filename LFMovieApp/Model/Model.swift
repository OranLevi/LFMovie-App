//
//  Model.swift
//  LFMovieApp
//
//  Created by Oran on 14/07/2022.
//

import UIKit

struct Genre: Decodable {
    let id: Int
    let name: String?
}

struct Review: Decodable {
    let author: String
    let content: String
}

struct Show: Decodable {
    let name: String
    var id: Int
    var genres: [Genre]?
    let poster: String
    var reviews: [Review]? = nil
    var voteAverage: Double?
    var overview: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case title
        case id
        case genres
        case genre_ids
        case poster = "poster_path"
        case voteAverage = "vote_average"
        case overview
    }
   
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? values.decodeIfPresent(String.self, forKey: .title) ?? "N/A"

        id = try values.decode(Int.self, forKey: .id)

        poster = try values.decode(String.self, forKey: .poster)
        
        voteAverage = try values.decode(Double.self, forKey: .voteAverage)
        
        overview = try values.decode(String.self, forKey: .overview)
        
        if let genresIds = try values.decodeIfPresent([Int].self, forKey: .genre_ids) {
            self.genres = genresIds.map{ genreId in
                return Genre(id: genreId, name: nil)
            }
        }else {
            genres = try values.decode([Genre].self, forKey: .genres)
        }
    }
}
