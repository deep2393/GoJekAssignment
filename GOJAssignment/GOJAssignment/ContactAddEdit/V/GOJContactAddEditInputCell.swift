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
        self.inputField.delegate = self
    }

    //MARK:- Actions
    @IBAction func textDidChange(_ sender: Any) {
        self.itemViewModel.update(value: self.inputField.text, cellType: self.cellType)
    }

    //MARK:- Public Methods
    func configure(type: GOJDetailCellType, viewModel: GOJContactAddEditVM) {
        self.cellType = type
        self.itemViewModel = viewModel
        let details = self.itemViewModel.getDetails(cellType: self.cellType)
        self.nameLabel.text = details.key
        self.inputField.text = details.value
        self.inputField.keyboardType = details.keyboardType
    }
}

//MARK:- UITextFieldDelegate
extension GOJContactAddEditInputCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
