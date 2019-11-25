//
//  GOJContactDetailsHeaderCell.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJContactDetailsHeaderCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    //MARK:- Variables
    private var itemViewModel:GOJContactDetailItemVM!
    private var gradientLayer: CAGradientLayer?

    //MARK:- Layout methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contactImageView.layer.borderWidth = 3
        self.contactImageView.layer.borderColor = UIColor.white.cgColor

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
        self.contactImageView.layer.cornerRadius = self.contactImageView.frame.size.width / 2
    }

    //MARK:- Actions
    @IBAction func messageAction(_ sender: Any) {
        self.itemViewModel.openMessageInterface()
    }
    @IBAction func callAction(_ sender: Any) {
        self.itemViewModel.openCallInterface()
    }
    @IBAction func emailAction(_ sender: Any) {
        self.itemViewModel.openEmailInterface()
    }
    @IBAction func favAction(_ sender: Any) {
        self.itemViewModel.toggleFavourite()
    }

    //MARK:- Public Methods
    func configure(viewModel: GOJContactDetailItemVM) {
        self.itemViewModel = viewModel
        self.setupUI()
    }

    //MARK:- Private methods
    private func setupUI() {
        self.nameLabel.text = self.itemViewModel.getFullName()
        self.setupImage(imageURL: self.itemViewModel.imageUrl())
        if self.itemViewModel.shouldShowFavButton() {
            self.favImageView.image = UIImage(named: GOJImageConstants.favSelectedImage)
        } else {
            self.favImageView.image = UIImage(named: GOJImageConstants.favUnselectedImage)
        }
    }

    private func setupImage(imageURL: String?) {
        self.contactImageView.image = UIImage(named: GOJImageConstants.placeholderImage)
        if let url: String = imageURL {
            GOJImageDownloadManager.sharedInstance.getImageWithPath(url: URL(string: url), indexPath: IndexPath(row: 0, section: 0)) { [weak self] (image, url, idxPath, error) in
                if let image = image{
                    DispatchQueue.main.async {
                        self?.contactImageView.image = image
                    }
                }
            }
        }
    }
}
