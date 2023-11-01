//
//  MoreTableViewCell.swift
//  KTV
//
//  Created by dodor on 2023/11/01.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
    
    static let identifier: String = "MoreTableViewCell"
    static let height: CGFloat = 48

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var seperatorLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeButtonDidTap(_ sender: Any) {
    }
    
    func setItem(_ item: MoreItem, seperatorHidden: Bool) {
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.description
        self.seperatorLine.isHidden = seperatorHidden
    }
}
