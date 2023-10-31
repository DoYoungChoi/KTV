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
    
    private var imageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageTask?.cancel()
        self.imageTask = nil
        self.thumbnailImageView.image = nil
        self.rankingNumberLabel.text = nil
    }
    
    func setData(_ data: Home.Ranking, rank: Int) {
        self.rankingNumberLabel.text = "\(rank)"
        self.imageTask = .init {
            guard let responseData = try? await URLSession.shared.data(for: .init(url: data.imageUrl)).0 else {
                return
            }
            
            self.thumbnailImageView.image = UIImage(data: responseData)
        }
    }
}
