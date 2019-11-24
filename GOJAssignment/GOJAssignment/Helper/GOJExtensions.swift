//
//  GOJExtensions.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//
import UIKit

//MARK:- Enums
enum GOJCallback {
    case showLoader
    case hideLoader
    case reloadContent
    case showError(error: Error)
    case openCall(mobile: String)
    case openMessage(mobile: String)
    case openMail(email: String)
    case openImagePicker
}

enum GODetailCellType {
    case header, firstName, lastName, email, mobile
}

enum GOJNetworkRequest: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum GOJOperationState: String{
    case ready, executing, finished
    var keyPath : String{
        return "is" + rawValue.capitalized
    }
}

//MARK:- TypeAliases
typealias GOJCallbackHandler = (_ callbackType: GOJCallback) -> Void
typealias ContactFetcherHandler = (_ contacts: [GOJContactModel]?, _ error: Error?) -> Void
typealias GOJNetworkHandler = (_ data: Data?, _ error: Error?) -> Void
typealias GOJImageDownloadHandler = (_ image: UIImage?, _ url: URL, _ indexPath: IndexPath?, _ error: Error?) -> Void

//MARK:- Protocols
protocol GOJAPIProtocol {
    func getContactList(completionHandler: @escaping ContactFetcherHandler)
    func getContactDetails(contactId: Int, completionHandler: @escaping ContactFetcherHandler)
    func updateContactDetails(contactId: Int?, params:[String: Any], completionHandler: @escaping ContactFetcherHandler)
}

protocol GOJContactDetailsComnProtocol: class {
    func toggleFavouriteStatus()
    func contactUpdated(contact: GOJContactModel)
    func contactAdded(contact: GOJContactModel)
    func call(toMobile: String)
    func message(toMobile: String)
    func mail(toEmail: String)
}

//MARK:- Extensions
extension GOJContactDetailsComnProtocol {
    func toggleFavouriteStatus(){}
    func contactUpdated(contact: GOJContactModel){}
    func contactAdded(contact: GOJContactModel){}
    func call(toMobile: String){}
    func message(toMobile: String){}
    func mail(toEmail: String){}
}

extension NSError {
    static func getError(message: String) -> Error {
        return NSError(domain: "com.gojek.customError", code: -999, userInfo: [NSLocalizedDescriptionKey : message])
    }
}
