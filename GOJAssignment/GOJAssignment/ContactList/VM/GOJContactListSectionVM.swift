//
//  GOJContactListSectionVM.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJContactListSectionVM {

    //MARK:- Variables
    let sectionTitle: String
    var itemArray: [GOJContactListItemVM]

    //MARK:- Init Methods
    init(title: String) {
        self.sectionTitle = title
        self.itemArray = [GOJContactListItemVM]()
    }

    //MARK:- Public methods
    func addContact(contact: GOJContactModel) {
        self.itemArray.append(GOJContactListItemVM(contactModel: contact))
    }
}
