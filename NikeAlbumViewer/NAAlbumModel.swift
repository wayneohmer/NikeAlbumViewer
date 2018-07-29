//
//  NAAlbumModel.swift
//  NikeAlbumViewer
//
//  Created by Wayne Ohmer on 7/28/18.
//  Copyright © 2018 Wayne Ohmer. All rights reserved.
//

import UIKit

class NAAlbumModel {
    
    var artistName = ""
    var releaseDate = ""
    var name = ""
    var copyright = ""
    var url:URL?
    var artworkUrl100:URL?
    var genre = ""
    var image:UIImage?
    
    convenience init(dict:[String:Any]) {
        self.init()
        self.artistName = dict["artistName"] as? String ?? ""
        self.releaseDate = dict["releaseDate"] as? String ?? ""
        self.copyright = dict["copyright"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        if let genres = dict["genres"] as? [[String:Any]] {
            if !genres.isEmpty {
                self.genre = genres[0]["name"] as? String ?? ""
            }
        }
        self.url = URL(string: dict["url"] as? String ?? "")
        self.artworkUrl100 = URL(string: dict["artworkUrl100"] as? String ?? "")
        self.fetchImage(closure:{(image) in })
//        do {
//            let imageData = try Data(contentsOf: self.artworkUrl100!)
//            self.image = UIImage(data:imageData)
//        } catch {
//            self.image = nil
//        }
        //self.genre = dict["genre"] as? String ?? ""
    }
    
    func fetchImage(closure:@escaping (UIImage) -> Void){
        guard let url = self.artworkUrl100 else {
            return
        }
        if let image = self.image {
            closure(image)
        } else {
            let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
            let dataTask = defaultSession.dataTask(with: url) { data, response, error in
                if let imageData = data, let image = UIImage(data: imageData) {
                    self.image = image
                    closure(image)
                    return
                }
            }
            dataTask.resume()
        }
        
    }
    
}
