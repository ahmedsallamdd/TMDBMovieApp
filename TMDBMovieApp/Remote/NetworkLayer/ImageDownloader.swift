//
//  ImageDownloader.swift
//  TMDBMovieApp
//
//  Created by Ahmed Sallam on 03/08/2024.
//

import UIKit

class ImageDownloader {
    static let shared = ImageDownloader()
    
    private init() {}
    
    func download(links: [String], completion: @escaping ([String: UIImage?]) -> Void) {
        var downloadedImages: [String: UIImage?] = [:] //Stores downloaded images identified by their links
        for link in links {
            self.download(link: link, completion: { image in
                downloadedImages[link] = image
                
                if downloadedImages.count == links.count {
                    DispatchQueue.main.async {
                        completion(downloadedImages)
                    }
                }
            })
        }
    }
    
    func download(link: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
//        print("====Started downloading image with url: \(url.absoluteString)")
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
//                print("====Finished downloading image with url: \(url.absoluteString)")
                completion(image)
            }
        }.resume()
    }
}
