//
//  RoundedView.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 02/08/2024.
//

import UIKit

@IBDesignable
class RoundedView: UIView {

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
