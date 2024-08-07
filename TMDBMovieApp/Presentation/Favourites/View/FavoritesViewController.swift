//
//  FavoritesViewController.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 06/08/2024.
//

import UIKit

class FavoritesViewController: ViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = FavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        
        setupTableView()
        
        bindWithViewModel(self.viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchData() //So that we get refreshed list every time this screen appears
        tableView.reloadData()
    }

    fileprivate func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: CategoryTableViewCell.identifier,
                                                bundle: nil),
                                          forCellReuseIdentifier: CategoryTableViewCell.identifier)
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Favorite Movies"
        case 1: return "Favorite TV Series"
        default: return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell {
            
            let type: MediaType = indexPath.section == 0 ? .movie : .tvShow
            let tmdbMedia = self.viewModel.favorites.filter({ $0.type == type })
            
            cell.mediaType = type
            cell.configure(with: Array(tmdbMedia))
            
            cell.didSelectItem = {[weak self] media in
                self?.show(MovieDetailsViewController(with: MovieDetailsViewModel(media: media)), sender: nil)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.favorites.count > 0 ? 400 : 20
    }
}
