//
//  HomeRankingItemCell.swift
//  KTV
//
//  Created by dodor on 2023/10/30.
//

import UIKit

class HomeRankingItemCell: UICollectionViewCell {

    static let identifier: String = "HomeRankingItemCell"
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var rankingNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.rankingNumberLabel.text = nil
    }
    
    func setRank(_ rank: Int) {
        self.rankingNumberLabel.text = "\(rank)"
    }
}
