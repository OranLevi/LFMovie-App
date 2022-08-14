//
//  ShowDetailsTableViewCell.swift
//  LFMovieApp
//
//  Created by Oran on 14/07/2022.
//

import UIKit

class ShowDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var showDetailsImageView: UIImageView!
    @IBOutlet weak var showDetailsCategoryLabel: UILabel!
    @IBOutlet weak var showDetailsTitleLineLabel: UILabel!
    @IBOutlet weak var showDetailsRatingLabel: UILabel!
    @IBOutlet weak var showDetailsDescriptionLabel: UILabel!
    @IBOutlet weak var showDetailsOverviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
