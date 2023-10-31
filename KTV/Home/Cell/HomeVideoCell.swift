//
//  HomeVideoCell.swift
//  KTV
//
//  Created by dodor on 2023/10/27.
//

import UIKit

class HomeVideoCell: UITableViewCell {
    
    static let identifier: String = "HomeVideoCell"
    static let height: CGFloat = 320

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var hotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var channelSubtitleLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var thumbnailTask: Task<Void, Never>?
    private var channelThumbnailTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        self.containerView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ data: Home.Video) {
        self.hotImageView.isHidden = !data.isHot
        self.titleLabel.text = data.title
        self.subtitleLabel.text = data.subtitle
        self.channelTitleLabel.text = data.channel
        self.channelSubtitleLabel.text = data.channelDescription
        self.thumbnailTask = .init {
            guard let responseData = try? await URLSession.shared.data(for: .init(url: data.imageUrl)).0 else {
                return
            }
            
            self.thumbnailImageView.image = UIImage(data: responseData)
        }
        self.channelThumbnailTask = .init {
            guard let responseData = try? await URLSession.shared.data(for: .init(url: data.channelThumbnailURL)).0 else {
                return
            }
            
            self.channelImageView.image = UIImage(data: responseData)
        }
    }
}
