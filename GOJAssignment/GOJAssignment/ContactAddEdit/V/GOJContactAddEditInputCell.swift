//
//  GOJContactAddEditInputCell.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJContactAddEditInputCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!

    //MARK:- Variables
    private var itemViewModel: GOJContactAddEditVM!
    private var cellType: GOJDetailCellType!

    //MARK:- Layout methods
    override func awakeFromNib() {
        super.awakeFromNib()
        inputField.delegate = self
    }

    //MARK:- Actions
    @IBAction func textDidChange(_ sender: Any) {
        itemViewModel.update(value: inputField.text, cellType: cellType)
    }

    //MARK:- Public Methods
    func configure(type: GOJDetailCellType, viewModel: GOJContactAddEditVM) {
        cellType = type
        itemViewModel = viewModel
        let details = itemViewModel.getDetails(cellType: cellType)
        nameLabel.text = details.key
        inputField.text = details.value
        inputField.keyboardType = details.keyboardType
    }
}

//MARK:- UITextFieldDelegate
extension GOJContactAddEditInputCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
