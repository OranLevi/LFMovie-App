//
//  ShowTableViewCell.swift
//  LFMovieApp
//
//  Created by Oran on 14/07/2022.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var showTagLineLabel: UILabel!
    @IBOutlet weak var showRatingLabel: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(item: Show) {
        
        Task{
            await showImageView?.getImage(path:item.poster)
        }
        showTitleLabel.text = item.name
        showTagLineLabel.text = item.overview
        showRatingLabel.text = "Rating: \(item.voteAverage ?? 0)"
    }
}
