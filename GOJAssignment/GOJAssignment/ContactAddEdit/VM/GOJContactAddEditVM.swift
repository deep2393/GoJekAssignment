//
//  GOJContactAddEditVM.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJContactAddEditVM: NSObject {

    //MARK:- Variables
    var model: GOJContactModel
    private let networkHandler: GOJAPIProtocol
    private weak var delegate: GOJContactDetailsComnProtocol?
    var callbackHandler: GOJCallbackHandler?
    var cellTypes: [GOJDetailCellType] = [GOJDetailCellType.header, GOJDetailCellType.firstName, GOJDetailCellType.lastName, GOJDetailCellType.mobile, GOJDetailCellType.email]


    //MARK:- Init Methods
    init(contact: GOJContactModel, apiHandler: GOJAPIProtocol, delegate: GOJContactDetailsComnProtocol) {
        model = contact
        networkHandler = apiHandler
        self.delegate = delegate
    }

    //MARK:- Public Methods
    func imageUrl() -> String? {
        return model.getProfileImage()
    }

    func getSelectedImage() -> UIImage? {
        return model.image
    }

    func getDetails(cellType: GOJDetailCellType) -> (key: String?, value: String?, keyboardType: UIKeyboardType) {
        var key: String? = ""
        var value: String? = ""
        var keyboardType: UIKeyboardType = UIKeyboardType.default

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
            keyboardType = UIKeyboardType.phonePad
        case .email:
            key = GOJStringConstants.email
            value = model.email
            keyboardType = UIKeyboardType.emailAddress
        default:
            break
        }
        return (key, value, keyboardType)
    }

    func update(value: Any?, cellType: GOJDetailCellType) {
        var localCopy: GOJContactModel = model
        switch cellType {
        case .firstName:
            localCopy.firstName = value as? String
        case .lastName:
            localCopy.lastName = value as? String
        case .mobile:
            localCopy.phoneNumber = value as? String
        case .email:
            localCopy.email = value as? String
        case .header:
            localCopy.image = value as? UIImage
        }
        model.update(model: localCopy)
    }

    func saveContact() {
        if let error: Error = model.validate() {
            callbackHandler?(GOJCallback.showError(error: error))
        } else {
            callbackHandler?(GOJCallback.showLoader)
            let params: [String: Any] = model.getDictionary()
            networkHandler.updateContactDetails(contactId: model.contactID, params: params) { [weak self] (models, error) in
                if let error: Error = error {
                    self?.callbackHandler?(GOJCallback.showError(error: error))
                } else if let updatedContact: GOJContactModel = models?.first{
                    if self?.model.contactID == nil {
                        self?.model.update(model: updatedContact)
                        self?.delegate?.contactAdded(contact: updatedContact)
                    } else {
                        self?.model.update(model: updatedContact)
                        self?.delegate?.contactUpdated(contact: updatedContact)
                    }
                    self?.callbackHandler?(GOJCallback.reloadContent)
                }
                self?.callbackHandler?(GOJCallback.hideLoader)
            }
        }
    }

    func openImagePicker() {
        callbackHandler?(GOJCallback.openImagePicker)
    }
}
