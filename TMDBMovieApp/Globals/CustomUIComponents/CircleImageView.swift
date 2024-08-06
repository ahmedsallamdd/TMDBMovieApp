//
//  CircleImageView.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 02/08/2024.
//

import UIKit

@IBDesignable
class CircleImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2.0
    }

}
