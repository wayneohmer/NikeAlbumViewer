//
//  NikeAlbumViewerTests.swift
//  NikeAlbumViewerTests
//
//  Created by Wayne Ohmer on 7/28/18.
//  Copyright © 2018 Wayne Ohmer. All rights reserved.
//

import XCTest
@testable import NikeAlbumViewer

class NikeAlbumViewerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONParsing() {
        
        guard let filepath:String = Bundle.main.path(forResource: "testData", ofType: "json") else {
            XCTFail("could not find JSON text file")
            return
        }
        do {
            let json = try String(contentsOfFile: filepath)
            let albums = NAFeedDecoder.getAlbumsFrom(json: json.data(using: .utf8)!)
            XCTAssert(albums[0].artistName == "G Herbo & Southside")
            XCTAssert(albums[0].releaseDate == "2018-07-27")
            XCTAssert(albums[0].name == "Swervo")
            XCTAssert(albums[0].copyright == "℗ 2018 Machine Entertainment Group")
            XCTAssert(albums[0].url == URL(string: "https://itunes.apple.com/us/album/swervo/1413595651?app=music"))
            XCTAssert(albums[0].artworkUrl100 == URL(string: "https://is2-ssl.mzstatic.com/image/thumb/Music118/v4/0a/06/a2/0a06a23f-468d-78a8-ee3e-ef16e420f1f3/contsched.twcnaiog.jpg/200x200bb.png"))
            XCTAssert(albums[0].genre == "Hip-Hop")

            XCTAssert(albums[1].artistName == "Queen Naija")
            XCTAssert(albums[1].releaseDate == "2018-07-27")
            XCTAssert(albums[1].name == "Queen Naija - EP")
            XCTAssert(albums[1].copyright == "Capitol Records; ℗ 2018 Queen Naija, under exclusive license to UMG Recordings, Inc.")
            XCTAssert(albums[1].url == URL(string: "https://itunes.apple.com/us/album/queen-naija-ep/1413905925?app=music"))
            XCTAssert(albums[1].artworkUrl100 == URL(string: "https://is2-ssl.mzstatic.com/image/thumb/Music118/v4/95/c0/65/95c06543-1926-1086-f213-7863d4f5bc10/00602567799870.rgb.jpg/200x200bb.png"))
            XCTAssert(albums[1].genre == "R&B/Soul")


            XCTAssert(albums[2].artistName == "Future")
            XCTAssert(albums[2].releaseDate == "2018-07-06")
            XCTAssert(albums[2].name == "BEASTMODE 2")
            XCTAssert(albums[2].copyright == "℗ 2018 Epic Records, a division of Sony Music Entertainment with Freebandz")
            XCTAssert(albums[2].url == URL(string: "https://itunes.apple.com/us/album/beastmode-2/1407068657?app=music"))
            XCTAssert(albums[2].artworkUrl100 == URL(string: "https://is2-ssl.mzstatic.com/image/thumb/Music115/v4/0f/41/7b/0f417b33-e253-d088-aa1a-1e441a3bea0f/886447204764.jpg/200x200bb.png"))
            XCTAssert(albums[2].genre == "Hip-Hop/Rap")


        } catch {
            XCTFail("could not read JSON text file")
        }
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
