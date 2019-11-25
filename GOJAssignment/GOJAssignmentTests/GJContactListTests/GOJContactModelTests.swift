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
        self.sut = GOJContactModel(contactID: 9553, createdAt: nil, updatedAt: nil, contactDetailURL: "http://gojek-contacts-app.herokuapp.com/contacts/9553.json", profileImage: "/images/missing.png", firstName: "1Test", lastName: "ert", email: "test@test.com", phoneNumber: "9876543210", favorite: false, error: nil, errors: nil, image: nil)
    }

    override func tearDown() {
        self.sut = nil
    }

    //MARK:- Testing Methods
    func testFullName() {
        let fullName: String = self.sut.getFullName()
        XCTAssertEqual(fullName, "1Test ert", "Computed fullname is wrong")
    }

    func testProfileImageURL() {
        let imageURL: String? = self.sut.getProfileImage()
        if let imageURL: String = imageURL {
            XCTAssertEqual(imageURL, "\(kBaseUrl)/images/missing.png", "Invalid profile image url")
        } else {
            XCTAssertNotNil(imageURL, "Invalid profile image url")
        }
    }

    func testUpdateMethod() {
        var localCopy: GOJContactModel = self.sut
        localCopy.contactID = 9999
        self.sut.update(model: localCopy)
        XCTAssertEqual(localCopy.contactID, self.sut.contactID, "Invalid update outcome")
    }

    func testGetDictionary() {
        let dictionary: [String: Any] = self.sut.getDictionary()
        XCTAssertEqual((dictionary["first_name"] as? String), self.sut.firstName, "Invalid first name from dictionary")
        XCTAssertEqual((dictionary["last_name"] as? String), self.sut.lastName, "Invalid last name from dictionary")
        XCTAssertEqual((dictionary["email"] as? String), self.sut.email, "Invalid email from dictionary")
        XCTAssertEqual((dictionary["phone_number"] as? String), self.sut.phoneNumber, "Invalid phone number from dictionary")

    }

    func testValidate() {
        XCTAssertNil(self.sut.validate(), "Invalid first/last name")
    }

    func testError() {
        XCTAssertNil(self.sut.getError(), "Invalid response object")
    }
}
