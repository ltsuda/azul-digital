//
//  PostsTableViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 08/10/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    var posts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        navigationController?.navigationBar.barTintColor = UIColor(red: 221 / 255, green: 0 / 255, blue: 145 / 255, alpha: 1)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Posts"
        LoadingIndicatorView.show(Project.Localizable.Common.loading_data.localized)
        getPosts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postsCell", for: indexPath) as? PostCellTableViewCell else { return UITableViewCell() }
        // Configure the cell...
        
        guard let latest = posts?.reversed()[indexPath.row] else { return UITableViewCell() }
        cell.configure(post: latest)
        
        return cell
    }
}

extension PostsTableViewController: FBPostsReadable {
    func getPosts() {
        read(completionObject: { [weak self] (posts, error) in
            guard let posts = posts else { return }
            self?.posts = posts
            DispatchQueue.main.async {
                LoadingIndicatorView.hide()
                self?.animateTable()
            }
            })
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.0, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                }, completion: nil)
            delayCounter += 1
        }
    }
}
