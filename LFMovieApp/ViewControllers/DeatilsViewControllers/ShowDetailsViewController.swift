//
//  ShowDetailsViewController.swift
//  LFMovieApp
//
//  Created by Oran on 14/07/2022.
//

import UIKit

class ShowDetailsViewController: UIViewController {
    
    @IBOutlet weak var showDetailsTableView: UITableView!
    @IBOutlet weak var buttonWatchList: UIBarButtonItem!
    
    var selectedShow: Show?
    var service = Service.shard
    var doubleTap : Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetailsTableView.dataSource = self
        showDetailsTableView.delegate = self
        load()
        hideButton()
        service.checkIfInWatchList(id: selectedShow!.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if service.checkIfInWatchList == true {
            buttonWatchList.image = UIImage(systemName: "suit.heart.fill")
            service.checkIfInWatchList.toggle()
            doubleTap = true
        }
    }
    
    func loadItem(_ mediaType: NetworkService.MediaType) {
        Task{
            let selectedId = selectedShow?.id
            async let getFullDetail = NetworkService().getFullDetail(mediaType, id: selectedId!)
            selectedShow?.reviews = await getFullDetail?.reviews
            selectedShow?.genres = await getFullDetail?.genres
            showDetailsTableView.reloadData()
        }
    }
    
    func load() {
        if tabBarController?.selectedIndex == Service.tabBarNumber.featured.rawValue || tabBarController?.selectedIndex == Service.tabBarNumber.movies.rawValue ||
            tabBarController?.selectedIndex == Service.tabBarNumber.watchList.rawValue{
            loadItem(.movie)
        } else  if tabBarController?.selectedIndex == Service.tabBarNumber.tv.rawValue {
            loadItem(.tv)
        }
    }
    
    func hideButton(){
        if tabBarController?.selectedIndex == Service.tabBarNumber.watchList.rawValue {
            buttonWatchList?.isEnabled = false
            buttonWatchList?.tintColor = UIColor.clear
        }
    }
    
    @IBAction func watchListButton(_ sender: Any) {
        if (doubleTap) {
            buttonWatchList.image = UIImage(systemName: "suit.heart")
            doubleTap = false
        } else {
            buttonWatchList.image = UIImage(systemName: "suit.heart.fill")
            doubleTap = true
        }
        let id = (selectedShow?.id)!
        if service.allDataArrayMovies.contains(where: { $0.id  == id }) {
            service.addToWatchListMovies(id: id)
        } else {
            service.addToWatchListTv(id: id)
        }
    }
}

// MARK: - TableView - DataSource

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if service.reviewsDataArray.isEmpty{
            return 2
        }
        
        if tabBarController?.selectedIndex == Service.tabBarNumber.featured.rawValue {
            return service.reviewsDataArray.count
        }
        else if tabBarController?.selectedIndex == Service.tabBarNumber.movies.rawValue {
            return service.reviewsDataArray.count
        } else  if tabBarController?.selectedIndex == Service.tabBarNumber.tv.rawValue {
            return service.reviewsDataArray.count
        }
        else if tabBarController?.selectedIndex == Service.tabBarNumber.watchList.rawValue {
            return service.reviewsDataArray.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell =  showDetailsTableView.dequeueReusableCell(withIdentifier: "showDetailsCell", for: indexPath) as! ShowDetailsTableViewCell
            
            Task{
                await cell.showDetailsImageView.getImage(path:selectedShow!.poster)
            }
            cell.showDetailsCategoryLabel.text = selectedShow?.genres?.first?.name
            cell.showDetailsRatingLabel.text = "Rating: \(selectedShow?.voteAverage ?? 0 )"
            cell.showDetailsTitleLineLabel.text = selectedShow?.name
            cell.showDetailsOverviewLabel.text = selectedShow?.overview
            cell.showDetailsDescriptionLabel.text = selectedShow?.reviews?.first?.content ?? "Not Available Description\n\n"
            
            return cell
            
        } else {
            let cellReviews =  showDetailsTableView.dequeueReusableCell(withIdentifier: "showDetailsReviewsCell", for: indexPath) as! ShowDetailsReviewTableViewCell
            
            if service.reviewsDataArray.isEmpty{
                cellReviews.showDetailsAuthorReviewsLabel.text = "Not Available"
                cellReviews.showDetailsContentReviewsLabel.text = "Not Available"
                return cellReviews
            }
            let item = service.reviewsDataArray[indexPath.row]
            cellReviews.showDetailsAuthorReviewsLabel.text = item.author
            cellReviews.showDetailsContentReviewsLabel.text = item.content
            
            return cellReviews
        }
    }
}

// MARK: - TableView - Delegate

extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetailsTableView.deselectRow(at: indexPath, animated: true)
    }
}
