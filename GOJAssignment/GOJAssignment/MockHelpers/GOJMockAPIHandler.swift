//
//  GOJMockAPIHandler.swift
//
//  Created by Deepak Singh on 25/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJMockAPIHandler: GOJAPIProtocol {

    //MARK:- GOJAPIProtocol
    func getContactList(completionHandler: @escaping ContactFetcherHandler) {
        if let path = Bundle.main.path(forResource: "mockContactList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder: JSONDecoder = JSONDecoder()
                let models: [GOJContactModel] = try decoder.decode([GOJContactModel].self, from:
                    data)
                completionHandler(models, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }

    func getContactDetails(contactId: Int, completionHandler: @escaping ContactFetcherHandler) {
        getContactList { (models, error) in
            if let error: Error = error {
                completionHandler(nil, error)
            } else if var model: GOJContactModel = models?.first {
                model.contactID = contactId
                completionHandler([model], nil)
            } else {
                completionHandler(nil, NSError.getError(message: "Unknown error"))
            }
        }
    }

    func updateContactDetails(contactId: Int?, params: [String : Any], completionHandler: @escaping ContactFetcherHandler) {
        getContactList { (models, error) in
            if let error: Error = error {
                completionHandler(nil, error)
            } else if var model: GOJContactModel = models?.first {
                if let contactId: Int = contactId {
                    model.contactID = contactId
                } else {
                    model.contactID = 99999
                }
                for (key, value) in params {
                    switch key {
                    case "first_name":
                        model.firstName = value as? String
                    case "last_name":
                        model.lastName = value as? String
                    case "favorite":
                        model.favorite = value as? Bool
                    case "phone_number":
                        model.phoneNumber = value as? String
                    case "email":
                        model.email = value as? String
                    default:
                        break
                    }
                }
                completionHandler([model], nil)
            } else {
                completionHandler(nil, NSError.getError(message: "Unknown error"))
            }
        }
    }


}
