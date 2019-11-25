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
        model = contact
        networkHandler = apiHandler
        self.delegate = delegate
        configureItemModels()
    }

    //MARK:- Public Methods
    func fetchDetails() {
        if let contactId: Int = model.contactID {
            callbackHandler?(GOJCallback.showLoader)
            networkHandler.getContactDetails(contactId: contactId) { [weak self] (models, error) in
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
        return GOJContactAddEditVM(contact: model, apiHandler: networkHandler, delegate: self)
    }

    //MARK:- Private Methods
    private func configureModel(model: GOJContactModel?) {
        if let model: GOJContactModel = model {
            self.model.update(model: model)
            configureItemModels()
            callbackHandler?(GOJCallback.reloadContent)
        }
    }

    private func configureItemModels() {
        cellItemModels = []

        cellItemModels.append(GOJContactDetailItemVM(contact: model, type: GOJDetailCellType.header, delegate: self))

        if model.phoneNumber?.isEmpty == false {
            cellItemModels.append(GOJContactDetailItemVM(contact: model, type: GOJDetailCellType.mobile, delegate: self))
        }

        if model.email?.isEmpty == false {
            cellItemModels.append(GOJContactDetailItemVM(contact: model, type: GOJDetailCellType.email, delegate: self))
        }
    }
}

//MARK:- GOJContactDetailsComnProtocol
extension GOJContactDetailVM: GOJContactDetailsComnProtocol{
    func toggleFavouriteStatus() {
        if let contactId: Int = model.contactID {
            callbackHandler?(GOJCallback.showLoader)
            let params: [String: Any] = ["favorite": !self.model.favorite!]
            networkHandler.updateContactDetails(contactId: contactId, params: params) { [weak self] (models, error) in
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
        configureModel(model: contact)
        delegate?.contactUpdated(contact: model)
    }

    func call(toMobile: String){
        callbackHandler?(GOJCallback.openCall(mobile: toMobile))
    }

    func message(toMobile: String){
        callbackHandler?(GOJCallback.openMessage(mobile: toMobile))
    }

    func mail(toEmail: String){
        callbackHandler?(GOJCallback.openMail(email: toEmail))

    }
}
