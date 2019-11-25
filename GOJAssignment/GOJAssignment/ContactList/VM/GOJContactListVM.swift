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
        networkHandler = apiHandler
    }

    //MARK:- Public Methods
    func fetchContacts() {
        callbackHandler?(GOJCallback.showLoader)
        networkHandler.getContactList { [weak self] (models, error) in
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
        if sectionViewModels.count > 0 {
            var titles: [String] = [String]()
            for model: GOJContactListSectionVM in sectionViewModels {
                titles.append(model.sectionTitle)
            }
            return titles
        }
        return nil
    }

    func getItemViewModel(indexPath: IndexPath) -> GOJContactListItemVM {
        return sectionViewModels[indexPath.section].itemArray[indexPath.row]
    }

    func getDetailsViewModel(indexPath: IndexPath) -> GOJContactDetailVM {
        let itemViewModel: GOJContactListItemVM = getItemViewModel(indexPath: indexPath)
        return GOJContactDetailVM(contact: itemViewModel.model, apiHandler: networkHandler, delegate: itemViewModel)
    }

    func getAddViewModel() -> GOJContactAddEditVM {
        return GOJContactAddEditVM(contact: GOJContactModel(), apiHandler: networkHandler, delegate: self)
    }


    //MARK:- Private Methods
    private func configureItemViewModels(models: [GOJContactModel]?) {
        if let models: [GOJContactModel] = models {
            for item in models {
                addContact(contact: item)
            }
        }
        populateSectionViewModelArray()
    }

    private func addContact(contact: GOJContactModel) {
        if let firstChar: String = contact.firstName?.prefix(1).uppercased() {
            var keyToMap: String = firstChar
            if firstChar < "A" || firstChar > "Z" {
                keyToMap = "#"
            }
            if let sectionViewModel: GOJContactListSectionVM = sectionModelMap[keyToMap] {
                sectionViewModel.addContact(contact: contact)
            } else {
                let sectionViewModel: GOJContactListSectionVM = GOJContactListSectionVM(title: keyToMap)
                sectionViewModel.addContact(contact: contact)
                sectionModelMap[keyToMap] = sectionViewModel
            }
        }
    }

    private func populateSectionViewModelArray() {
        let aScalars = "A".unicodeScalars
        let aCode = aScalars[aScalars.startIndex].value

        let letters: [String] = (0..<26).map {
            i in "\(Character(UnicodeScalar(aCode + UInt32(i))!))"
        }

        sectionViewModels = []
        for key in letters {
            if let sectionViewModel: GOJContactListSectionVM = sectionModelMap[key] {
                sectionViewModels.append(sectionViewModel)
            }
        }

        if let sectionViewModel: GOJContactListSectionVM = sectionModelMap["#"] {
            sectionViewModels.append(sectionViewModel)
        }
    }
}

//MARK:- GOJContactDetailsComnProtocol
extension GOJContactListVM: GOJContactDetailsComnProtocol {
    func contactAdded(contact: GOJContactModel){
        addContact(contact: contact)
        populateSectionViewModelArray()
        callbackHandler?(GOJCallback.reloadContent)
    }
}
