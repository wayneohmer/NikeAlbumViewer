//
//  MasterViewController.swift
//  NikeAlbumViewer
//
//  Created by Wayne Ohmer on 7/28/18.
//  Copyright © 2018 Wayne Ohmer. All rights reserved.
//

import UIKit

class NAMasterViewController: UITableViewController {

    var detailViewController: NADetailViewController?
    var albums = [NAAlbumModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get the Album data
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NARSSManager.fetchAlbumData() { [weak self] albums in
            self?.handleAlumArray(albums: albums)
        }
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.tableView.tableFooterView = UIView()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            if !controllers.isEmpty, let navController = controllers[controllers.count-1] as? UINavigationController {
                detailViewController = navController.topViewController as? NADetailViewController
            }
        }
    }
    
    func handleAlumArray(albums:[NAAlbumModel]) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if albums.isEmpty {
                let alert = UIAlertController(title: "Error", message: "Could not load albums", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: false, completion: nil)
            }
            self.albums = albums
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //Crash operators in Apple template code. Not a fan, but if this fails the app is pretty much dead, so...
                let controller = (segue.destination as! UINavigationController).topViewController as! NADetailViewController
                controller.album = self.albums[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NAAlbumTableViewCell", for: indexPath) as? NAAlbumTableViewCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = self.albums[indexPath.row].name
        cell.artistLabel.text = self.albums[indexPath.row].artistName
        cell.artworkImageView.addAlbumCoverDropShadow()
        //Store the url for later verification.
        cell.imageUrlString = self.albums[indexPath.row].artworkUrl?.absoluteString ?? ""
        
        self.albums[indexPath.row].requestImage(){ [weak cell] (image, urlString) in
            DispatchQueue.main.async {
                // Make sure image url is still the url that was requested. Reused cells can have the wrong image displayed if we do not verify.
                if cell?.imageUrlString == urlString {
                    cell?.artworkImageView.image = image
                }
            }
        }
        return cell
    }

}

