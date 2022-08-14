//
//  ShowViewController.swift
//  LFMovieApp
//
//  Created by Oran on 14/07/2022.
//

import UIKit

class ShowViewController: UIViewController {
    
    @IBOutlet weak var showTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var service = Service.shard
    
    var isSearchingMovies = false
    var isSearchingTv = false
    var isSearchingSeeAll = false
    var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTableView.dataSource = self
        showTableView.delegate = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    var realArrayMovies: [Show] {
        if isSearchingMovies {
            return service.filteredDataMovies
        } else {
            return service.allDataArrayMovies
        }
    }
    
    var realArrayTv: [Show] {
        if isSearchingTv {
            return service.filteredDataTv
        } else {
            return service.allDataArrayTv
        }
    }
    
    var realArrayTrending: [Show] {
        if isSearchingSeeAll {
            return service.filteredDataTrending
        } else {
            return service.allDataArrayTrading
        }
    }
    var realArrayUpcoming: [Show] {
        if isSearchingSeeAll {
            return service.filteredDataUpcoming
        } else {
            return service.allDataArrayUpcoming
        }
    }
    var realArrayTopRated: [Show] {
        if isSearchingSeeAll {
            return service.filteredDataTopRated
        } else {
            return service.allDataArrayTopRated
        }
    }
    var realArrayPopular: [Show] {
        if isSearchingSeeAll {
            return service.filteredDataPopular
        } else {
            return service.allDataArrayPopular
        }
    }
    
    // MARK: - Prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? ShowDetailsViewController,
              let index = showTableView.indexPathForSelectedRow?.row
        else {
            return
        }
        
        if tabBarController?.selectedIndex == Service.tabBarNumber.featured.rawValue {
            switch (service.indexSection) {
            case 0 :
                if (isSearchingSeeAll){
                    detailViewController.selectedShow = realArrayTrending[index]
                } else {
                    detailViewController.selectedShow = service.allDataArrayTrading[index]
                }
            case 1:
                if (isSearchingSeeAll){
                    detailViewController.selectedShow = realArrayUpcoming[index]
                } else {
                    detailViewController.selectedShow = service.allDataArrayUpcoming[index]
                }
            case 2:
                if (isSearchingSeeAll){
                    detailViewController.selectedShow = realArrayTopRated[index]
                } else {
                    detailViewController.selectedShow = service.allDataArrayTopRated[index]
                }
            case 3:
                if (isSearchingSeeAll){
                    detailViewController.selectedShow = realArrayPopular[index]
                } else {
                    detailViewController.selectedShow = service.allDataArrayPopular[index]
                }
            default: break
            }
            
        } else if tabBarController?.selectedIndex == Service.tabBarNumber.movies.rawValue {
            detailViewController.selectedShow = realArrayMovies[index]
        } else if tabBarController?.selectedIndex == Service.tabBarNumber.tv.rawValue {
            detailViewController.selectedShow = realArrayTv[index]
        }
    }
}

    // MARK: - TableView - DataSource

extension ShowViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tabBarController?.selectedIndex == Service.tabBarNumber.featured.rawValue {
            switch (service.indexSection) {
            case 0:
                return realArrayTrending.count
            case 1:
                return realArrayUpcoming.count
            case 2:
                return realArrayTopRated.count
            case 3:
                return realArrayPopular.count
            default:
                break
            }
        } else if tabBarController?.selectedIndex == Service.tabBarNumber.movies.rawValue {
            return realArrayMovies.count
        } else if tabBarController?.selectedIndex == Service.tabBarNumber.tv.rawValue {
            return realArrayTv.count
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = showTableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath) as! ShowTableViewCell
        
        if tabBarController?.selectedIndex == Service.tabBarNumber.featured.rawValue{
            switch (service.indexSection) {
            case 0:
                cell.setup(item: realArrayTrending[indexPath.row])
            case 1:
                cell.setup(item: realArrayUpcoming[indexPath.row])
            case 2:
                cell.setup(item: realArrayTopRated[indexPath.row])
            case 3:
                cell.setup(item: realArrayPopular[indexPath.row])
            default: break
            }
        }
        
        else if tabBarController?.selectedIndex == Service.tabBarNumber.movies.rawValue {
            cell.setup(item: realArrayMovies[indexPath.row])
        } else if tabBarController?.selectedIndex == Service.tabBarNumber.tv.rawValue {
            cell.setup(item: realArrayTv[indexPath.row])
        }
        
        return cell
    }
}

    // MARK: - TableView - Delegate

extension ShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTableView.deselectRow(at: indexPath, animated: true)
    }
}

    // MARK: - UISearch - Delegate

extension ShowViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if tabBarController?.selectedIndex == Service.tabBarNumber.featured.rawValue {
            if searchBar.text == "" {
                isSearchingSeeAll = false
                showTableView.reloadData()
            } else {
                isSearchingSeeAll = true
                switch (service.indexSection) {
                case 0:
                    service.filteredDataTrending = service.allDataArrayTrading.filter({$0.name.lowercased().contains(searchText.lowercased()) })
                case 1:
                    service.filteredDataUpcoming = service.allDataArrayUpcoming.filter({$0.name.lowercased().contains(searchText.lowercased()) })
                case 2:
                    service.filteredDataTopRated = service.allDataArrayTopRated.filter({$0.name.lowercased().contains(searchText.lowercased()) })
                case 3:
                    service.filteredDataPopular = service.allDataArrayPopular.filter({$0.name.lowercased().contains(searchText.lowercased()) })
                default: break
                    
                }
                showTableView.reloadData()
            }
        }
        else if tabBarController?.selectedIndex == Service.tabBarNumber.tv.rawValue {
            isSearchingTv = true
            self.searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                Task {
                    async let searchDataTv = NetworkService().getSearchResults(searchText: searchText, mediaType: .tv)
                    await print(searchDataTv)
                    self.service.filteredDataTv = self.service.allDataArrayTv.filter({$0.name.lowercased().contains(searchText.lowercased()) })
                    self.showTableView.reloadData()
                }
            }
        } else if tabBarController?.selectedIndex == Service.tabBarNumber.movies.rawValue {
            isSearchingMovies = true
            self.searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                Task {
                    async let searchDataMovies = NetworkService().getSearchResults(searchText: searchText, mediaType: .movie)
                    await print(searchDataMovies)
                    self.service.filteredDataMovies = self.service.allDataArrayMovies.filter({$0.name.lowercased().contains(searchText.lowercased()) })
                    self.showTableView.reloadData()
                }
            }
        }
    }
}
