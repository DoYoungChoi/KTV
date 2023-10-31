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
    
    private var imageTask: Task<Void, Never>?
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYMMDD"
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.albumImageView.layer.cornerRadius = 42
        self.albumImageView.layer.borderWidth = 2
        self.albumImageView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
    }

    @IBAction func playButtonTapped(_ sender: Any) {
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageTask?.cancel()
        self.imageTask = nil
        self.albumImageView.image = nil
        self.dateLabel.text = nil
        self.titleLabel.text = nil
        self.subtitleLabel.text = nil
        
    }
    
    func setData(_ data: Home.Recent) {
        self.imageTask = .init {
            guard let responseData = try? await URLSession.shared.data(for: .init(url: data.imageUrl)).0 else {
                return
            }
            
            self.albumImageView.image = UIImage(data: responseData)
        }
        self.dateLabel.text = Self.dateFormatter.string(from: .init(timeIntervalSince1970: data.timeStamp))
        self.titleLabel.text = data.title
        self.subtitleLabel.text = data.channel
    }
}
