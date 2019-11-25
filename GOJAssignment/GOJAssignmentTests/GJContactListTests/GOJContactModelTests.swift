//
//  GOJContactModelTests.swift
//
//  Created by Deepak Singh on 25/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//

import XCTest
@testable import GOJAssignment

class GOJContactModelTests: XCTestCase {

    //MARK:- Variables
    var sut: GOJContactModel!

    //MARK:- Life Cycle
    override func setUp() {
        sut = GOJContactModel(contactID: 9553, createdAt: nil, updatedAt: nil, contactDetailURL: "http://gojek-contacts-app.herokuapp.com/contacts/9553.json", profileImage: "/images/missing.png", firstName: "1Test", lastName: "ert", email: "test@test.com", phoneNumber: "9876543210", favorite: false, error: nil, errors: nil, image: nil)
    }

    override func tearDown() {
        sut = nil
    }

    //MARK:- Testing Methods
    func testFullName() {
        let fullName: String = sut.getFullName()
        XCTAssertEqual(fullName, "1Test ert", "Computed fullname is wrong")
    }

    func testProfileImageURL() {
        let imageURL: String? = sut.getProfileImage()
        if let imageURL: String = imageURL {
            XCTAssertEqual(imageURL, "\(kBaseUrl)/images/missing.png", "Invalid profile image url")
        } else {
            XCTAssertNotNil(imageURL, "Invalid profile image url")
        }
    }

    func testUpdateMethod() {
        var localCopy: GOJContactModel = sut
        localCopy.contactID = 9999
        sut.update(model: localCopy)
        XCTAssertEqual(localCopy.contactID, sut.contactID, "Invalid update outcome")
    }

    func testGetDictionary() {
        let dictionary: [String: Any] = sut.getDictionary()
        XCTAssertEqual((dictionary["first_name"] as? String), sut.firstName, "Invalid first name from dictionary")
        XCTAssertEqual((dictionary["last_name"] as? String), sut.lastName, "Invalid last name from dictionary")
        XCTAssertEqual((dictionary["email"] as? String), sut.email, "Invalid email from dictionary")
        XCTAssertEqual((dictionary["phone_number"] as? String), sut.phoneNumber, "Invalid phone number from dictionary")

    }

    func testValidate() {
        XCTAssertNil(self.sut.validate(), "Invalid first/last name")
    }

    func testError() {
        XCTAssertNil(self.sut.getError(), "Invalid response object")
    }
}
