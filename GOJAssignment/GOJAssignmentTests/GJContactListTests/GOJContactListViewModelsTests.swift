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
        self.contactListVM = GOJContactListVM(apiHandler: GOJMockAPIHandler())
    }

    override func tearDown() {
        self.contactListVM = nil
    }

    //MARK:- Test Methods
    //MARK: GJContactListViewModel
    func testFetchContacts() {
        let promise: XCTestExpectation = expectation(description: "fetched Objects count > 0")
        self.contactListVM.callbackHandler = {(callbackType: GOJCallback) in
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
        self.contactListVM.fetchContacts()
        wait(for: [promise], timeout: 5)
        XCTAssertEqual(self.contactListVM.sectionViewModels.count , 20, "Unable to parse all objects")
    }

    func testGetSectionIndexTitles() {
        self.contactListVM.fetchContacts()
        if let indexTitles = self.contactListVM.getSectionIndexTitles() {
            XCTAssertEqual(indexTitles.count , 20, "Unable to parse all objects")
        }
    }

    func testGetItemViewModel() {
        self.contactListVM.fetchContacts()
        let itemVM:GOJContactListItemVM = self.contactListVM.getItemViewModel(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(itemVM.model.contactID , 9555, "Unable to fetch correct object")
    }

    func testGetDetailViewModel() {
        self.contactListVM.fetchContacts()
        let itemVM:GOJContactDetailVM = self.contactListVM.getDetailsViewModel(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(itemVM.model.contactID , 9555, "Unable to fetch correct object")
    }

    func testGetAddViewModel() {
        let itemVM:GOJContactAddEditVM = self.contactListVM.getAddViewModel()
        XCTAssertNil(itemVM.model.contactID, "Unable to fetch correct object")
    }

    //MARK: GJContactListSectionViewModel
    func testAddContact() {
        self.contactListVM.fetchContacts()
        let itemVM:GOJContactListSectionVM = self.contactListVM.sectionViewModels[0]
        let contactObj: GOJContactModel = itemVM.itemArray[0].model
        XCTAssertNotNil(contactObj.contactID, "Invalid Object")
        itemVM.addContact(contact: contactObj)
        XCTAssertEqual(itemVM.itemArray.last?.model.contactID , 9555, "Unable to add correct object")
    }

    //MARK: GJContactListItemViewModel

    func testGetFullName() {
        self.contactListVM.fetchContacts()
        let itemVM:GOJContactListItemVM = self.contactListVM.getItemViewModel(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(itemVM.getFullName() , "ABCDEF blablabla", "Invalid full name")
    }

    func testShouldShowFavButton() {
        self.contactListVM.fetchContacts()
        let itemVM:GOJContactListItemVM = self.contactListVM.getItemViewModel(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(itemVM.shouldShowFavButton() , true, "Invalid fav status")
    }

    func testImageURL() {
        self.contactListVM.fetchContacts()
        let itemVM:GOJContactListItemVM = self.contactListVM.getItemViewModel(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(itemVM.imageUrl() , "\(kBaseUrl)/images/missing.png", "Invalid image url")
    }

}
