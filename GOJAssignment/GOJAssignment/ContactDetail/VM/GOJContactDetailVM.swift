//
//  GOJContactDetailVM.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJContactDetailVM {

    //MARK:- Variables
    var model: GOJContactModel
    private let networkHandler: GOJAPIProtocol
    var callbackHandler: GOJCallbackHandler?
    var cellItemModels: [GOJContactDetailItemVM] = [GOJContactDetailItemVM]()
    private weak var delegate: GOJContactDetailsComnProtocol?

    //MARK:- Init Methods
    init(contact: GOJContactModel, apiHandler: GOJAPIProtocol, delegate: GOJContactDetailsComnProtocol) {
        self.model = contact
        self.networkHandler = apiHandler
        self.delegate = delegate
        self.configureItemModels()
    }

    //MARK:- Public Methods
    func fetchDetails() {
        if let contactId: Int = self.model.contactID {
            self.callbackHandler?(GOJCallback.showLoader)
            self.networkHandler.getContactDetails(contactId: contactId) { [weak self] (models, error) in
                if let error: Error = error {
                    self?.callbackHandler?(GOJCallback.showError(error: error))
                } else {
                    self?.configureModel(model: models?.first)
                }
                self?.callbackHandler?(GOJCallback.hideLoader)
            }
        }
    }

    func getEditViewModel() -> GOJContactAddEditVM {
        return GOJContactAddEditVM(contact: self.model, apiHandler: self.networkHandler, delegate: self)
    }

    //MARK:- Private Methods
    private func configureModel(model: GOJContactModel?) {
        if let model: GOJContactModel = model {
            self.model.update(model: model)
            self.configureItemModels()
            self.callbackHandler?(GOJCallback.reloadContent)
        }
    }

    private func configureItemModels() {
        self.cellItemModels = []

        self.cellItemModels.append(GOJContactDetailItemVM(contact: self.model, type: GOJDetailCellType.header, delegate: self))

        if self.model.phoneNumber?.isEmpty == false {
            self.cellItemModels.append(GOJContactDetailItemVM(contact: self.model, type: GOJDetailCellType.mobile, delegate: self))
        }

        if self.model.email?.isEmpty == false {
            self.cellItemModels.append(GOJContactDetailItemVM(contact: self.model, type: GOJDetailCellType.email, delegate: self))
        }
    }
}

//MARK:- GOJContactDetailsComnProtocol
extension GOJContactDetailVM: GOJContactDetailsComnProtocol{
    func toggleFavouriteStatus() {
        if let contactId: Int = self.model.contactID {
            self.callbackHandler?(GOJCallback.showLoader)
            let params: [String: Any] = ["favorite": !self.model.favorite!]
            self.networkHandler.updateContactDetails(contactId: contactId, params: params) { [weak self] (models, error) in
                if let error: Error = error {
                    self?.callbackHandler?(GOJCallback.showError(error: error))
                } else {
                    self?.configureModel(model: models?.first)
                    self?.delegate?.contactUpdated(contact: self!.model)
                }
                self?.callbackHandler?(GOJCallback.hideLoader)
            }
        }
    }

    func contactUpdated(contact: GOJContactModel) {
        self.configureModel(model: contact)
        self.delegate?.contactUpdated(contact: self.model)
    }

    func call(toMobile: String){
        self.callbackHandler?(GOJCallback.openCall(mobile: toMobile))
    }

    func message(toMobile: String){
        self.callbackHandler?(GOJCallback.openMessage(mobile: toMobile))
    }

    func mail(toEmail: String){
        self.callbackHandler?(GOJCallback.openMail(email: toEmail))

    }
}
