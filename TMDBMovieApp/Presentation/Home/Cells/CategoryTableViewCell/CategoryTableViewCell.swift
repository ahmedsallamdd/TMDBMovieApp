//
//  CategoryTableViewCell.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 02/08/2024.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let identifier = "CategoryTableViewCell"
    var didRequestNextPage = false
    
//    var media: [TMDBMedia] = []
//    var mediaType: MediaType = .movie
    
    var movies: [TMDBMedia]?
    var tvShows: [TMDBMedia]?
    
    var willNeedToLoadNextPage: ((MediaType) -> Void)? = { _ in }
    var didSelectItem: (TMDBMedia) -> Void = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCollectionView()
    }
    
    func configure(movies: [TMDBMedia]) {
        self.didRequestNextPage = false
        self.movies = movies
        self.tvShows = nil
        self.collectionView.reloadData()
    }
    
    func configure(tvShows: [TMDBMedia]) {
        self.didRequestNextPage = false
        self.tvShows = tvShows
        self.movies = nil
        self.collectionView.reloadData()
    }
    
//    func configure(with media: [TMDBMedia]) {
//        self.media = media
//        
//        if media.count == 0 {
//            collectionView.setEmptyMessage("No \(mediaType == .movie ? "movies" : "tv series") to show")
//        } else {
//            collectionView.restore()
//        }
//        
//        self.collectionView.reloadData()
//    }
    
    fileprivate func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: MovieCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.getItemSize()
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = true
    }
    
    fileprivate func getItemSize() -> CGSize {
        return CGSize(width: self.frame.width / 1.7, height: self.frame.height)
    }
    
}

extension CategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? tvShows?.count ?? 0//return self.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell {
            
            if let item = movies?[indexPath.row] {
                item.loadPosterImage(completion: { [weak cell] image in
                    cell?.moviePosterImageView.image = image ?? UIImage(systemName: "movieclapper")
                    cell?.moviePosterImageView.contentMode = .scaleToFill
                })
                cell.movieNameLabel.text = item.title
                cell.movieGenreLabel.text = item.genresAsString
                
            } else if let item = tvShows?[indexPath.row] {
                item.loadPosterImage(completion: { [weak cell] image in
                    cell?.moviePosterImageView.image = image ?? UIImage(systemName: "movieclapper")
                    cell?.moviePosterImageView.contentMode = .scaleToFill
                })
                cell.movieNameLabel.text = item.title
                cell.movieGenreLabel.text = item.genresAsString
            }
//            let media = media[indexPath.row]
//            
//            media.loadPosterImage(completion: { [weak cell] image in
//                cell?.moviePosterImageView.image = image ?? UIImage(systemName: "movieclapper")
//                cell?.moviePosterImageView.contentMode = .scaleToFill
//            })
//            
//            cell.movieNameLabel.text = media.title
//            cell.movieGenreLabel.text = media.genresAsString
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let movies {
            if indexPath.row == movies.count - 2 && didRequestNextPage == false {
                self.willNeedToLoadNextPage?(.movie)
                didRequestNextPage = true
            }
        } else if let tvShows {
            if indexPath.row == tvShows.count - 2 && didRequestNextPage == false {
                self.willNeedToLoadNextPage?(.tvShow)
                didRequestNextPage = true
            }
        }
        
//        switch mediaType {
//        case .movie:
//            let listCount = self.media.count
//            
//            if indexPath.row == listCount - 3 {
//                self.willNeedToLoadNextPage?(.movie)
//                print("Requesting next movie page")
//            }
//            
//        case .tvShow:
//            let listCount = self.media.count
//            
//            if indexPath.row == listCount - 3 {
//                self.willNeedToLoadNextPage?(.tvShow)
//                print("Requesting next tv show page")
//            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = movies?[indexPath.row] {
            self.didSelectItem(item)
        } else if let item = tvShows?[indexPath.row] {
            self.didSelectItem(item)
        }
    }
}

extension CategoryTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSize = getItemSize()
        return itemSize
        
    }
}
