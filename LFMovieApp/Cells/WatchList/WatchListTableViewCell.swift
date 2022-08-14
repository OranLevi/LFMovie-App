//
//  WatchListTableViewCell.swift
//  LFMovieApp
//
//  Created by Oran on 15/07/2022.
//

import UIKit

class WatchListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var watchListImageView: UIImageView!
    @IBOutlet weak var watchListTitleLabel: UILabel!
    @IBOutlet weak var watchListCategoryLabel: UILabel!
    @IBOutlet weak var watchListRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(item: Show) {
        Task{
            await watchListImageView.getImage(path:item.poster)
        }
        watchListTitleLabel.text = item.name
        watchListRatingLabel.text = "Rating: \(item.voteAverage ?? 0)"
        watchListCategoryLabel.text = item.genres?.first?.name
    }
}
