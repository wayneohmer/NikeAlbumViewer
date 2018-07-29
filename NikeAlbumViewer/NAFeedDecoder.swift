//
//  NAFeedDecoder.swift
//  NikeAlbumViewer
//
//  Created by Wayne Ohmer on 7/28/18.
//  Copyright © 2018 Wayne Ohmer. All rights reserved.
//

import UIKit

class NAFeedDecoder {
    
    static let feedUrl = URL(string:"https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/30/explicit.json")!
    
    class func getAlbumData(closure:@escaping (([NAAlbumModel]) -> Void)) {
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = defaultSession.dataTask(with: feedUrl) { data, response, error in
            guard let jsonData = data else {
                closure([NAAlbumModel]())
                return
            }
            closure(getAlbumsFrom(json: jsonData))
        }
        dataTask.resume()
    }
    
    class func getAlbumsFrom(json:Data) -> [NAAlbumModel] {
        
        var retunArray = [NAAlbumModel]()

        do {
            let feedDict = try JSONSerialization.jsonObject(with:json) as? [String:Any]
            if let feed = feedDict!["feed"] as? [String:Any] {
                if let results  = feed["results"] as? [[String:Any]] {
                    for result in results {
                        retunArray.append(NAAlbumModel.init(dict: result))
                    }
                }
            }
        } catch {
            
        }
        return retunArray

    }

}
