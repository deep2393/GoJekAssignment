//
//  GOJApiHandler.swift
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//

import UIKit

let kBaseUrl = "http://gojek-contacts-app.herokuapp.com"

class GOJApiHandler: GOJAPIProtocol {

    //MARK:- Variables
    private let networkHandler: GOJNetworkHelper = GOJNetworkHelper()

    private static let networkParsingQueue: DispatchQueue = DispatchQueue(label: "com.gojek.networkParsingQueue", qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent)


    //MARK:- GOJAPIProtocol
    func getContactList(completionHandler: @escaping ContactFetcherHandler) {
        let requestModel: GOJNetworkRequestModel = GOJNetworkRequestModel(requestType: GOJNetworkRequest.get, url: "\(kBaseUrl)/contacts.json", parameters: nil, headers: nil)
        networkHandler.process(request: requestModel) { (data, error) in
            GOJApiHandler.networkParsingQueue.async {
                if let dataResponse: Data = data {
                    do {
                        let decoder: JSONDecoder = JSONDecoder()
                        let models: [GOJContactModel] = try decoder.decode([GOJContactModel].self, from:
                            dataResponse)
                        completionHandler(models, nil)
                    } catch let parsingError {
                        completionHandler(nil, parsingError)
                    }
                }else{
                    completionHandler(nil, error)
                }
            }
        }
    }

    func getContactDetails(contactId: Int, completionHandler: @escaping ContactFetcherHandler) {
        let requestModel: GOJNetworkRequestModel = GOJNetworkRequestModel(requestType: GOJNetworkRequest.get, url: "\(kBaseUrl)/contacts/\(contactId).json", parameters: nil, headers: nil)
        networkHandler.process(request: requestModel) { (data, error) in
            GOJApiHandler.networkParsingQueue.async {
                if let dataResponse: Data = data {
                    do {
                        let decoder: JSONDecoder = JSONDecoder()
                        let model: GOJContactModel = try decoder.decode(GOJContactModel.self, from: dataResponse)
                        if model.getError()?.isEmpty == false {
                            completionHandler(nil, NSError.getError(message: model.getError()!))
                        } else {
                            completionHandler([model], nil)
                        }
                    } catch let parsingError {
                        completionHandler(nil, parsingError)
                    }
                }else{
                    completionHandler(nil, error)
                }
            }
        }
    }

    func updateContactDetails(contactId: Int?, params: [String : Any], completionHandler: @escaping ContactFetcherHandler) {
        let requestModel: GOJNetworkRequestModel

        if let contactId: Int = contactId {
            requestModel = GOJNetworkRequestModel(requestType: GOJNetworkRequest.put, url: "\(kBaseUrl)/contacts/\(contactId).json", parameters: params, headers: ["Content-Type": "application/json"])
        } else {
            requestModel = GOJNetworkRequestModel(requestType: GOJNetworkRequest.post, url: "\(kBaseUrl)/contacts.json", parameters: params, headers: ["Content-Type": "application/json"])
        }
        networkHandler.process(request: requestModel) { (data, error) in
            GOJApiHandler.networkParsingQueue.async {
                if let dataResponse: Data = data {
                    do {
                        let decoder: JSONDecoder = JSONDecoder()
                        let model: GOJContactModel = try decoder.decode(GOJContactModel.self, from:
                            dataResponse)
                        if model.getError()?.isEmpty == false {
                            completionHandler(nil, NSError.getError(message: model.getError()!))
                        } else {
                            completionHandler([model], nil)
                        }
                    } catch let parsingError {
                        completionHandler(nil, parsingError)
                    }
                }else{
                    completionHandler(nil, error)
                }
            }
        }
    }

}
