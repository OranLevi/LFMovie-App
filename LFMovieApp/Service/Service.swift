//
//  Service.swift
//  LFMovieApp
//
//  Created by Oran on 14/07/2022.
//

import UIKit

class Service {
    
    static var shard : Service = Service()
    
    enum tabBarNumber: Int{
        case featured = 0
        case movies = 1
        case tv = 2
        case watchList = 3
    }
    
    enum SectionName: Int {
        case Trading = 0
        case Upcoming = 1
        case TopRated = 2
        case Popular = 3
    }
    
    var indexSection:Int?
    var selectedShow: Show?
    var checkIfInWatchList = false
    
    // MARK: - Tv Arrays
    
    var tvDataArrayTrending = [Show]()
    var tvDataArrayTopRated = [Show]()
    var tvDataArrayPopular = [Show]()
    
    // MARK: - Movies Arrays
    
    var moviesDataArrayTrending = [Show]()
    var moviesDataArrayUpcoming = [Show]()
    var moviesDataArrayTopRated = [Show]()
    var moviesDataArrayPopular = [Show]()
    
    // MARK: - Full Details Array
    
    var fullDetailsArray = [Show]()
    var reviewsDataArray = [Review]()
    var getDetailDataArray = [Show]()
    
    // MARK: - Search Array
    
    var filteredDataMovies = [Show]()
    var filteredDataTv = [Show]()
    var filteredDataTrending = [Show]()
    var filteredDataUpcoming = [Show]()
    var filteredDataTopRated = [Show]()
    var filteredDataPopular = [Show]()
    
    // MARK: - userDefaults Array
    
    var userDefaultsArrayMovie = [Int]()
    var userDefaultsArrayTv = [Int]()
    
    var arrayMovieUserDefaults = UserDefaults.standard.array(forKey: "watchListMovie")  as? [Int] ?? [Int]()
    var arrayTvUserDefaults = UserDefaults.standard.array(forKey: "watchListTv")  as? [Int] ?? [Int]()
    
    // MARK: - allDataArray
    
    var allDataArrayTv: [Show] {
        return tvDataArrayTrending + tvDataArrayPopular + tvDataArrayTopRated
    }
    
    var allDataArrayMovies: [Show] {
        return moviesDataArrayTrending + moviesDataArrayUpcoming + moviesDataArrayPopular + moviesDataArrayTopRated
    }
    
    var allDataArrayTrading: [Show] {
        return moviesDataArrayTrending + tvDataArrayTrending
    }
    
    var allDataArrayUpcoming: [Show] {
        return moviesDataArrayUpcoming 
    }
    
    var allDataArrayTopRated: [Show] {
        return moviesDataArrayTopRated + tvDataArrayTopRated
    }
    
    var allDataArrayPopular: [Show] {
        return moviesDataArrayPopular + tvDataArrayPopular
    }
    
    // MARK: - add To WatchList
    
    func addToWatchListMovies(id: Int) {
        let selectedId = (id)
        if arrayMovieUserDefaults.contains(selectedId) {
            arrayMovieUserDefaults.remove(at: arrayMovieUserDefaults.firstIndex(of: selectedId)!)
            UserDefaults.standard.set(arrayMovieUserDefaults, forKey: "watchListMovie")
        } else {
            arrayMovieUserDefaults.append(selectedId)
            UserDefaults.standard.set(arrayMovieUserDefaults, forKey: "watchListMovie")
        }
    }
    
    func addToWatchListTv(id: Int) {
        let selectedId = (id)
        if arrayTvUserDefaults.contains(selectedId) {
            arrayTvUserDefaults.remove(at: arrayTvUserDefaults.firstIndex(of: selectedId)!)
            UserDefaults.standard.set(arrayTvUserDefaults, forKey: "watchListTv")
        } else {
            arrayTvUserDefaults.append(selectedId)
            UserDefaults.standard.set(arrayTvUserDefaults, forKey: "watchListTv")
        }
    }
    
    // MARK: - alert
    
    func showAlert(vc : UIViewController, title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (alert) in
        }
        alertView.addAction(alertAction)
        vc.present(alertView, animated: true, completion: nil)
    }
    
    // MARK: - func check if id in watchList
    
    func checkIfInWatchList(id: Int){
        if arrayTvUserDefaults.contains(id) || arrayMovieUserDefaults.contains(id) {
            checkIfInWatchList = true
        }
    }
}
