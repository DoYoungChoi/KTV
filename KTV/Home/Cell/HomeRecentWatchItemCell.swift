//
//  HomeRecentWatchItemCell.swift
//  KTV
//
//  Created by dodor on 2023/10/30.
//

import UIKit

class HomeRecentWatchItemCell: UICollectionViewCell {
    
    static let identifier: String = "HomeRecentWatchItemCell"

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.albumImageView.layer.cornerRadius = 42
    }

    @IBAction func playButtonTapped(_ sender: Any) {
    }
}
