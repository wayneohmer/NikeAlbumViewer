//
//  MasterViewController.swift
//  NikeAlbumViewer
//
//  Created by Wayne Ohmer on 7/28/18.
//  Copyright © 2018 Wayne Ohmer. All rights reserved.
//

import UIKit

class NAMasterViewController: UITableViewController {

    var detailViewController: NADetailViewController? = nil
    var albums = [NAAlbumModel]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NAFeedDecoder.getAlbumData(closure: self.handleAlumData)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView = UIView()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? NADetailViewController
        }
    }
    
    func handleAlumData(albums:[NAAlbumModel]) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NAAlbumTableViewCell", for: indexPath) as! NAAlbumTableViewCell
        
        cell.nameLabel.text = self.albums[indexPath.row].name
        cell.artistLabel.text = self.albums[indexPath.row].artistName
        cell.colverImageView.addAlbumCoverDropShadow()
        self.albums[indexPath.row].fetchImage(){ [weak cell] image in
            DispatchQueue.main.async {
                cell?.colverImageView.image = image
            }
        }
        return cell
    }

}

