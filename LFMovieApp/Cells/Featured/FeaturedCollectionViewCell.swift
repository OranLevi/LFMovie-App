//
//  FeaturedCollectionViewCell.swift
//  LFMovieApp
//
//  Created by Oran on 15/07/2022.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var featuredTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(item: Show){
        Task {
            await featuredImageView.getImage(path: item.poster)
        }
        featuredTitleLabel.text = item.name
    }
}
