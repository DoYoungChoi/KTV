//
//  HomeRecommendContainerCell.swift
//  KTV
//
//  Created by dodor on 2023/10/27.
//

import UIKit

protocol HomeRecommendContainerCellDelegate: AnyObject {
    func homeRecommendContainerCell(
        _ cell: HomeRecommendContainerCell,
        didSelectItemAt index: Int
    )
    func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell)
}

class HomeRecommendContainerCell: UITableViewCell {

    static let identifier: String = "HomeRecommendContainerCell"
    
    static func height(viewModel: HomeRecommendViewModel) -> CGFloat {
        let top: CGFloat = 84 - 6 // 첫번째 cell에서 bottom까지의 거리 - cell의 상단 여백
        let bottom: CGFloat = 71 - 6 // 마지막 cell 첫번째 bottom까지의 거리 - cell의 하단 여백
        let footerInset: CGFloat = 51 // container -> footer까지의 여백
        return HomeRecommendItemCell.height * CGFloat(viewModel.itemCount) + top + bottom + footerInset
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var foldButton: UIButton!
    
    weak var delegate: HomeRecommendContainerCellDelegate?
    private var viewModel: HomeRecommendViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        
        self.tableView.rowHeight = HomeRecommendItemCell.height
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(
            UINib(
                nibName: HomeRecommendItemCell.identifier,
                bundle: .main
            ),
            forCellReuseIdentifier: HomeRecommendItemCell.identifier
        )
    }
    
    @IBAction func foldButtonDidTap(_ sender: Any) {
        self.viewModel?.toggleFoldState()
        self.delegate?.homeRecommendContainerCellFoldChanged(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func setData(_ data: [Home.Recommend]) {
//        self.recommends = data
//        self.tableView.reloadData()
//    }
    
    func setViewModel(_ viewModel: HomeRecommendViewModel) {
        self.viewModel = viewModel
        self.setButtonImage(viewModel.isFolded)
        self.tableView.reloadData()
        viewModel.foldChanged = { [weak self] isFolded in
            self?.tableView.reloadData()
            self?.setButtonImage(isFolded)
        }
    }
    
    private func setButtonImage(_ isFolded: Bool) {
        let imageName: String = isFolded ? "chevron.down" : "chevron.up"
        self.foldButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

extension HomeRecommendContainerCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.itemCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeRecommendItemCell.identifier,
            for: indexPath
        )
        
        if let cell = cell as? HomeRecommendItemCell,
           let data = self.viewModel?.recommends?[indexPath.item] {
            cell.setData(data, rank: indexPath.item + 1)
        }
        
        return cell
    }
}
