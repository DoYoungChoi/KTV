//
//  LiveCell.swift
//  KTV
//
//  Created by dodor on 2023/11/02.
//

import UIKit

class LiveCell: UICollectionViewCell {

    static let identifier: String = "LiveCell"
    static let height: CGFloat = 70
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    private var imageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imageContainerView.layer.cornerRadius = 5
        self.imageContainerView.clipsToBounds = true
        self.liveLabel.layer.cornerRadius = 5
        self.liveLabel.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageTask?.cancel()
        self.imageTask = nil
        self.imageView.image = nil
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
    }

    func setData(_ data: Live.Item) {
        self.imageTask = self.imageView.loadImage(url: data.thumbnailUrl)
        self.descriptionLabel.text = data.channel
        self.titleLabel.text = data.title
    }
}
