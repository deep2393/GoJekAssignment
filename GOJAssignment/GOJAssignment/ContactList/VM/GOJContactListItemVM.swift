//
//  GOJContactListItemVM.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//

import UIKit

class GOJContactListItemVM {

    //MARK:- Variables
    var model : GOJContactModel
    var callbackHandler: GOJCallbackHandler?

    //MARK:- Init
    init(contactModel: GOJContactModel) {
        self.model = contactModel
    }

    //MARK:- Public Methods
    func getFullName() -> String {
        return self.model.getFullName()
    }

    func shouldShowFavButton() -> Bool {
        return self.model.favorite ?? false
    }

    func imageUrl() -> String? {
        return self.model.getProfileImage()
    }
}

//MARK:- GOJContactDetailsComnProtocol
extension GOJContactListItemVM: GOJContactDetailsComnProtocol {
    func contactUpdated(contact: GOJContactModel) {
        self.model.update(model: contact)
        self.callbackHandler?(GOJCallback.reloadContent)
    }
}
