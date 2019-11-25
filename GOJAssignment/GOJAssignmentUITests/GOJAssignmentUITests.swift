//
//  GOJAssignmentUITests.swift
//  GOJAssignmentUITests
//
//  Created by Deepak Singh on 24/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//

import XCTest

class GOJAssignmentUITests: XCTestCase {

    //MARK:- Variables
    var app: XCUIApplication!

    //MARK:- Life Cycle
    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    //MARK:- TestMethods
    func testListingPage() {
        let tablesQuery = app.tables
        let contactNavigationBar = app.navigationBars["Contact"]
        let groupButton = contactNavigationBar.buttons["Groups"]
        let addContactButton = contactNavigationBar.buttons["Add"]
        let tableIndexElement = tablesQuery.otherElements["table index"]
        let sectionHeader = tablesQuery.staticTexts["A"]
        XCTAssertTrue(contactNavigationBar.exists)
        XCTAssertTrue(groupButton.exists)
        XCTAssertTrue(addContactButton.exists)
        XCTAssertTrue(tableIndexElement.exists)
        XCTAssertTrue(sectionHeader.exists)
    }

    func testAddEditContactPage() {
                        
        let contactNavigationBar = app.navigationBars["Contact"]
        let addContactButton = contactNavigationBar.buttons["Add"]

        XCTAssertTrue(contactNavigationBar.exists)
        XCTAssertTrue(addContactButton.exists)
        wait(for: [], timeout: 5)
        addContactButton.tap()

        let addTableQuery = app.tables
        let firstNameField = addTableQuery.cells.staticTexts["First Name"]
        let lastNameField = addTableQuery.cells.staticTexts["Last Name"]
        let mobileField = addTableQuery.cells.staticTexts["mobile"]
        let emailField = addTableQuery.cells.staticTexts["email"]
        let imageViewQuery = addTableQuery.cells.containing(.image, identifier:"placeholder_photo")
        let actionSheetButton = imageViewQuery.children(matching: .button).element

        XCTAssertTrue(firstNameField.exists)
        XCTAssertTrue(lastNameField.exists)
        XCTAssertTrue(mobileField.exists)
        XCTAssertTrue(emailField.exists)
        XCTAssertTrue(actionSheetButton.exists)

        actionSheetButton.tap()
        wait(for: [], timeout: 5)

        let actionSheet = app.sheets["Choose Image"]
        let cameraPickerButton = actionSheet.buttons["Camera"]
        let galleryPickerButton = actionSheet.buttons["Gallery"]
        let cancelButton = actionSheet.buttons["Cancel"]

        XCTAssertTrue(actionSheet.exists)
        XCTAssertTrue(cameraPickerButton.exists)
        XCTAssertTrue(galleryPickerButton.exists)
        XCTAssertTrue(cancelButton.exists)

        cancelButton.tap()

        let navigationBar = app.navigationBars["GOJAssignment.GOJContactAddEditView"]
        let doneButton = navigationBar.buttons["Done"]
        let dismissButton = navigationBar.buttons["Cancel"]
        XCTAssertTrue(navigationBar.exists)
        XCTAssertTrue(doneButton.exists)
        XCTAssertTrue(dismissButton.exists)

        dismissButton.tap()
    }
}
