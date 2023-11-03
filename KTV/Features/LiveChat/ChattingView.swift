//
//  ChattingView.swift
//  KTV
//
//  Created by dodor on 2023/11/03.
//

import UIKit

protocol ChattingViewDelegate: AnyObject {
    func liveChattingViewCloseDidTap(_ chattingView: ChattingView)
}

class ChattingView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    weak var delegate: ChattingViewDelegate?
    
    private let viewModel: ChattingViewModel = .init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCollectionView()
        self.setupTextField()
        self.toggleViewModel()
        self.bindViewModel()
    }
    
    override var isHidden: Bool {
        didSet {
            self.toggleViewModel()
        }
    }
    
    private func setupTextField() {
        self.textField.delegate = self
        self.textField.attributedPlaceholder = NSAttributedString(
            string: "채팅에 참여하세요!",
            attributes: [
                .foregroundColor: UIColor(named: "chat-text") ?? .black,
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
        )
    }
    
    @IBAction func closeDidTap(_ send: Any) {
        self.textField.resignFirstResponder()
        self.delegate?.liveChattingViewCloseDidTap(self)
    }
    
    @IBAction func dismissKeyboard(_ send: Any) {
        self.textField.resignFirstResponder()
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(
            UINib(nibName: LiveChatMessageCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LiveChatMessageCell.identifier
        )
        self.collectionView.register(
            UINib(nibName: LiveChatMyMessageCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LiveChatMyMessageCell.identifier
        )
    }
    
    private func bindViewModel() {
        self.viewModel.chatReceived = { [weak self] in
            self?.collectionView.reloadData()
            self?.scrollToLastestIfNeeded()
        }
    }
    
    private func toggleViewModel() {
        if self.isHidden {
            self.viewModel.stop()
        } else {
            self.viewModel.start()
        }
    }
    
    private func scrollToLastestIfNeeded() {
        let isBottomOffset = self.collectionView.bounds.maxY >= self.collectionView.contentSize.height - 200
        let isLastMessageMine = self.viewModel.messages.last?.isMine == true
        
        if isBottomOffset || isLastMessageMine {
            self.collectionView.scrollToItem(
                at: IndexPath(item: self.viewModel.messages.count - 1, section: 0),
                at: .bottom,
                animated: true
            )
        }
    }
    
}

extension ChattingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.viewModel.messages[indexPath.item]
        let width = collectionView.frame.width - 32
        
        if item.isMine {
            return LiveChatMyMessageCell.size(width: width, text: item.text)
        } else {
            return LiveChatMessageCell.size(width: width, text: item.text)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension ChattingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.viewModel.messages[indexPath.item]
        
        if item.isMine {
            let cell = self.collectionView.dequeueReusableCell(
                withReuseIdentifier: LiveChatMyMessageCell.identifier,
                for: indexPath
            )
            
            if let cell = cell as? LiveChatMyMessageCell {
                cell.setText(item.text)
            }
            
            return cell
        } else {
            let cell = self.collectionView.dequeueReusableCell(
                withReuseIdentifier: LiveChatMessageCell.identifier,
                for: indexPath
            )
            
            if let cell = cell as? LiveChatMessageCell {
                cell.setText(item.text)
            }
            
            return cell
        }
    }
}

extension ChattingView: UICollectionViewDelegate {
    
}

extension ChattingView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        
        self.viewModel.sendMessage(text)
        textField.text = nil
        
        return true
    }
}
