//
//  HomeRecommendItemCell.swift
//  KTV
//
//  Created by dodor on 2023/10/27.
//

import UIKit

class VideoListItemCell: UITableViewCell {

    static let identifier: String = "VideoListItemCell"
    static let height: CGFloat = 71
    
    @IBOutlet weak var thumbnailContainerView: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playTimeBGView: UIView!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    private var imageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailContainerView.layer.cornerRadius = 5
        self.thumbnailContainerView.clipsToBounds = true
        self.rankLabel.layer.cornerRadius = 5
        self.rankLabel.clipsToBounds = true
        self.playTimeBGView.layer.cornerRadius = 3
        
        self.backgroundConfiguration = .clear()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.rankLabel.text = nil
        self.imageTask?.cancel()
        self.imageTask = nil
        self.thumbnailImageView.image = nil
        self.playTimeLabel.text = nil
        self.titleLabel.text = nil
        self.subtitleLabel.text = nil
    }
    
    func setData(_ data: VideoListItem, rank: Int?) {
        self.rankLabel.isHidden = rank == nil
        if let rank = rank {
            self.rankLabel.text = "\(rank)"
        }
        self.imageTask = self.thumbnailImageView.loadImage(url: data.imageUrl)
        self.playTimeLabel.text = DateComponentsFormatter.timeFormatter.string(from: data.playtime)
        self.titleLabel.text = data.title
        self.subtitleLabel.text = data.channel
    }
}
