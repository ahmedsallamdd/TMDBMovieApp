//
//  ViewModel.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 03/08/2024.
//

import Foundation

class ViewModel: NSObject {
    // checked by the view
    var onErrorFound: (String) -> Void = { _ in }
    var startLoading: () -> Void = {}
    var finishLoading: () -> Void = {}
    
    // assigned by the viewModel
    var errorMessage: String? {
        didSet {
            // envoke the message closure for the view to respond with whatever it wants (mostly show simple alert).
            self.onErrorFound(self.errorMessage ?? NetworkError.nonSpecificError.descriptionString)
        }
    }
}


