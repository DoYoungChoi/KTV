//
//  VideoViewController.swift
//  KTV
//
//  Created by dodor on 2023/11/01.
//

import UIKit

class VideoViewController: UIViewController {
    
    // MARK: - 제어 패널
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var portraitControlPannel: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - scroll
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var channelThumnailImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var recommendTableView: UITableView!
    @IBOutlet weak var recommendTableHeightConstraint: NSLayoutConstraint!
    
    private var contentSizeObservation: NSKeyValueObservation?
    private var videoViewModel: VideoViewModel = .init()
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.DD"
        return formatter
    }()
    private var isControlPannelHidden: Bool = true {
        didSet {
            self.portraitControlPannel.isHidden = isControlPannelHidden
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerView.delegate = self
        self.channelThumnailImageView.layer.cornerRadius = 10
        self.setupRecommendTableView()
        self.bindViewModel()
        self.videoViewModel.request()
    }

    @IBAction func commentDidTap(_ sender: Any) {
    }
    
    private func bindViewModel() {
        self.videoViewModel.dataChanged = { [weak self] video in
            self?.setupData(video)
        }
    }
    
    private func setupData(_ video: Video) {
        self.playerView.set(url: video.videoURL)
        self.playerView.play()
        self.titleLabel.text = video.title
        self.updateDateLabel.text = Self.dateFormatter.string(from: Date(timeIntervalSince1970: video.uploadTimestamp))
        self.playCountLabel.text = "재생수 \(video.playCount)"
        self.favoriteButton.setTitle("\(video.favoriteCount)", for: .normal)
        self.channelThumnailImageView.loadImage(url: video.channelImageUrl)
        self.channelNameLabel.text = video.channel
        self.recommendTableView.reloadData()
    }
}

extension VideoViewController {
    
    @IBAction func toggleControlPannel(_ sender: Any) {
        self.isControlPannelHidden.toggle()
    }
    
    @IBAction func closeDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func moreDidTap(_ sender: Any) {
        let moreVC = MoreViewController()
        self.present(moreVC, animated: false)
    }
    
    @IBAction func rewindDidTap(_ sender: Any) {
        self.playerView.rewind()
    }
    
    @IBAction func playDidTap(_ sender: Any) {
        if self.playerView.isPlaying {
            self.playerView.pause()
        } else {
            self.playerView.play()
        }
        
        self.updatePlayButton(isPlaying: self.playerView.isPlaying)
    }
    
    @IBAction func fastForwardDidTap(_ sender: Any) {
        self.playerView.forward()
    }
    
    @IBAction func expandDidTap(_ sender: Any) {
    }
    
    private func updatePlayButton(isPlaying: Bool) {
        let playImage = UIImage(systemName: isPlaying ? "pause.fill" : "play.fill")
        self.playButton.setImage(playImage, for: .normal)
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupRecommendTableView() {
        self.recommendTableView.delegate = self
        self.recommendTableView.dataSource = self
        self.recommendTableView.rowHeight = VideoListItemCell.height
        self.recommendTableView.register(
            UINib(
                nibName: VideoListItemCell.identifier,
                bundle: nil
            ),
            forCellReuseIdentifier: VideoListItemCell.identifier
        )
        
        self.contentSizeObservation = self.recommendTableView.observe(
            \.contentSize,
             changeHandler: { [weak self] tableView, _ in
                 self?.recommendTableHeightConstraint.constant = tableView.contentSize.height
             }
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.videoViewModel.video?.recommends.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoListItemCell.identifier, for: indexPath)
        
        if let cell = cell as? VideoListItemCell,
           let data = self.videoViewModel.video?.recommends[indexPath.item] {
            cell.setData(data, rank: indexPath.item + 1)
        }
        
        return cell
    }
}

extension VideoViewController: PlayerViewDelegate {
    func playerViewReadyToPlay(_ playerView: PlayerView) {
        self.updatePlayButton(isPlaying: playerView.isPlaying)
    }
    
    func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double) {
    }
    
    func playerViewDidFinishToPlay(_ playerView: PlayerView) {
        self.playerView.seek(to: 0)
        self.updatePlayButton(isPlaying: false)
    }
}
