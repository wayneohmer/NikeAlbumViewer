//
//  NARSSManager,siwft
//  NikeAlbumViewer
//
//  Created by Wayne Ohmer on 7/28/18.
//  Copyright © 2018 Wayne Ohmer. All rights reserved.
//

import UIKit

class NARSSManager {
    
    // default to 25 results from US, all genres.
    static let feedUrl = URL(string:"https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/25/explicit.json")!
    
    class func fetchAlbumData(closure:@escaping (([NAAlbumModel]) -> Void)) {
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        //Error checking is minimal. We get an array or we don't. Master VC handles the error.
        //In a producion app I would check the error and the response status codes and least log them.
        //Better yet, resond to some situations, like http status 5xx by retring after a certain time period.
        //Really got time? Implement circuit breaker pattern and a fail closure that allows more intelligent user facing error messages.
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
        
        var returnArray = [NAAlbumModel]()
        
        do {
            let rss = try JSONDecoder().decode(NARSS.self, from: json)
            for result in rss.feed.results {
                returnArray.append(NAAlbumModel.init(result: result))
            }
        } catch {
            NSLog("Could not decode JSON - \(error.localizedDescription)")
        }
        return returnArray
    }

}
