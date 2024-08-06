//
//  AppNavigationController.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 06/08/2024.
//

import UIKit

class AppNavigationController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        makeNavigationBarTranslucent()
        setupTitleAppearence()
    }
    
    func setupTitleAppearence() {
        let titleFontSize: CGFloat = 22
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.appMain,
                                          .font: UIFont.systemFont(ofSize: titleFontSize, weight: .bold)]
        appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func makeNavigationBarTranslucent() {
        // Create a new instance of UIBarAppearance
        let appearance = UINavigationBarAppearance()
        
        // Make the background transparent
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear
        
        // Remove the shadow image for a seamless transition
        self.navigationBar.shadowImage = UIImage()
        
        // Apply the appearance to the navigation bar
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        
        // Make the navigation bar translucent
        self.navigationBar.isTranslucent = true
    }
}
