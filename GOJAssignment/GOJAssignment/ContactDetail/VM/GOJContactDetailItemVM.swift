//
//  GOJContactDetailItemVM.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJContactDetailItemVM: GOJContactListItemVM {

    //MARK:- Variables
    let cellType: GOJDetailCellType
    private weak var delegate: GOJContactDetailsComnProtocol?

    //MARK:- Init Methods
    init(contact: GOJContactModel, type: GOJDetailCellType, delegate: GOJContactDetailsComnProtocol) {
        self.cellType = type
        self.delegate = delegate
        super.init(contactModel: contact)
    }

    //MARK:- Public Methods
    func getDetails() -> (key: String?, value: String?) {
        var key: String? = ""
        var value: String? = ""

        switch self.cellType {
        case .firstName:
            key = GOJStringConstants.firstName
            value = self.model.firstName
        case .lastName:
            key = GOJStringConstants.lastName
            value = self.model.lastName
        case .mobile:
            key = GOJStringConstants.mobile
            value = self.model.phoneNumber
        case .email:
            key = GOJStringConstants.email
            value = self.model.email
        default:
            break
        }
        return (key, value)
    }

    func toggleFavourite() {
        self.delegate?.toggleFavouriteStatus()
    }

    func openCallInterface() {
        if let mobile = self.model.phoneNumber, mobile.isEmpty == false {
            self.delegate?.call(toMobile: mobile)
        }
    }

    func openMessageInterface() {
        if let mobile = self.model.phoneNumber, mobile.isEmpty == false {
            self.delegate?.message(toMobile: mobile)
        }
    }

    func openEmailInterface() {
        if let email = self.model.email, email.isEmpty == false {
            self.delegate?.mail(toEmail: email)
        }
    }
}
