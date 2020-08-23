//
//  MovieDetailsVC.swift
//  tmogaming
//
//  Created by Shishir Ahmed on 2/7/20.
//  Copyright © 2020 Shishir Ahmed. All rights reserved.
//

import UIKit

class MovieDetailsVC: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieId: UILabel!
    @IBOutlet weak var movieImage: CustomImageView!
    
    
    var movie = D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        
        guard let title = movie.l else{return}
        guard let id = movie.id else{return}
        
        self.movieTitle.text = title
        self.movieId.text = id
        
        self.title = title
        
        if let posterPath = movie.i?.imageURL {
            movieImage.loadImage(with: posterPath)
        }
        
    }
    

}
