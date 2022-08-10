//
//  peopleTableViewController.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 30/11/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class peopleTableViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - :D
//    var keyArray: [String] = []
    var users: [User] = []
    var searchResults: [User] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var avatarImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBarController()
        setupNavigationBar()
        observeUser()
        
        self.refreshControl?.tintColor = UIColor.systemRed
        
        // MARK: - Test
        print(Ref().databaseRoot.ref.description())
        print(Ref().databaseUser.ref.description())
        Ref().databaseUser.observe(.childAdded) { (sanpshot) in
            print(sanpshot.value as Any)
        }
    
    }
    
//    @IBAction func handleRefresh(_ sender: UIRefreshControl) {
//        print("REFESH")
//        Api.User.observeUser {
//            (user) in
//            self.users.removeFirst()
//            self.users.append(user)
//            self.tableView?.reloadData()
//            self.refreshControl?.endRefreshing()
//        }
//    }
    
    func setupSearchBarController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Users"
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
    
    func observeUser() {
        Api.User.observeUser {
            (user) in
            self.users.append(user)
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
        searchResults = self.users.filter {
            return $0.username.lowercased().range(of: searchText) != nil
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchController.isActive ? searchResults.count: self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIRE_CELL_USER, for: indexPath) as! userTableViewCell
        
        let user = searchController.isActive ? searchResults[indexPath.row]: users[indexPath.row]
        cell.controller = self
        cell.loadData(user)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    // MARK: -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? userTableViewCell {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_DETAIL_USER) as! detailViewController
            detailVC.user = cell.user
            
             detailVC.imagePartner = cell.avatar.image
         
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}
