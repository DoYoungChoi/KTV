//
//  FavoriteViewController.swift
//  KTV
//
//  Created by dodor on 2023/11/01.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: FavoriteViewModel = .init()
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(
            UINib(
                nibName: VideoListItemCell.identifier,
                bundle: nil
            ),
            forCellReuseIdentifier: VideoListItemCell.identifier
        )
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.viewModel.dataChanged = { [weak self] in
            self?.tableView.reloadData()
        }
        self.viewModel.request()
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        VideoListItemCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.favorite?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(
            withIdentifier: VideoListItemCell.identifier,
            for: indexPath
        )
        
        if let cell = cell as? VideoListItemCell,
           let data = self.viewModel.favorite?.list[indexPath.item] {
            cell.setData(data, rank: nil)
        }
        
        return cell
    }
}
