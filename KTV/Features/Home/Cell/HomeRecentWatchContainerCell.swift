//
//  HomeRecentWatchContainerCell.swift
//  KTV
//
//  Created by dodor on 2023/10/30.
//

import UIKit

protocol HomeRecentWatchContainerDelegate: AnyObject {
    func homeRecentWatchContainerDelegate(
        _ cell: HomeRecentWatchContainerCell,
        didSelectItemAt index: Int
    )
}

class HomeRecentWatchContainerCell: UITableViewCell {

    static let identifier: String = "HomeRecentWatchContainerCell"
    static let height: CGFloat = 209

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: HomeRecentWatchContainerDelegate?
    
    private var recents: [Home.Recent]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor(named: "stroke_light")?.cgColor
        
        self.collectionView.register(
            UINib(nibName: HomeRecentWatchItemCell.identifier, bundle: .main),
            forCellWithReuseIdentifier: HomeRecentWatchItemCell.identifier
        )
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ data: [Home.Recent]) {
        self.recents = data
        self.collectionView.reloadData()
    }
}

extension HomeRecentWatchContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recents?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeRecentWatchItemCell.identifier,
            for: indexPath
        )
        
        if let cell = cell as? HomeRecentWatchItemCell,
           let data = self.recents?[indexPath.item] {
            cell.setData(data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.homeRecentWatchContainerDelegate(self, didSelectItemAt: indexPath.item)
    }
}
