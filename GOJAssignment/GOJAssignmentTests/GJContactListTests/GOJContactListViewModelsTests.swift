//
//  GOJContactListViewModelsTests.swift
//
//  Created by Deepak Singh on 25/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//
import XCTest
@testable import GOJAssignment

class GOJContactListViewModelsTests: XCTestCase {

    //MARK:- Variables
    var contactListVM: GOJContactListVM!

    //MARK:- Life Cycle
    override func setUp() {
        contactListVM = GOJContactListVM(apiHandler: GOJMockAPIHandler())
    }

    override func tearDown() {
        contactListVM = nil
    }

    //MARK:- Test Methods
    //MARK: GJContactListViewModel
    func testFetchContacts() {
        let promise: XCTestExpectation = expectation(description: "fetched Objects count > 0")
        contactListVM.callbackHandler = {(callbackType: GOJCallback) in
            switch callbackType {
            case .showError(let error):
                XCTFail(error.localizedDescription)
            case .reloadContent:
                promise.fulfill()
            default:
                break
            }
        }

        XCTAssertEqual(self.contactListVM.sectionViewModels.count, 0, "Results should be empty before the data task runs")
        contactListVM.fetchContacts()
        wait(for: [promise], timeout: 5)
        XCTAssertEqual(self.contactListVM.sectionViewModels.count , 20, "Unable to parse all objects")
    }

    func testGetSectionIndexTitles() {
        contactListVM.fetchContacts()
        if let indexTitles = contactListVM.getSectionIndexTitles() {
            XCTAssertEqual(indexTitles.count , 20, "Unable to parse all objects")
        }
    }

    func testGetItemViewModel() {
        contactListVM.fetchContacts()
        let itemVM:GOJContactListItemVM = contactListVM.getItemViewModel(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(itemVM.model.contactID , 9555, "Unable to fetch correct object")
    }

    func testGetDetailViewModel() {
        contactListVM.fetchContacts()
        let itemVM:GOJContactDetailVM = contactListVM.getDetailsViewModel(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(itemVM.model.contactID , 9555, "Unable to fetch correct object")
    }

    func testGetAddViewModel() {
        let itemVM:GOJContactAddEditVM = contactListVM.getAddViewModel()
        XCTAssertNil(itemVM.model.contactID, "Unable to fetch correct object")
    }

    //MARK: GJContactListSectionViewModel
    func testAddContact() {
        contactListVM.fetchContacts()
        let itemVM:GOJContactListSectionVM = contactListVM.sectionViewModels[0]
        let contactObj: GOJContactModel = itemVM.itemArray[0].model
        XCTAssertNotNil(contactObj.contactID, "Invalid Object")
        itemVM.addContact(contact: contactObj)
        XCTAssertEqual(itemVM.itemArray.last?.model.contactID , 9555, "Unable to add correct object")
    }

    //MARK: GJContactListItemViewModel

    func testGetFullName() {
        contactListVM.fetchContacts()
        let itemVM:GOJContactListItemVM = contactListVM.getItemViewModel(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(itemVM.getFullName() , "ABCDEF blablabla", "Invalid full name")
    }

    func testShouldShowFavButton() {
        contactListVM.fetchContacts()
        let itemVM:GOJContactListItemVM = contactListVM.getItemViewModel(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(itemVM.shouldShowFavButton() , true, "Invalid fav status")
    }

    func testImageURL() {
        contactListVM.fetchContacts()
        let itemVM:GOJContactListItemVM = contactListVM.getItemViewModel(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(itemVM.imageUrl() , "\(kBaseUrl)/images/missing.png", "Invalid image url")
    }

}
