//
//  PlayerView.swift
//  KTV
//
//  Created by dodor on 2023/11/02.
//

import UIKit
import AVFoundation

protocol PlayerViewDelegate: AnyObject {
    
    func playerViewReadyToPlay(_ playerView: PlayerView)
    func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double)
    func playerViewDidFinishToPlay(_ playerView: PlayerView)
    
}
                
class PlayerView: UIView {

    // MARK: - AVPlayerLayer를 설정하는 두 가지 방법
    // 1. self.layer는 view의 크기에 맞춰서 설정되어 있음
    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    var avPlayerLayer: AVPlayerLayer? {
        self.layer as? AVPlayerLayer
    }
    
//    // 2. layer는 auto layout을 지원하지 않기 때문에
//    // 아래와 같은 경우는 playerLayer에 대한
//    // View, subView의 frame을 직접 지정해주어야 함
//    let avPlayerLayer1: AVPlayerLayer = AVPlayerLayer()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        self.layer.addSublayer(self.avPlayerLayer1)
//        self.avPlayerLayer1.frame = self.bounds
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//
//        self.layer.addSublayer(self.avPlayerLayer1)
//        self.avPlayerLayer1.frame = self.bounds
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.avPlayerLayer1.frame = self.bounds
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupNotification()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupNotification()
    }
    
    private var playObservation: Any?
    private var statusObservation: NSKeyValueObservation?
    weak var delegate: PlayerViewDelegate?
    
    var isPlaying: Bool {
        guard let player else {
            return false
        }
        
        return player.rate != 0 // pause인 상태에서는 player.rate == 0
    }
    
    var totalPlayTime: Double {
        self.player?.currentItem?.duration.seconds ?? 0
    }
    
    // 영상의 재생을 담당
    var player: AVPlayer? {
        get { self.avPlayerLayer?.player }
        set {
            if let oldPlayer = self.avPlayerLayer?.player {
                self.unsetPlayer(player: oldPlayer)
            }
            
            self.avPlayerLayer?.player = newValue
            if let player = newValue {
                self.setup(player: player)
            }
        }
    }
    
    // 영상 로드
    func set(url: URL) {
        // playerItem: AVPlayer에서 재생되는 영상들의 item 단위
        self.player = AVPlayer(
            playerItem: AVPlayerItem(
                asset: AVURLAsset(url: url)
            )
        )
    }
    
    func play() {
        self.player?.play()
    }
    
    func pause() {
        self.player?.pause()
    }
    
    func seek(to percent: Double) {
        self.player?.seek(
            to: CMTime(seconds: percent * self.totalPlayTime, preferredTimescale: 1)
        )
    }
    
    func forward(to seconds: Double = 10) {
        guard let currentTime = self.player?.currentItem?.currentTime().seconds else {
            return
        }
        
        self.player?.seek(
            to: CMTime(seconds: currentTime + 10, preferredTimescale: 1)
        )
    }
    
    func rewind(to seconds: Double = 10) {
        guard let currentTime = self.player?.currentItem?.currentTime().seconds else {
            return
        }
        
        self.player?.seek(
            to: CMTime(seconds: currentTime - 10, preferredTimescale: 1)
        )
    }
}

extension PlayerView {
    
    private func setup(player: AVPlayer) {
        player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 10),
            queue: .main
        ) { [weak self, weak player] time in
            guard let self else {
                return
            }
            
            guard
                let currentItem = player?.currentItem,
                currentItem.status == .readyToPlay,
                let timeRange = (currentItem.loadedTimeRanges as? [CMTimeRange])?.first
            else {
                return
            }
            
            let playableTime = timeRange.start.seconds + timeRange.duration.seconds
            let playTime = time.seconds
            
            self.delegate?.playerView(self, didPlay: playTime, playableTime: playableTime)
        }
        
        self.statusObservation = player.currentItem?.observe(\.status, changeHandler: { [weak self] item, _ in
            guard let self else {
                return
            }
            
            switch item.status {
            case .readyToPlay:
                self.delegate?.playerViewReadyToPlay(self)
            case .failed, .unknown:
                print("failed to play \(item.error?.localizedDescription ?? "")")
            @unknown default:
                print("failed to play \(item.error?.localizedDescription ?? "")")
            }
        })
    }
    
    private func unsetPlayer(player: AVPlayer) {
        self.statusObservation?.invalidate()
        self.statusObservation = nil
        if let playObservation {
            player.removeTimeObserver(playObservation)
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didPlayToEnd(_:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }
    
    @objc private func didPlayToEnd(_ notification: Notification) {
        self.delegate?.playerViewDidFinishToPlay(self)
    }
}
