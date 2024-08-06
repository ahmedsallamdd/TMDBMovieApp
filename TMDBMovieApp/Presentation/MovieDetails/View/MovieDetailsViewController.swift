//
//  MovieDetailsViewController.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 04/08/2024.
//

import UIKit

class MovieDetailsViewController: ViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
    @IBOutlet weak var addToFavouritesButton: UIButton!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var mediaCategoryLabel: UILabel!
    @IBOutlet weak var watchNowButton: RoundedButton!
    
    fileprivate let viewModel: MovieDetailsViewModel
    
    init(with viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindWithViewModel(self.viewModel)
        
        populateViewsWithModelData()
        
        updateAddToFavoritesButtonState()
    }
    
    fileprivate func populateViewsWithModelData() {
        self.posterImageView.image = self.viewModel.media.image
        self.mediaTypeLabel.text = self.viewModel.media.type == .movie ? "Movie" : "TV Series"
        self.titleLabel.text = self.viewModel.media.title
        self.genresLabel.text = self.viewModel.media.genresAsString
        self.overviewTextView.text = self.viewModel.media.overview
        self.releaseDateLabel.text = self.viewModel.media.releaseDate
        self.mediaCategoryLabel.text = self.viewModel.media.isAdult ? "Adult" : "Family"
    }
    
    func updateAddToFavoritesButtonState() {
        let imageName = viewModel.isAddedToFavorites ? "bookmark.fill" : "bookmark"
        addToFavouritesButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBAction func addToFavouritesButtonAction(_ sender: Any) {
        if viewModel.isAddedToFavorites {
            viewModel.deleteFromFavorites()
        } else {
            viewModel.addToFavorites()
        }
        
        updateAddToFavoritesButtonState()
    }
    
    @IBAction func watchNowButtonAction(_ sender: Any) {
        self.showErrorMessage(message: "This feature isn't ready yet!")
    }
}

enum MediaType: Int {
    case movie = 0
    case tvShow
}
