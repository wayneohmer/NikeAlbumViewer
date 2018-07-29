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
        
        self.storeButton.layer.cornerRadius = 5
        
        album?.fetchImage() { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
        self.navigationItem.title = self.album?.name ?? ""
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(self.buildTextElement(header: "\(album?.name ?? "")\n", detail:""))
        attributedText.append(self.buildTextElement(header: "Artist", detail: album?.artistName ?? ""))
        attributedText.append(self.buildTextElement(header: "Genre", detail: album?.genre ?? ""))
        attributedText.append(self.buildTextElement(header: "Release Date", detail: album?.releaseDate ?? ""))
        attributedText.append(self.buildTextElement(header: "Copyright", detail: album?.copyright ?? ""))

        self.textView.attributedText = attributedText
        self.textView.textAlignment = .center
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.imageView.addAlbumCoverDropShadow()
        // fixes the annoying scroll issue where the textView is not rendered scrolled to the top
        // https://stackoverflow.com/a/34248700
        self.textView.setContentOffset(.zero, animated: false)
    }
    
    func buildTextElement(header:String, detail:String) -> NSAttributedString {
        
        let boldFontAttribute = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        let bodyfontAttribute = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
        
        let attributedText = NSMutableAttributedString(string: "")
        let heading = NSAttributedString(string: "\(header)\n", attributes: [.font: boldFontAttribute])
        attributedText.append(heading)
        if detail != "" {
            let data = NSAttributedString(string: "\(detail)\n\n", attributes: [.font: bodyfontAttribute])
            attributedText.append(data)
        }
        
        return attributedText
    }
    
    @IBAction func storeButtonTouched() {
        if let url = self.album?.url {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

