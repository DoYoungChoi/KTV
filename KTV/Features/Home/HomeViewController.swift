//
//  HomeViewController.swift
//  KTV
//
//  Created by dodor on 2023/10/27.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let homeViewModel: HomeViewModel = .init()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        // JSON Data 연동
        self.bindViewModel()
        self.homeViewModel.requestData()
    }
    
    private func setupTableView() {
        self.tableView.register(
            UINib(nibName: HomeHeaderCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeHeaderCell.identifier
        )
        self.tableView.register(
            UINib(nibName: HomeVideoCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeVideoCell.identifier
        )
        self.tableView.register(
            UINib(nibName: HomeRankingContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRankingContainerCell.identifier
        )
        self.tableView.register(
            UINib(nibName: HomeRecentWatchContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRecentWatchContainerCell.identifier
        )
        self.tableView.register(
            UINib(nibName: HomeRecommendContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRecommendContainerCell.identifier
        )
        self.tableView.register(
            UINib(nibName: HomeFooterCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeFooterCell.identifier
        )
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "empty")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func bindViewModel() {
        // Label과 같은 경우는 바로 데이터를 받아 처리할 수 있지만,
        // Table View나 Collection View는 바로 데이터를 바인딩할 수 없기 때문에
        // 콜백을 받아 data를 reload 할 수 있도록 한다.
        self.homeViewModel.dataChanged = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        HomeSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = HomeSection(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .header:
            return 1
        case .video:
            return 2
        case .ranking:
            return 1
        case .recentWatch:
            return 1
        case .recommend:
            return 1
        case .footer:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return 0
        }
        
        switch section {
        case .header:
            return HomeHeaderCell.height
        case .video:
            return HomeVideoCell.height
        case .ranking:
            return HomeRankingContainerCell.height
        case .recentWatch:
            return HomeRecentWatchContainerCell.height
        case .recommend:
            return HomeRecommendContainerCell.height(
                viewModel: self.homeViewModel.recommendViewModel
            )
        case .footer:
            return HomeFooterCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .header:
            return tableView.dequeueReusableCell(withIdentifier: HomeHeaderCell.identifier, for: indexPath)
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeVideoCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeVideoCell,
               let data = self.homeViewModel.home?.videos[indexPath.item] {
                cell.setData(data)
            }
            
            return cell
        case .ranking:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRankingContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRankingContainerCell,
               let data = self.homeViewModel.home?.rankings {
                cell.setData(data)
                cell.delegate = self
            }
            
            return cell
        case .recentWatch:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecentWatchContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRecentWatchContainerCell,
               let data = self.homeViewModel.home?.recents {
                cell.setData(data)
                cell.delegate = self
            }
            
            return cell
        case .recommend:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRecommendContainerCell {
//               let data = self.homeViewModel.home?.recommends {
//                cell.setData(data)
                cell.setViewModel(self.homeViewModel.recommendViewModel)
                cell.delegate = self
            }
            
            return cell
        case .footer:
            return tableView.dequeueReusableCell(withIdentifier: HomeFooterCell.identifier, for: indexPath)
        }
    }
}

extension HomeViewController: HomeRecommendContainerCellDelegate {
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
        print("home recommend cell did select at \(index)")
    }
    
    func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell) {
        self.tableView.reloadData()
    }
}

extension HomeViewController: HomeRankingContainerCellDelegate {
    func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int) {
        print("home ranking cell did select at \(index)")
    }
}

extension HomeViewController: HomeRecentWatchContainerDelegate {
    func homeRecentWatchContainerDelegate(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int) {
        print("home recent watch cell did select at \(index)")
    }
}
