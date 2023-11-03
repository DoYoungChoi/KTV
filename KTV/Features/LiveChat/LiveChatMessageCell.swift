//
//  LiveChatMessageCell.swift
//  KTV
//
//  Created by dodor on 2023/11/03.
//

import UIKit

class LiveChatMessageCell: UICollectionViewCell {

    static let identifier: String = "LiveChatMessageCell"
    
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var textLabel: UILabel!
    
    
    private static let sizingCell = Bundle.main.loadNibNamed(
        LiveChatMessageCell.identifier,
        owner: nil
    )?.first(where: { $0 is LiveChatMessageCell }) as? LiveChatMessageCell
    
    static func size(width: CGFloat, text: String) -> CGSize {
        Self.sizingCell?.setText(text)
        Self.sizingCell?.frame.size.width = width
        let fittingSize = Self.sizingCell?.systemLayoutSizeFitting(
            .init(width: width, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return fittingSize ?? .zero
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgView.layer.cornerRadius = 8
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.textLabel.text = nil
    }
    
    func setText(_ text: String) {
        self.textLabel.text = text
    }
}
