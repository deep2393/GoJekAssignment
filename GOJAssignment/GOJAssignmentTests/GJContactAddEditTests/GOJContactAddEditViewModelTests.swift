//
//  GOJContactAddEditViewModelTests.swift
//
//  Created by Deepak Singh on 25/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//

import XCTest
@testable import GOJAssignment

class GOJContactAddEditViewModelTests: XCTestCase, GOJContactDetailsComnProtocol {

    //MARK:- Variables
    var model: GOJContactModel!
    var addEditVM: GOJContactAddEditVM!
    
    //MARK:- Life Cycle
    override func setUp() {
        model = GOJContactModel(contactID: 9553, createdAt: nil, updatedAt: nil, contactDetailURL: "http://gojek-contacts-app.herokuapp.com/contacts/9553.json", profileImage: "/images/missing.png", firstName: "1Test", lastName: "ert", email: "test@test.com", phoneNumber: "9876543210", favorite: false, error: nil, errors: nil, image: nil)
        addEditVM = GOJContactAddEditVM(contact: model, apiHandler: GOJMockAPIHandler(), delegate: self)
    }

    override func tearDown() {
        model = nil
        addEditVM = nil
    }

    //MARK:- Test Methods
    func testGetImageUrl() {
        let imageUrl: String? = addEditVM.imageUrl()
        XCTAssertEqual(imageUrl, "\(kBaseUrl)/images/missing.png", "Invalid image url")
    }

    func testGetSelectedImage() {
        XCTAssertNil(self.addEditVM.getSelectedImage(), "Invalid Image selection: no image has been selected")
    }

    func testGetDetails() {
        let details = addEditVM.getDetails(cellType: GOJDetailCellType.firstName)
        XCTAssertNotNil(details.key, "Invalid details fetched")
        XCTAssertNotNil(details.value, "Invalid details fetched")
        XCTAssertEqual(details.value, "1Test", "Invalid details fetched")
    }

    func testUpdateDetails() {
        addEditVM.update(value: "testFirstName", cellType: GOJDetailCellType.firstName)
        let details = addEditVM.getDetails(cellType: GOJDetailCellType.firstName)
        XCTAssertNotNil(details.key, "Update failed")
        XCTAssertNotNil(details.value, "Update failed")
        XCTAssertEqual(details.value, "testFirstName", "Update failed")
    }

    func testSaveContact()  {
        let promise: XCTestExpectation = expectation(description: "Contact Saved successfully")
        addEditVM.callbackHandler = {(callbackType: GOJCallback) in
            switch callbackType {
            case .showError(let error):
                XCTFail(error.localizedDescription)
            case .reloadContent:
                promise.fulfill()
            default:
                break
            }
        }
        addEditVM.update(value: "testFirstName", cellType: GOJDetailCellType.firstName)
        addEditVM.saveContact()
        wait(for: [promise], timeout: 5)
        XCTAssertNotNil(self.addEditVM.model.contactID, "Unable to save details of object")
        XCTAssertEqual(self.addEditVM.model.contactID, model.contactID, "Invalid details saved")
        let details = addEditVM.getDetails(cellType: GOJDetailCellType.firstName)
        XCTAssertNotNil(details.key, "Update failed")
        XCTAssertNotNil(details.value, "Update failed")
        XCTAssertEqual(details.value, "testFirstName", "Update failed")

    }
}
