//
//  VideoViewController.swift
//  KTV
//
//  Created by dodor on 2023/11/01.
//

import UIKit
import AVKit

protocol VideoViewControllerDelegate: AnyObject {
    func videoViewController(
        _ videoViewController: VideoViewController,
        yPositionForMinimizeView height: CGFloat
    ) -> CGFloat
    
    func videoViewControllerDidMinimize(_ videoViewController: VideoViewController)
    func videoViewControllerNeedsMaximize(_ videoViewController: VideoViewController)
    func videoViewControllerDidTapClose(_ videoViewController: VideoViewController)
}

class VideoViewController: UIViewController {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.DD"
        return formatter
    }()
    
    // MARK: - 제어 패널
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var portraitControlPannel: UIView!
    @IBOutlet var landscapeControlPannel: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet var landscapePlayButton: UIButton!
    @IBOutlet var playerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var landscapeTitleLabel: UILabel!
    @IBOutlet var playTimeLabel: UILabel!
    @IBOutlet var seekbarView: SeekbarView!
    
    // MARK: - scroll
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var channelThumnailImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var recommendTableView: UITableView!
    @IBOutlet weak var recommendTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chattingView: ChattingView!
    @IBOutlet var chattingViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - 최소화 영역
    @IBOutlet weak var minimumView: UIView!
    @IBOutlet weak var minimumPlayerView: PlayerView!
    @IBOutlet weak var minimumTitleLabel: UILabel!
    @IBOutlet weak var minimumChannelNameLabel: UILabel!
    @IBOutlet weak var minimumPlayButton: UIButton!
    @IBOutlet weak var minimumViewBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: VideoViewControllerDelegate?
    var isLiveMode: Bool = false
    private var isMinimizeMode: Bool = false {
        didSet {
            self.minimumView.isHidden = !self.isMinimizeMode
        }
    }
    private var contentSizeObservation: NSKeyValueObservation?
    private var videoViewModel: VideoViewModel = .init()
    private let chattingHiddenBottomConstant: CGFloat = -500
    
    private var pipController: AVPictureInPictureController?

    private var isControlPannelHidden: Bool = true {
        didSet {
            if self.isLandscape(size: self.view.frame.size) {
                self.landscapeControlPannel.isHidden = self.isControlPannelHidden
            } else {
                self.portraitControlPannel.isHidden = self.isControlPannelHidden
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.minimumPlayerView.delegate = self
        self.seekbarView.delegate = self
        self.playerView.delegate = self
        self.chattingView.delegate = self
        self.channelThumnailImageView.layer.cornerRadius = 10
        self.setupRecommendTableView()
        self.bindViewModel()
        self.videoViewModel.request()
        self.chattingView.isHidden = !self.isLiveMode
        self.setupPIPController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isBeingPresented {
            self.setupPIPController()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isBeingDismissed {
            self.pipController = nil
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
//        self.setEditing(false, animated: true)
        self.switchControlPannel(size: size)
        self.playerViewBottomConstraint.isActive = self.isLandscape(size: size)
        
        self.chattingView.textField.resignFirstResponder()
        if self.isLandscape(size: size) {
            self.chattingViewBottomConstraint.constant = self.chattingHiddenBottomConstant
        } else {
            self.chattingViewBottomConstraint.constant = 0
        }
        coordinator.animate { _ in
            self.chattingView.collectionView.collectionViewLayout.invalidateLayout()
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func isLandscape(size: CGSize) -> Bool {
        size.width > size.height
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
        
        self.landscapeTitleLabel.text = video.title
        
        self.minimumTitleLabel.text = video.title
        self.minimumChannelNameLabel.text = video.channel
    }
    
    private func setupPIPController() {
        guard
            AVPictureInPictureController.isPictureInPictureSupported(),
            let playerLayer = self.playerView.avPlayerLayer
        else {
            return
        }
        
        let pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.canStartPictureInPictureAutomaticallyFromInline = true
        
        self.pipController = pipController
    }
}

extension VideoViewController {
    
    @IBAction func toggleControlPannel(_ sender: Any) {
        self.isControlPannelHidden.toggle()
    }
    
    @IBAction func closeDidTap(_ sender: Any) {
        self.isMinimizeMode = true
        self.rotateScene(landscape: false)
        self.dismiss(animated: true)
    }
    
    @IBAction func moreDidTap(_ sender: Any) {
        let moreVC = MoreViewController()
        self.present(moreVC, animated: true)
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
        self.rotateScene(landscape: true)
    }
    
    @IBAction func shrinkDidTap(_ sender: Any) {
        self.rotateScene(landscape: false)
    }
    
    @IBAction func commentDidTap(_ sender: Any) {
        if self.isLiveMode {
            self.chattingView.isHidden = false
        }
    }
    
    private func updatePlayButton(isPlaying: Bool) {
        let playImage = UIImage(systemName: isPlaying ? "pause.fill" : "play.fill")
        self.playButton.setImage(playImage, for: .normal)
        self.landscapePlayButton.setImage(playImage, for: .normal)
        self.minimumPlayButton.setImage(playImage, for: .normal)
    }
    
    private func switchControlPannel(size: CGSize) {
        guard self.isControlPannelHidden == false else {
            return
        }
        
        self.landscapeControlPannel.isHidden = !self.isLandscape(size: size)
        self.portraitControlPannel.isHidden = self.isLandscape(size: size)
    }
    
    private func rotateScene(landscape: Bool) {
        if #available(iOS 16.0, *) {
            self.view.window?.windowScene?.requestGeometryUpdate(
                .iOS(interfaceOrientations: landscape ? .landscapeRight : .portrait)
            )
        } else {
            let orientation: UIInterfaceOrientation = landscape ? .landscapeRight : .portrait
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
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
        self.seekbarView.setTotalPlayTime(self.playerView.totalPlayTime)
        self.updatePlayButton(isPlaying: playerView.isPlaying)
        self.updatePlayTime(0, totalPlayTime: playerView.totalPlayTime)
    }
    
    func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double) {
        self.seekbarView.setPlayTime(playTime, playableTime: playableTime)
        self.updatePlayTime(playTime, totalPlayTime: playerView.totalPlayTime)
    }
    
    func playerViewDidFinishToPlay(_ playerView: PlayerView) {
        self.playerView.seek(to: 0)
        self.updatePlayButton(isPlaying: false)
    }
    
    private func updatePlayTime(_ playTime: Double, totalPlayTime: Double) {
        guard
            let playTimeText = DateComponentsFormatter.timeFormatter.string(from: playTime),
            let totalPlayTimeText = DateComponentsFormatter.timeFormatter.string(from: totalPlayTime)
        else {
            self.playTimeLabel.text = nil
            return
        }
        
        self.playTimeLabel.text = "\(playTimeText) / \(totalPlayTimeText)"
    }
}

extension VideoViewController: SeekbarViewDelegate {
    func seekbar(_ seekbar: SeekbarView, seekToPercent percent: Double) {
        self.playerView.seek(to: percent)
    }
}

extension VideoViewController: ChattingViewDelegate {
    func liveChattingViewCloseDidTap(_ chattingView: ChattingView) {
        self.chattingView.isHidden = true
    }
}

extension VideoViewController {
    @IBAction func minimumViewCloseDidTap(_ sender: Any) {
        self.delegate?.videoViewControllerDidTapClose(self)
    }
    
    @IBAction func maximize(_ sender: Any) {
        self.delegate?.videoViewControllerNeedsMaximize(self)
    }
}

extension VideoViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
}

extension VideoViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.isBeingPresented {
            guard let view = transitionContext.view(forKey: .to) else {
                return
            }
            
            transitionContext.containerView.addSubview(view)
            
            if self.isMinimizeMode {
                self.chattingViewBottomConstraint.constant = 0
                self.playerViewBottomConstraint.isActive = false
                self.playerView.isHidden = false
                self.minimumViewBottomConstraint.isActive = false
                self.isMinimizeMode = false
                
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext)
                ) {
                    view.frame = .init(
                        origin: .init(x: 0, y: view.safeAreaInsets.top),
                        size: view.window?.frame.size ?? view.frame.size
                    )
                } completion: { _ in
                    view.frame.origin = .zero
                    transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                }
            } else {
                view.alpha = 0
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext)
                ) {
                    view.alpha = 1
                } completion: { _ in
                    transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                }
            }
        } else {
            guard let view = transitionContext.view(forKey: .from) else {
                return
            }
            
            if self.isMinimizeMode,
               let yPosition = self.delegate?.videoViewController(self, yPositionForMinimizeView: self.minimumView.frame.height) {
                self.minimumPlayerView.player = self.playerView.player
                self.isControlPannelHidden = true
                self.chattingViewBottomConstraint.constant = self.chattingHiddenBottomConstant
                self.playerViewBottomConstraint.isActive = true
                self.playerView.isHidden = true
                
                view.frame.origin.y = view.safeAreaInsets.top
                
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext)
                ) {
                    view.frame.origin.y = yPosition
                    view.frame.size.height = self.minimumView.frame.height
                } completion: { _ in
                    transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                    self.minimumViewBottomConstraint.isActive = true
                    self.delegate?.videoViewControllerDidMinimize(self)
                }
            } else {
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext)
                ) {
                    view.alpha = 0
                } completion: { _ in
                    transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                    view.alpha = 1
                }
            }
        }
    }
}
