//
//  HomeViewController.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 02/08/2024.
//

import UIKit

class HomeViewController: ViewController {
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
        
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var tvShowsCollectionView: UICollectionView!
    
    fileprivate let viewModel: HomeViewModel<MoviesRepository, TvShowsRepository, GoogleUserRepository>
    
    init(with viewModel: HomeViewModel<MoviesRepository, TvShowsRepository, GoogleUserRepository>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = HomeViewModel(moviesRepository: MoviesRepository(),
                                       tvShowsRepository: TvShowsRepository(),
                                       userRepository: GoogleUserRepository())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMoviesCollectionView()
        setupTvShowsCollectionView()
        
        bindWithViewModel(self.viewModel)
        viewModel.fetchData()
    }
    
    override func bindWithViewModel(_ viewModel: ViewModel) {
        super.bindWithViewModel(viewModel)
        
        self.viewModel.didLoadMoreMovies = { [weak self] in
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
            }
        }
        
        self.viewModel.didLoadMoreTvShows = { [weak self] in
            DispatchQueue.main.async {
                self?.tvShowsCollectionView.reloadData()
            }
        }
        
        self.viewModel.didLoadUserProfileInfo = { [weak self] in
            DispatchQueue.main.async {
                self?.setUserInfo()
            }
        }
    }
    
    fileprivate func setupMoviesCollectionView() {
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.register(UINib(nibName: MovieCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.getItemSize(for: moviesCollectionView)
        layout.scrollDirection = .horizontal
        
        moviesCollectionView.collectionViewLayout = layout
        moviesCollectionView.isScrollEnabled = true
    }
    
    fileprivate func setupTvShowsCollectionView() {
        tvShowsCollectionView.dataSource = self
        tvShowsCollectionView.delegate = self
        tvShowsCollectionView.register(UINib(nibName: MovieCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.getItemSize(for: tvShowsCollectionView)
        layout.scrollDirection = .horizontal
        
        tvShowsCollectionView.collectionViewLayout = layout
        tvShowsCollectionView.isScrollEnabled = true
    }
    
    fileprivate func getItemSize(for collectionView: UICollectionView) -> CGSize {
        return CGSize(width: collectionView.frame.width / 1.7, height: collectionView.frame.height)
    }
    
    fileprivate func setUserInfo() {
        if let userProfileInfo = AppAuthHelper.shared.userInfo {
            ImageDownloader.shared.download(link: userProfileInfo.picture,
                                            completion: { [weak self] downloadedImage in
                self?.userPhotoImageView.image = downloadedImage
            })
            
            usernameLabel.text = "Hello \(userProfileInfo.givenName)"
        }
        
    }
    
    @IBAction func favouritesButtonAction(_ sender: Any) {
        self.show(FavoritesViewController(), sender: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == moviesCollectionView ? self.viewModel.movies.count : self.viewModel.tvShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == moviesCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell {
                
                let item = self.viewModel.movies[indexPath.row]
                cell.moviePosterImageView.image = item.image
                cell.movieNameLabel.text = item.title
                cell.movieGenreLabel.text = item.genresAsString
                
                return cell
            }
        } else if collectionView == tvShowsCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell {
                
                let item = self.viewModel.tvShows[indexPath.row]
                cell.moviePosterImageView.image = item.image
                cell.movieNameLabel.text = item.title
                cell.movieGenreLabel.text = item.genresAsString
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == moviesCollectionView {
            if indexPath.row == viewModel.movies.count - 3 {
                self.viewModel.fetchNextPage(.movie, completion: { [weak self] in
                    self?.moviesCollectionView.reloadData()
                })
            }
            
        } else if collectionView == tvShowsCollectionView {
            if indexPath.row == viewModel.tvShows.count - 3 {
                self.viewModel.fetchNextPage(.tvShow, completion: { [weak self] in
                    self?.tvShowsCollectionView.reloadData()
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let media = collectionView == moviesCollectionView ? viewModel.movies[indexPath.row] : viewModel.tvShows[indexPath.row]
        self.show(MovieDetailsViewController(with: MovieDetailsViewModel(media: media)), sender: nil)
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSize = getItemSize(for: collectionView)
        return itemSize
        
    }
}
