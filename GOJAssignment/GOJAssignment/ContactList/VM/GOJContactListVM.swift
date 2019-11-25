//
//  GOJContactListVM.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJContactListVM {

    //MARK:- Variables
    private let networkHandler: GOJAPIProtocol
    private var sectionModelMap: [String : GOJContactListSectionVM] = [String : GOJContactListSectionVM]()
    var callbackHandler: GOJCallbackHandler?
    var sectionViewModels: [GOJContactListSectionVM] = [GOJContactListSectionVM]()

    //MARK:- Init Methods
    init(apiHandler: GOJAPIProtocol) {
        self.networkHandler = apiHandler
    }

    //MARK:- Public Methods
    func fetchContacts() {
        self.callbackHandler?(GOJCallback.showLoader)
        self.networkHandler.getContactList { [weak self] (models, error) in
            if let error: Error = error {
                self?.callbackHandler?(GOJCallback.showError(error: error))
            } else {
                self?.configureItemViewModels(models: models)
                self?.callbackHandler?(GOJCallback.reloadContent)
            }
            self?.callbackHandler?(GOJCallback.hideLoader)
        }
    }

    func getSectionIndexTitles() -> [String]? {
        if self.sectionViewModels.count > 0 {
            var titles: [String] = [String]()
            for model: GOJContactListSectionVM in self.sectionViewModels {
                titles.append(model.sectionTitle)
            }
            return titles
        }
        return nil
    }

    func getItemViewModel(indexPath: IndexPath) -> GOJContactListItemVM {
        return self.sectionViewModels[indexPath.section].itemArray[indexPath.row]
    }

    func getDetailsViewModel(indexPath: IndexPath) -> GOJContactDetailVM {
        let itemViewModel: GOJContactListItemVM = self.getItemViewModel(indexPath: indexPath)
        return GOJContactDetailVM(contact: itemViewModel.model, apiHandler: self.networkHandler, delegate: itemViewModel)
    }

    func getAddViewModel() -> GOJContactAddEditVM {
        return GOJContactAddEditVM(contact: GOJContactModel(), apiHandler: self.networkHandler, delegate: self)
    }


    //MARK:- Private Methods
    private func configureItemViewModels(models: [GOJContactModel]?) {
        if let models: [GOJContactModel] = models {
            for item in models {
                self.addContact(contact: item)
            }
        }
        self.populateSectionViewModelArray()
    }

    private func addContact(contact: GOJContactModel) {
        if let firstChar: String = contact.firstName?.prefix(1).uppercased() {
            var keyToMap: String = firstChar
            if firstChar < "A" || firstChar > "Z" {
                keyToMap = "#"
            }
            if let sectionViewModel: GOJContactListSectionVM = self.sectionModelMap[keyToMap] {
                sectionViewModel.addContact(contact: contact)
            } else {
                let sectionViewModel: GOJContactListSectionVM = GOJContactListSectionVM(title: keyToMap)
                sectionViewModel.addContact(contact: contact)
                self.sectionModelMap[keyToMap] = sectionViewModel
            }
        }
    }

    private func populateSectionViewModelArray() {
        let aScalars = "A".unicodeScalars
        let aCode = aScalars[aScalars.startIndex].value

        let letters: [String] = (0..<26).map {
            i in "\(Character(UnicodeScalar(aCode + UInt32(i))!))"
        }

        self.sectionViewModels = []
        for key in letters {
            if let sectionViewModel: GOJContactListSectionVM = self.sectionModelMap[key] {
                self.sectionViewModels.append(sectionViewModel)
            }
        }

        if let sectionViewModel: GOJContactListSectionVM = self.sectionModelMap["#"] {
            self.sectionViewModels.append(sectionViewModel)
        }
    }
}

//MARK:- GOJContactDetailsComnProtocol
extension GOJContactListVM: GOJContactDetailsComnProtocol {
    func contactAdded(contact: GOJContactModel){
        self.addContact(contact: contact)
        self.populateSectionViewModelArray()
        self.callbackHandler?(GOJCallback.reloadContent)
    }
}
