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
        cellType = type
        self.delegate = delegate
        super.init(contactModel: contact)
    }

    //MARK:- Public Methods
    func getDetails() -> (key: String?, value: String?) {
        var key: String? = ""
        var value: String? = ""

        switch cellType {
        case .firstName:
            key = GOJStringConstants.firstName
            value = model.firstName
        case .lastName:
            key = GOJStringConstants.lastName
            value = model.lastName
        case .mobile:
            key = GOJStringConstants.mobile
            value = model.phoneNumber
        case .email:
            key = GOJStringConstants.email
            value = model.email
        default:
            break
        }
        return (key, value)
    }

    func toggleFavourite() {
        delegate?.toggleFavouriteStatus()
    }

    func openCallInterface() {
        if let mobile = model.phoneNumber, mobile.isEmpty == false {
            delegate?.call(toMobile: mobile)
        }
    }

    func openMessageInterface() {
        if let mobile = model.phoneNumber, mobile.isEmpty == false {
            delegate?.message(toMobile: mobile)
        }
    }

    func openEmailInterface() {
        if let email = model.email, email.isEmpty == false {
            delegate?.mail(toEmail: email)
        }
    }
}
