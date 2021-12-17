//
//  TVShowCellController.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import UIKit
import TVShows

public final class TVShowCellController: NSObject, UITableViewDataSource {
    
    private let viewModel: TVShowViewModel
    
    public init(viewModel: TVShowViewModel) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TVShowTableViewCell()
        
        cell.nameLabel.text = viewModel.name
        cell.dateLabel.text = viewModel.firstAirDate
        cell.voteAverageLabel.text = viewModel.voteAverage
        cell.overviewLabel.text = viewModel.overview
        
        return cell
    }
}
