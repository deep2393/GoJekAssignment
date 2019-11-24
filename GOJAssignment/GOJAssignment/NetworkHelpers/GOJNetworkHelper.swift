//
//  GOJNetworkHelper.swift
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//

import UIKit

struct GOJNetworkRequestModel {
    let requestType: GOJNetworkRequest
    let url: String
    var parameters: [AnyHashable: Any]?
    var headers: [String: String]?

}

class GOJNetworkHelper: NSObject {

    //MARK:- Variables
    private static let networkQueue: DispatchQueue = DispatchQueue(label: "com.gojek.networkQueue", qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent)

    //MARK:- Public Functions
    func process(request: GOJNetworkRequestModel, completionHandler: @escaping GOJNetworkHandler) {
        GOJNetworkHelper.networkQueue.async {
            guard let url: URL = URL(string: request.url)
                else{
                    completionHandler(nil, NSError.getError(message: "Invalid URL \(request.url)"))
                    return
            }

            var urlRequest: URLRequest = URLRequest(url: url)
            urlRequest.httpMethod = request.requestType.rawValue

            if let headers: [String: String] = request.headers {
                for (key, value) in headers {
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
            }

            if let parameters: [AnyHashable: Any] = request.parameters {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch let error {
                    completionHandler(nil, error)
                    return
                }
            }

            let urltask: URLSessionDataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                if self != nil {
                    completionHandler(data, error)
                }
            }
            urltask.resume()
        }
    }
}
