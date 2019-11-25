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
        self.model = contact
        self.networkHandler = apiHandler
        self.delegate = delegate
    }

    //MARK:- Public Methods
    func imageUrl() -> String? {
        return self.model.getProfileImage()
    }

    func getSelectedImage() -> UIImage? {
        return self.model.image
    }

    func getDetails(cellType: GOJDetailCellType) -> (key: String?, value: String?, keyboardType: UIKeyboardType) {
        var key: String? = ""
        var value: String? = ""
        var keyboardType: UIKeyboardType = UIKeyboardType.default

        switch cellType {
        case .firstName:
            key = GOJStringConstants.firstName
            value = self.model.firstName
        case .lastName:
            key = GOJStringConstants.lastName
            value = self.model.lastName
        case .mobile:
            key = GOJStringConstants.mobile
            value = self.model.phoneNumber
            keyboardType = UIKeyboardType.phonePad
        case .email:
            key = GOJStringConstants.email
            value = self.model.email
            keyboardType = UIKeyboardType.emailAddress
        default:
            break
        }
        return (key, value, keyboardType)
    }

    func update(value: Any?, cellType: GOJDetailCellType) {
        var localCopy: GOJContactModel = self.model
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
        self.model.update(model: localCopy)
    }

    func saveContact() {
        if let error: Error = self.model.validate() {
            self.callbackHandler?(GOJCallback.showError(error: error))
        } else {
            self.callbackHandler?(GOJCallback.showLoader)
            let params: [String: Any] = self.model.getDictionary()
            self.networkHandler.updateContactDetails(contactId: self.model.contactID, params: params) { [weak self] (models, error) in
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
        self.callbackHandler?(GOJCallback.openImagePicker)
    }
}
