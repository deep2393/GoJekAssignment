//
//  GOJContactListCell.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJContactListCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favStatusView: UIImageView!

    //MARK:- Variables
    private var itemViewModel: GOJContactListItemVM!
    private var indexPath: IndexPath!

    //MARK:- Layout Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.height / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.itemViewModel.callbackHandler = nil
    }

    //MARK:- Public Methods
    func configure(model: GOJContactListItemVM, indexPath: IndexPath) {
        self.itemViewModel = model
        self.indexPath = indexPath
        self.addHandler()
        self.setupUI()
    }

    //MARK:- Private Methods
    private func addHandler() {
        self.itemViewModel.callbackHandler = { [weak self] (callbackType: GOJCallback) in
            if let weakSelf: GOJContactListCell = self {
                DispatchQueue.main.async {
                    switch callbackType {
                    case .reloadContent:
                        weakSelf.setupUI()
                    default:
                        break
                    }
                }
            }
        }
    }

    private func setupUI() {
        self.nameLabel.text = self.itemViewModel.getFullName()
        self.favStatusView.isHidden = !self.itemViewModel.shouldShowFavButton()
        self.setupImage(imageURL: self.itemViewModel.imageUrl())
    }

    private func setupImage(imageURL: String?) {
        self.iconImageView.image = UIImage(named: GOJImageConstants.placeholderImage)
        if let url: String = imageURL {
            GOJImageDownloadManager.sharedInstance.getImageWithPath(url: URL(string: url), indexPath: self.indexPath) { [weak self] (image, url, idxPath, error) in
                if let image = image, idxPath == self?.indexPath {
                    DispatchQueue.main.async {
                        self?.iconImageView.image = image
                    }
                }
            }
        }
    }
}
