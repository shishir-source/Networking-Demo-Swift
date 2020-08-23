//
//  MovieCell.swift
//  tmogaming
//
//  Created by Shishir Ahmed on 2/7/20.
//  Copyright © 2020 Shishir Ahmed. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: CustomImageView!
    @IBOutlet weak var movieTitle: UILabel!
        
    static let identfier = "MovieCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(movie: D) {
        
        if let title = movie.l{
            movieTitle.text = title
        }
        
        if let posterPath = movie.i?.imageURL {
            movieImage.loadImage(with: posterPath)
        }
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieCell", bundle: nil)
    }

}
