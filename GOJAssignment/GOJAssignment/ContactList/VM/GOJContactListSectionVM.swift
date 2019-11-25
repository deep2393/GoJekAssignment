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
        sectionTitle = title
        itemArray = [GOJContactListItemVM]()
    }

    //MARK:- Public methods
    func addContact(contact: GOJContactModel) {
        itemArray.append(GOJContactListItemVM(contactModel: contact))
    }
}
