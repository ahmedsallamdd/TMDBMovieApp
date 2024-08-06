//
//  UIColorExtensions.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 06/08/2024.
//

import UIKit

extension UIColor {
    @nonobjc class var appMainColor: UIColor {
        return UIColor(named: "app_main_color") ?? .clear
    }
    
    @nonobjc class var appDarkColor: UIColor {
        return UIColor(named: "app_dark_color") ?? .clear
    }
    
    @nonobjc class var appGrayColor: UIColor {
        return UIColor(named: "app_second_label_color") ?? .clear
    }
}
