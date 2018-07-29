//
//  NAAlbumModel.swift
//  NikeAlbumViewer
//
//  Created by Wayne Ohmer on 7/28/18.
//  Copyright © 2018 Wayne Ohmer. All rights reserved.
//

import UIKit

// Decodeable structs that support the album model. It's almost magic.

struct NARSS: Decodable {
    var feed: NARSSFeed
}

struct NARSSFeed: Decodable {
    var results: [NARSSResult]
}

struct NARSSResult: Decodable {
    var artistName = ""
    var releaseDate = ""
    var name = ""
    var copyright = ""
    var url = ""
    var artworkUrl100 = ""
    var genres: [NARSSGenre]
    //Just show the first genre in the array. It is the most specific.
    var genre:String {
        return genres.isEmpty ? "" : genres[0].name
    }
    var storeUrl:URL? {
        return URL(string: url)
    }
    var artworkUrl:URL? {
        return URL(string: artworkUrl100)
    }
}

struct NARSSGenre: Decodable {
    var name = ""
}

class NAAlbumModel {
    
    var artistName = ""
    var releaseDate = ""
    var name = ""
    var copyright = ""
    var storeUrl: URL?
    var artworkUrl: URL?
    var genre = ""
    var image: UIImage?
    //Don't save requests if fetch has failed.
    var fetchFailed = false
    
    //when a request comes in while the is being fetched, store them until the fetch is done.
    var requestImageClosures = [((UIImage, String) -> Void)]()
    
    //I could just store the result struct and return the attributes as computed properties. Choices... 
    convenience init(result: NARSSResult) {
        self.init()
        
        self.artistName = result.artistName
        self.releaseDate = result.releaseDate
        self.name = result.name
        self.copyright = result.copyright
        self.storeUrl = result.storeUrl
        self.artworkUrl = result.artworkUrl
        self.genre = result.genre

        self.fetchImage()
    }
    
    func requestImage(closure:@escaping (UIImage, String) -> Void) {
        if let image = self.image, let url = self.artworkUrl {
            closure(image, url.absoluteString)
        } else {
            //Don't save closure if fetch failed. There should never have more then 2 open requests.
            if !self.fetchFailed && self.requestImageClosures.count < 2 {
                self.requestImageClosures.append(closure)
            }
        }
    }
    
    //In a production app I would implement an image cache system that used the cachesDirectory on disk.
    //This saves RAM and lets the OS handle the purging duties. I have an example that I implemented at Spokin.
    //We have a fixed number of images so keeping them in memory is safe.
    func fetchImage(){
        guard let url = self.artworkUrl else {
            self.fetchFailed = true
            return
        }
        self.fetchFailed = false
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = defaultSession.dataTask(with: url) { data, response, error in
            //No error identification or retries.
            if let imageData = data, let image = UIImage(data: imageData) {
                self.image = image
                for closure in self.requestImageClosures {
                    closure(image, url.absoluteString)
                }
            } else {
                self.fetchFailed = true
                self.requestImageClosures.removeAll()
            }
        }
        dataTask.resume()
    }
    
}
