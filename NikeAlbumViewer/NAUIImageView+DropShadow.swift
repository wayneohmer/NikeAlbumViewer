//
//  NAUIImageView+DropShadow.swift
//  NikeAlbumViewer
//
//  Created by Wayne Ohmer on 7/28/18.
//  Copyright © 2018 Wayne Ohmer. All rights reserved.
//

import UIKit

extension UIImageView {
    
    //Make white artwork look much better.
    func addAlbumCoverDropShadow() {
        let shadowPath = UIBezierPath(rect: self.bounds)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowPath = shadowPath.cgPath
    }

}
