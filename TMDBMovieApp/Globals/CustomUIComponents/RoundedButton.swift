//
//  RoundedButton.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 02/08/2024.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()

        let radius = min(bounds.width, bounds.height) / 2
        layer.cornerRadius = radius
    }

}

@IBDesignable
class RoundedImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()

        let radius = min(bounds.width, bounds.height) / 2
        layer.cornerRadius = radius
    }

}
