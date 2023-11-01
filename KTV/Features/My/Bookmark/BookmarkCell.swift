//
//  BookmarkCell.swift
//  KTV
//
//  Created by dodor on 2023/11/01.
//

import UIKit

class BookmarkCell: UITableViewCell {

    static let identifier: String = "BookmarkCell"
    static let height: CGFloat = 70
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var imageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.nameLabel.text = nil
        self.imageTask?.cancel()
        self.imageTask = nil
        self.thumbnailImageView.image = nil
    }
    
    func setData(_ data: Bookmark.Channel) {
        self.nameLabel.text = data.name
        self.imageTask = self.thumbnailImageView.loadImage(url: data.thumbnail)
    }
}