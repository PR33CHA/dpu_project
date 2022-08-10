//
//  trayTableViewController.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 30/11/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD

class trayTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - :D
    var keyArray: [String] = []
    var users: [User] = []
    var vans: [Van] = []
    var searchResults: [Van] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var avatarImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBarController()
        setupNavigationBar()
        observeVan()

        self.refreshControl?.tintColor = UIColor.systemRed
    
        // MARK: - Test
        print(Ref().databaseRoot.ref.description())
        print(Ref().databaseVans.ref.description())
        Ref().databaseVans.observe(.childAdded) { (sanpshot) in
        print("Sanpshot Key: \(sanpshot.key as Any)")
        }
        
    }
    
//    @IBAction func handleRefresh(_ sender: UIRefreshControl) {
//        print("REFESH")
//        self.refreshControl?.endRefreshing()
//
//    }
    
    @IBAction func handleRefresh(_ sender: UIRefreshControl) {
        print("REFESH")
        Api.Van.observeVan {
            (van) in
            self.vans.removeFirst()
            self.vans.append(van)
            self.tableView?.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func setupSearchBarController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Vcare"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(name: "Rubik-Medium", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.systemRed]
        
        let customFont = UIFont(name: "Rubik-Medium", size: 30.0)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: customFont as Any, NSAttributedString.Key.foregroundColor: UIColor.systemRed]
        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true
        containView.addSubview(avatarImageView)
        
        let leftBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.leftBarButtonItem = leftBarButton

        if let currentUser = Auth.auth().currentUser, let photoUrl = currentUser.photoURL {
            avatarImageView.loadImage(photoUrl.absoluteString)
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: NSNotification.Name("updateProfileImage"), object: nil)
        
        }
    
    @objc func updateProfile() {
        if let currentUser = Auth.auth().currentUser, let photoUrl = currentUser.photoURL {
            avatarImageView.loadImage(photoUrl.absoluteString)
        }
    }
    
    func observeVan() {
        Api.Van.observeVan() {
            (van) in
            self.vans.append(van)
            self.tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == nil || searchController.searchBar.text!.isEmpty {
            view.endEditing(true)
        } else {
            let textLowercased = searchController.searchBar.text!.lowercased()
            filterContent(for: textLowercased)
        }
        tableView.reloadData()
    }
    
    func filterContent(for searchText: String) {
        searchResults = self.vans.filter {
            return $0.curid.lowercased().range(of: searchText) != nil
        }
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return searchController.isActive ? searchResults.count: self.vans.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIRE_CELL_VAN, for: indexPath) as! vansTableViewCell
        
        let van = searchController.isActive ? searchResults[indexPath.row]: vans[indexPath.row]
        cell.controller = self
        cell.loadDataVan(van)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // MARK: - minimap
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? vansTableViewCell {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let minimapVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_DETAIL_VAN) as! minimapViewController
            minimapVC.van = cell.van
            minimapVC.imagePartner = cell.avt.image
            
            self.navigationController?.pushViewController(minimapVC, animated: true)
        }
    }
    
    //    MARK: - remove data [only admin]
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) -> Void {
        
            if editingStyle == .delete {
                
                if Api.User.currentUserId == (ADMIN_ID) {
                    
                    getAllKey()
                    
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when, execute: {
                        Ref().databaseVans.child(self.keyArray[indexPath.row]).removeValue(completionBlock: { (error, refer) in
                            if error != nil {
                                print(error as Any)
                                
                            } else {
                                print("Child Removed successfilly\([indexPath.row])")
                                
                            }
                            
                        })
                        self.keyArray = []
                        self.vans.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        print("path row: \([indexPath.row])")
                        
                    })
                    
                }

            }
        tableView.reloadData()
    }
    
//    MARK: - get keydata
    func getAllKey() {
        Ref().databaseVans.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                self.keyArray.append(key)
                print("Firebase Van Key: \(key)")
            }
        })
        
    }
    
}




