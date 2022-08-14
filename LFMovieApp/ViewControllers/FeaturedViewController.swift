//
//  FeaturedViewController.swift
//  LFMovieApp
//
//  Created by Oran 14/07/2022.
//

import UIKit

class FeaturedViewController: UIViewController {
    
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    
    var service = Service.shard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        featuredCollectionView.dataSource = self
        featuredCollectionView.delegate = self
        
        Task {
            async let dataMovies = await NetworkService().getFull(.movie)
            async let dataTv = await NetworkService().getFull(.tv)
            _ = await dataMovies + dataTv
            featuredCollectionView.reloadData()
        }
    }
    
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? ShowDetailsViewController else { return }

        if let indexPath = featuredCollectionView?.indexPathsForSelectedItems?.first {
            if indexPath.section == 0 {
                detailViewController.selectedShow = service.allDataArrayTrading[indexPath.row]
            } else if indexPath.section == 1 {
                detailViewController.selectedShow = service.allDataArrayUpcoming[indexPath.row]
            } else if indexPath.section == 2 {
                detailViewController.selectedShow = service.allDataArrayTopRated[indexPath.row]
            } else if indexPath.section == 3 {
                detailViewController.selectedShow = service.allDataArrayPopular[indexPath.row]
            }
        }
    }
    
    @objc func seeAllButton(_ button:UIButton){
        switch button.tag{
        case 0:
            service.indexSection = 0
        case 1:
            service.indexSection = 1
        case 2:
            service.indexSection = 2
        case 3:
            service.indexSection = 3
        default:
            break
        }
    }
}

    // MARK: - CollectionView DataSource

extension FeaturedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return service.allDataArrayTrading.prefix(4).count
        case 1:
            return service.allDataArrayUpcoming.prefix(4).count
        case 2:
            return service.allDataArrayTopRated.prefix(4).count
        case 3:
            return service.allDataArrayPopular.prefix(4).count
        default:
            break
        }
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredCell", for: indexPath) as! FeaturedCollectionViewCell
        
        switch (indexPath.section) {
        case 0:
            cell.setup(item: service.allDataArrayTrading[indexPath.row])
        case 1:
            cell.setup(item: service.allDataArrayUpcoming[indexPath.row])
        case 2:
            cell.setup(item: service.allDataArrayTopRated[indexPath.row])
        case 3:
            cell.setup(item: service.allDataArrayPopular[indexPath.row])
        default:
            break
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! FeatureCollectionReusableView
        
        header.seeAllButtonOutlet.tag = indexPath.section
        header.seeAllButtonOutlet.addTarget(self, action: #selector(seeAllButton), for: .touchUpInside)
        
        if indexPath == [0, 0] { header.featuredCategoryLabel.text = "Trending"}
        else if indexPath == [1, 0] { header.featuredCategoryLabel.text = "Upcoming"}
        else if indexPath == [2, 0] { header.featuredCategoryLabel.text = "Top Rated"}
        else if indexPath == [3, 0] { header.featuredCategoryLabel.text = "Popular"}
        return header
    }
}

// MARK: - CollectionView - Delegate

extension FeaturedViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 5
        return CGSize(width: width  , height: width )
    }
}
