//
//  TVShowsViewController.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import UIKit

public final class TVShowsViewController: UITableViewController {
    
    public var controllers = [TVShowCellController]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackBackground
        
    }
    
    private func registerCells() {
        tableView.register(TVShowTableViewCell.self, forCellReuseIdentifier: TVShowTableViewCell.dequeueIdentifier)
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        controllers.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        controllers[indexPath.row].tableView(tableView, cellForRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}
