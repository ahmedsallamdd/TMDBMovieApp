//
//  ViewController.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 03/08/2024.
//

import UIKit

class ViewController: UIViewController {
    var isLoading: Bool = false
    var loadingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.handleNavigationBarItemsAndTitle()
    }
    
    func bindWithViewModel(_ viewModel: ViewModel) {
        viewModel.onErrorFound = { [weak self] msg in
            DispatchQueue.main.async {
                self?.showErrorMessage(message: msg)
            }
        }
        
        viewModel.startLoading = {[weak self] in
            DispatchQueue.main.async {
                self?.isLoading = true
                self?.startLoadingAnimation()
            }
        }
        
        viewModel.finishLoading = {[weak self] in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.stopLoadingAnimation()
            }
        }
    }
    
    func handleNavigationBarItemsAndTitle() {
        
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            if let backImage = UIImage(named: "back")?.withTintColor(.white, renderingMode: .alwaysTemplate) {
                let buttonItem = UIBarButtonItem(image: backImage,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(toggleLeft))
                buttonItem.width = 20
                buttonItem.tintColor = .white
                self.navigationItem.leftBarButtonItem = buttonItem
            }
        }
    }
    
    @objc func toggleLeft() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // In both of these methods, every child can define their loading animation or use the default
    func startLoadingAnimation() {
        if let loadingView {
            
        } else {
            loadingView = UIView(frame: self.view.bounds)
            loadingView?.backgroundColor = .black.withAlphaComponent(0.3)
            
            view.addSubview(loadingView!)
            
            loadingView?.translatesAutoresizingMaskIntoConstraints = false
            loadingView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            loadingView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            loadingView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            loadingView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
    }
    
    func stopLoadingAnimation() {
        loadingView?.removeFromSuperview()
    }
    
    func showErrorMessage(title: String? = nil, message: String, actionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: {
            _ in actionHandler?()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
