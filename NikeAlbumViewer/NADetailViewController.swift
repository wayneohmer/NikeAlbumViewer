//
//  DetailViewController.swift
//  NikeAlbumViewer
//
//  Created by Wayne Ohmer on 7/28/18.
//  Copyright © 2018 Wayne Ohmer. All rights reserved.
//

import UIKit

class NADetailViewController: UIViewController {

    var album:NAAlbumModel?

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var storeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide everything if there is no album selected.  
        if self.album == nil {
            self.imageView.isHidden = true
            self.textView.isHidden = true
            self.storeButton.isHidden = true
        }
        
        //Emulate the store button look. This constant could be stored elsewhere.
        self.storeButton.layer.cornerRadius = 5
        
        //Ask for the image. If its still fetching, show it when it is finished.
        self.album?.requestImage() { [weak self] (image, _) in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
        //This is redundant. A blank title just looked wrong.
        self.navigationItem.title = self.album?.name ?? ""
        
        let attributedText = NSMutableAttributedString(string: "")
        
        //Yikes! Static user facing strings that are not localized!
        //There would be a better place to put these in a production app.
        attributedText.append(self.buildTextViewElement(heading: "\(album?.name ?? "")\n", detail:""))
        attributedText.append(self.buildTextViewElement(heading: "Artist", detail: album?.artistName ?? ""))
        attributedText.append(self.buildTextViewElement(heading: "Genre", detail: album?.genre ?? ""))
        attributedText.append(self.buildTextViewElement(heading: "Release Date", detail: album?.releaseDate ?? ""))
        attributedText.append(self.buildTextViewElement(heading: "Copyright", detail: album?.copyright ?? ""))

        self.textView.attributedText = attributedText
        self.textView.textAlignment = .center
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //This is here becaue bounds needs to be set before the shadow can be added.
        self.imageView.addAlbumCoverDropShadow()
        
        // fixes the annoying scroll issue where the textView is not rendered scrolled to the top
        // https://stackoverflow.com/a/34248700
        self.textView.setContentOffset(.zero, animated: false)
    }
    
    func buildTextViewElement(heading:String, detail:String) -> NSAttributedString {
        
        //Set fonts based on preferredFont so that they will resize with dynamic text.
        let boldFontAttribute = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        let bodyfontAttribute = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
        
        let attributedText = NSMutableAttributedString(string: "")
        let attributedHeading = NSAttributedString(string: "\(heading)\n", attributes: [.font: boldFontAttribute])
        attributedText.append(attributedHeading)
        
        if detail != "" {
            let attributedDeatail = NSAttributedString(string: "\(detail)\n\n", attributes: [.font: bodyfontAttribute])
            attributedText.append(attributedDeatail)
        }
        
        return attributedText
    }
    
    @IBAction func storeButtonTouched() {
        
        if let url = self.album?.storeUrl {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Could not open iTunes", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
    }
}

