//
//  GOJContactAddEditHeaderCell.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJContactAddEditHeaderCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var userImageView: UIImageView!

    //MARK:- Variables
    private var gradientLayer: CAGradientLayer?
    private var itemViewModel: GOJContactAddEditVM!
    private var cellType: GOJDetailCellType!

    //MARK:- Layout methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.layer.borderWidth = 3
        self.userImageView.layer.borderColor = UIColor.white.cgColor

        self.gradientLayer = CAGradientLayer()
        self.gradientLayer?.colors = [UIColor.white.cgColor, GOJColorConstants.applicationColor.withAlphaComponent(0.1).cgColor]
        self.gradientLayer?.locations = [0.0 , 1.0]
        self.gradientLayer?.startPoint = CGPoint(x: 1.0, y: 0.0)
        self.gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.gradientLayer?.frame = self.contentView.frame
        self.contentView.layer.insertSublayer(self.gradientLayer!, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer?.frame = self.contentView.frame
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
    }

    //MARK:- Actions
    @IBAction func editImageAction(_ sender: Any) {
        self.itemViewModel.openImagePicker()
    }

    //MARK:- Public Methods
    func configure(type: GOJDetailCellType, viewModel: GOJContactAddEditVM) {
        self.cellType = type
        self.itemViewModel = viewModel
        self.setupUI()
    }

    //MARK:- Private Methods
    private func setupUI() {
        self.setupImage(imageURL: self.itemViewModel.imageUrl(), image: self.itemViewModel.getSelectedImage())
    }

    private func setupImage(imageURL: String?, image: UIImage?) {
        self.userImageView.image = UIImage(named: GOJImageConstants.placeholderImage)
        if let image: UIImage = image {
            self.userImageView.image = image
        } else if let url: String = imageURL {
            GOJImageDownloadManager.sharedInstance.getImageWithPath(url: URL(string: url), indexPath: IndexPath(row: 0, section: 0)) { [weak self] (image, url, idxPath, error) in
                if let image = image{
                    DispatchQueue.main.async {
                        self?.userImageView.image = image
                    }
                }
            }
        }
    }
}
