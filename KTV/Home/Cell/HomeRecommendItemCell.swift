//
//  HomeRecommendItemCell.swift
//  KTV
//
//  Created by dodor on 2023/10/27.
//

import UIKit

class HomeRecommendItemCell: UITableViewCell {

    static let identifier: String = "HomeRecommendItemCell"
    static let height: CGFloat = 71
    
    @IBOutlet weak var thumbnailContainerview: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playTimeBGView: UIView!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailContainerview.layer.cornerRadius = 5
        self.rankLabel.layer.cornerRadius = 5
        self.rankLabel.clipsToBounds = true
        self.playTimeBGView.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
