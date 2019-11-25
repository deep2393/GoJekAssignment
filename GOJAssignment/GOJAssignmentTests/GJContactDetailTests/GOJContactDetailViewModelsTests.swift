//
//  GOJContactDetailViewModelsTests.swift
//
//  Created by Deepak Singh on 25/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//

import XCTest
@testable import GOJAssignment

class GOJContactDetailViewModelsTests: XCTestCase, GOJContactDetailsComnProtocol {

    //MARK:- Variables
    var model: GOJContactModel!
    var detailsVM: GOJContactDetailVM!
    var itemVM: GOJContactDetailItemVM!

    //MARK:- Life Cycle
    override func setUp() {
        self.model = GOJContactModel(contactID: 9553, createdAt: nil, updatedAt: nil, contactDetailURL: "http://gojek-contacts-app.herokuapp.com/contacts/9553.json", profileImage: "/images/missing.png", firstName: "1Test", lastName: "ert", email: "test@test.com", phoneNumber: "9876543210", favorite: false, error: nil, errors: nil, image: nil)
        self.detailsVM = GOJContactDetailVM(contact: self.model, apiHandler: GOJMockAPIHandler(), delegate: self)
        self.itemVM = GOJContactDetailItemVM(contact: self.model, type: GOJDetailCellType.firstName, delegate: self.detailsVM)
    }

    override func tearDown() {
        self.model = nil
        self.detailsVM = nil
    }

    //MARK:- Test Methods
    //MARK: GJContactDetailViewModel
    func testFetchDetails() {
        let promise: XCTestExpectation = expectation(description: "Details fetched")
        self.detailsVM.callbackHandler = {(callbackType: GOJCallback) in
            switch callbackType {
            case .showError(let error):
                XCTFail(error.localizedDescription)
            case .reloadContent:
                promise.fulfill()
            default:
                break
            }
        }

        self.detailsVM.fetchDetails()
        wait(for: [promise], timeout: 5)
        XCTAssertNotNil(self.detailsVM.model.contactID, "Unable to fetch details of object")
        XCTAssertEqual(self.detailsVM.model.contactID, self.model.contactID, "Invalid details fetched")
    }

    func testGetEditViewModel() {
        let itemVM: GOJContactAddEditVM = self.detailsVM.getEditViewModel()
        XCTAssertNotNil(itemVM.model.contactID, "Unable to fetch correct object")
        XCTAssertEqual(itemVM.model.contactID, self.model.contactID, "Invalid model fetched")
    }

    func testToggleFavStatus()  {
        let promise: XCTestExpectation = expectation(description: "Contact Saved successfully")
        self.detailsVM.callbackHandler = {(callbackType: GOJCallback) in
            switch callbackType {
            case .showError(let error):
                XCTFail(error.localizedDescription)
            case .reloadContent:
                promise.fulfill()
            default:
                break
            }
        }
        self.detailsVM.toggleFavouriteStatus()
        wait(for: [promise], timeout: 5)
        XCTAssertNotNil(self.detailsVM.model.favorite, "Unable to save details of object")
        XCTAssertEqual(self.detailsVM.model.contactID, self.model.contactID, "Invalid details saved")
        XCTAssertEqual(self.detailsVM.model.favorite, !self.model.favorite!, "Update failed")
    }

    //MARK: GJContactDetailItemViewModel
    func testGetDetails() {
        let details = self.itemVM.getDetails()
        XCTAssertNotNil(details.key, "Unable to fetch object details")
        XCTAssertNotNil(details.value, "Unable to fetch object details")
        XCTAssertEqual(details.value, self.model.firstName, "Invalid model details fetched")
    }
}
