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
    
    private var imageTask: Task<Void, Never>?
    private static let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        return formatter
    }()
    
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
    
    func setData(_ data: Home.Recommend, rank: Int?) {
        self.rankLabel.isHidden = rank == nil
        if let rank = rank {
            self.rankLabel.text = "\(rank)"
        }
        self.imageTask = .init {
            guard let responseData = try? await URLSession.shared.data(for: .init(url: data.imageUrl)).0 else {
                return
            }
            
            self.thumbnailImageView.image = UIImage(data: responseData)
        }
        self.playTimeLabel.text = Self.timeFormatter.string(from: data.playtime)
        self.titleLabel.text = data.title
        self.subtitleLabel.text = data.channel
    }
}
