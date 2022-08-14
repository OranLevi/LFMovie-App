//
//  NetworkService.swift
//  LFMovieApp
//
//  Created by Oran on 20/07/2022.
//

import UIKit

class NetworkService {
    
    let apiKey = "" // ENTER YOUR API KEY
    
    var service = Service.shard
    
    enum MediaType: String {
        case tv
        case movie
    }
    
    enum SuffixUrl: String {
        case upcoming
        case topRated = "top_rated"
        case popular
    }
    
    func serviceUrl(for suffix: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/\(suffix)"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
        ]
        let url = components.url!
        return url
    }
    
    func serviceSearchUrl(for suffix: String, mediaType: MediaType) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/search/\(mediaType)"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "query", value: suffix),
        ]
        let url = components.url!
        return url
    }
    
    func getSearchResults(searchText: String, mediaType: MediaType) async -> [Show] {
        let url = serviceSearchUrl(for: searchText, mediaType: mediaType)
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let search = try JSONDecoder().decode(ShowResult.self, from: data)
            if mediaType == .tv {
                self.service.filteredDataTv.append(contentsOf: search.results)
            } else if mediaType == .movie {
                self.service.filteredDataMovies.append(contentsOf: search.results)
            }
            return search.results
        } catch {
            print("ERROR: getSearchResults", error)
            return []
        }
    }
    
    func getTrending(_ mediaType: MediaType) async -> [Show] {
        let url = serviceUrl(for: "trending/\(mediaType.rawValue)/day")
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let trending = try JSONDecoder().decode(ShowResult.self, from: data)
            if mediaType == .tv {
                self.service.tvDataArrayTrending.append(contentsOf: trending.results)
            } else if mediaType == .movie {
                self.service.moviesDataArrayTrending.append(contentsOf: trending.results)
            }
            return trending.results
        } catch {
            print("ERROR: getTrending", error)
            return []
        }
    }
    
    func getSuffixUrl(_ mediaType: MediaType, suffixUrl: SuffixUrl) async -> [Show] {
        let url = serviceUrl(for: "\(mediaType.rawValue)/\(suffixUrl.rawValue)")
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let dataSuffixUrl = try JSONDecoder().decode(ShowResult.self, from: data)
            if mediaType == .tv && suffixUrl == .topRated {
                self.service.tvDataArrayTopRated.append(contentsOf: dataSuffixUrl.results)
            } else if mediaType == .tv && suffixUrl == .popular {
                self.service.tvDataArrayPopular.append(contentsOf: dataSuffixUrl.results)
            } else if mediaType == .movie && suffixUrl == .upcoming {
                self.service.moviesDataArrayUpcoming.append(contentsOf: dataSuffixUrl.results)
            } else if mediaType == .movie && suffixUrl == .topRated {
                self.service.moviesDataArrayTopRated.append(contentsOf: dataSuffixUrl.results)
            }else if mediaType == .movie && suffixUrl == .popular {
                self.service.moviesDataArrayPopular.append(contentsOf: dataSuffixUrl.results)
            }
            return dataSuffixUrl.results
        } catch {
            print("ERROR: getSuffixUrl", error)
            return []
        }
    }
    
    func getDetail(_ mediaType: MediaType, id: Int) async -> Show? {
        let url = serviceUrl(for: "\(mediaType.rawValue)/\(id)")
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let show = try JSONDecoder().decode(Show.self, from: data)
            self.service.getDetailDataArray.append(show)
            return show
        } catch {
            print("ERROR: getDetail", error)
            return nil
        }
    }
    
    func getFull(_ mediaType: MediaType) async -> [Show] {
        async let trending = NetworkService().getTrending(mediaType)
        async let upcoming = NetworkService().getSuffixUrl(.movie, suffixUrl: .upcoming)
        async let topRated = NetworkService().getSuffixUrl(mediaType, suffixUrl: .topRated)
        async let popular = NetworkService().getSuffixUrl(mediaType, suffixUrl: .popular)
        let getFull = await trending + upcoming + topRated + popular
        return getFull
    }
    
    func getFullDetail(_ mediaType: MediaType, id: Int) async -> Show? {
        async let show = NetworkService().getDetail(mediaType, id: id)
        async let reviews = NetworkService().getReviews(mediaType, id: id)
        
        var fullShow = await show
        fullShow?.reviews = await reviews
        return fullShow
    }
    
    func getReviews(_ mediaType: MediaType, id: Int) async -> [Review] {
        service.reviewsDataArray = []
        let url = serviceUrl(for: "\(mediaType.rawValue)/\(id)/reviews")
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let reviews = try JSONDecoder().decode(ReviewsResult.self, from: data)
            self.service.reviewsDataArray.append(contentsOf: reviews.results)
            return reviews.results
        } catch {
            print("ERROR: getReviews", error)
            return []
        }
    }
}

struct ShowResult: Decodable {
    let results: [Show]
}

struct ReviewsResult: Decodable {
    let results: [Review]
}
