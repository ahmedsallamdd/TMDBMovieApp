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
    
    var media: [TMDBMedia] = []
    var mediaType: MediaType = .movie
    
    var willNeedToLoadNextPage: ((MediaType) -> Void)? = { _ in }
    var didSelectItem: (TMDBMedia) -> Void = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCollectionView()
    }
    
    func configure(with media: [TMDBMedia]) {
        self.media = media
        
        if media.count == 0 {
            collectionView.setEmptyMessage("No \(mediaType == .movie ? "movies" : "tv series") to show")
        } else {
            collectionView.restore()
        }
        
        self.collectionView.reloadData()
    }
    
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
        return self.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell {
            
            let media = media[indexPath.row]
            
            media.loadPosterImage(completion: { [weak cell] image in
                cell?.moviePosterImageView.image = image ?? UIImage(systemName: "movieclapper")
                cell?.moviePosterImageView.contentMode = .scaleAspectFit
            })
            
            cell.movieNameLabel.text = media.title
            cell.movieGenreLabel.text = media.genresAsString
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItem(media[indexPath.row])
    }
}

extension CategoryTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSize = getItemSize()
        return itemSize
        
    }
}
