//
//  GOJContactDetailsInfoCell.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJContactDetailsInfoCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!

    //MARK:- Layout Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK:- Public Methods
    func configure(viewModel: GOJContactDetailItemVM) {
        let details = viewModel.getDetails()
        nameLabel.text = details.key
        detailsLabel.text = details.value
    }
    
}
