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
        contactImageView.layer.borderWidth = 3
        contactImageView.layer.borderColor = UIColor.white.cgColor

        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [UIColor.white.cgColor, GOJColorConstants.applicationColor.withAlphaComponent(0.1).cgColor]
        gradientLayer?.locations = [0.0 , 1.0]
        gradientLayer?.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer?.frame = contentView.frame
        contentView.layer.insertSublayer(self.gradientLayer!, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = contentView.frame
        contactImageView.layer.cornerRadius = contactImageView.frame.size.width / 2
    }

    //MARK:- Actions
    @IBAction func messageAction(_ sender: Any) {
        itemViewModel.openMessageInterface()
    }
    @IBAction func callAction(_ sender: Any) {
        itemViewModel.openCallInterface()
    }
    @IBAction func emailAction(_ sender: Any) {
        itemViewModel.openEmailInterface()
    }
    @IBAction func favAction(_ sender: Any) {
        itemViewModel.toggleFavourite()
    }

    //MARK:- Public Methods
    func configure(viewModel: GOJContactDetailItemVM) {
        itemViewModel = viewModel
        setupUI()
    }

    //MARK:- Private methods
    private func setupUI() {
        nameLabel.text = itemViewModel.getFullName()
        setupImage(imageURL: itemViewModel.imageUrl())
        if itemViewModel.shouldShowFavButton() {
            favImageView.image = UIImage(named: GOJImageConstants.favSelectedImage)
        } else {
            favImageView.image = UIImage(named: GOJImageConstants.favUnselectedImage)
        }
    }

    private func setupImage(imageURL: String?) {
        contactImageView.image = UIImage(named: GOJImageConstants.placeholderImage)
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
