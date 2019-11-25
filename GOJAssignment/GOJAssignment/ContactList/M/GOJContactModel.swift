//
//  GOJContactModel.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

struct GOJContactModel: Decodable {

    // MARK:- Variables
    var contactID: Int?
    var createdAt: String?
    var updatedAt: String?
    var contactDetailURL: String?
    var profileImage: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var favorite: Bool?
    var error: String?
    var errors: [String]?
    var image: UIImage?
    
    //MARK:- Coding Keys
    private enum CodingKeys: String, CodingKey {
        case contactID = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case phoneNumber = "phone_number"
        case profileImage = "profile_pic"
        case favorite = "favorite"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case contactDetailURL = "url"
        case error = "error"
        case errors = "errors"

    }

    //MARK:- Public Methods
    func getFullName() -> String {
        var str: String = ""

        if let text: String = firstName {
            str += text
        }

        if let text: String = lastName {
            if str.isEmpty == false {
                str += " "
            }
            str += text
        }

        return str
    }

    func getProfileImage() -> String? {
        if let imageUrl = profileImage {
            if imageUrl.contains("http") { // already contains host
                return imageUrl
            } else {
                return "\(kBaseUrl)\(imageUrl)"
            }
        }
        return nil
    }

    mutating func update(model: GOJContactModel) {
        self = model
    }

    func getDictionary() -> [String: Any] {
        var dictionary:[String: Any] = [String: Any]()
        if let text: String = firstName {
            dictionary[CodingKeys.firstName.rawValue] = text
        }

        if let text: String = lastName {
            dictionary[CodingKeys.lastName.rawValue] = text
        }

        if let text: String = phoneNumber {
            dictionary[CodingKeys.phoneNumber.rawValue] = text
        }

        if let text: String = email {
            dictionary[CodingKeys.email.rawValue] = text
        }

        dictionary[CodingKeys.favorite.rawValue] = false
        return dictionary
    }

    func validate() -> Error? {
        if firstName?.isEmpty != false, (self.firstName?.count ?? 0) < 2 {
            return NSError.getError(message: GOJStringConstants.invalidFirstName)
        }

        if lastName?.isEmpty != false, (self.lastName?.count ?? 0) < 2 {
            return NSError.getError(message: GOJStringConstants.invalidLastName)
        }
        return nil
    }

    func getError() -> String? {
        if let error: String = error {
            return error
        } else if let errors:[String] = errors {
            return errors.joined(separator: "\n")
        }
        return nil
    }
}
