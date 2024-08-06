//
//  LoginViewController.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 02/08/2024.
//

import UIKit

class LoginViewController: ViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var shouldSignInAutomatically = false
        
        if let _ = LocalStorageHelper.shared.get(for: .accessToken) as? String,
           let accessTokenExpirationDate = LocalStorageHelper.shared.get(for: .accessTokenExpirationDate) as? Date,
        accessTokenExpirationDate > Date() {
            shouldSignInAutomatically = true
        }
        
        if shouldSignInAutomatically == true {
            BiometricsAuthenticator.authenticate(completion: { [weak self] result in
                switch result {
                case .success:
                    self?.goToHomeScreen()
                case .failure(let error):
                    self?.showErrorMessage(message: error.descriptionString)
                }
            })
        }
    }
    
    fileprivate func goToHomeScreen() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let homeVM = HomeViewModel(moviesRepository: MoviesRepository(),
                                           tvShowsRepository: TvShowsRepository(),
                                           userRepository: GoogleUserRepository())
                
                let homeVC = HomeViewController(with: homeVM)
                
                let appNavController = AppNavigationController(rootViewController: homeVC)
                window.rootViewController = appNavController
            }
        }
    }
    
    @IBAction func signInWithGoogleButtonAction(_ sender: Any) {
        AppAuthHelper.shared.createAuthFlow(presentingVC: self) { [weak self] authState, errorMessage in
            if let errorMessage {
                self?.showErrorMessage(message: errorMessage)
                
            } else if let authState {
                LocalStorageHelper.shared.save(for: .accessToken,
                                               value: authState.lastTokenResponse?.accessToken ?? "")
                
                LocalStorageHelper.shared.save(for: .accessTokenExpirationDate,
                                               value: authState.lastTokenResponse?.accessTokenExpirationDate ?? Date())
                
                self?.goToHomeScreen()
            }
        }
    }
    
}
