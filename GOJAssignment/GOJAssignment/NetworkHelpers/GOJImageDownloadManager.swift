//
//  GOJImageDownloadManager.swift
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//

import UIKit

final class GOJImageDownloadManager {

    //MARK:- Variables
    static let sharedInstance = GOJImageDownloadManager()
    private var cache = NSCache<NSString, UIImage>()
    lazy private var imageDownloadQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.goJek.downloadQueue"
        queue.qualityOfService = QualityOfService.utility
        return queue
    }()

    //MARK:- Init Methods
    private init(){}

    //MARK:- Public Methods
    public func getImageWithPath(url: URL?, indexPath: IndexPath, completionHandler: @escaping GOJImageDownloadHandler) {

        guard let imageUrl = url else{
            return
        }

        if let image = cache.object(forKey: imageUrl.absoluteString as NSString) {
            completionHandler(image, imageUrl, indexPath, nil)
        } else {
            if let operation = imageDownloadQueue.operations.filter({ (obj) -> Bool in
                if let downloadOperation = obj as? GOJImageDownloadOperation{
                    return downloadOperation.imageUrl == imageUrl && downloadOperation.state == .executing
                }
                return false
            }).first{
                operation.queuePriority = .veryHigh
                (operation as? GOJImageDownloadOperation)?.completionHandlers.append((completionHandler, indexPath))
            } else{
                let operation = GOJImageDownloadOperation(url: imageUrl)
                operation.completionHandlers.append((completionHandler, indexPath))
                operation.downloadHandler = { [weak self](image, url, indexPath, error) in
                    guard let weakSelf = self else{
                        return
                    }
                    if let newImage = image {
                        weakSelf.cache.setObject(newImage, forKey: url.absoluteString as NSString)
                    }
                    for completions in operation.completionHandlers {
                        completions.handler(image, url, completions.indexPath, error)
                    }
                    operation.completionHandlers = []
                }
                operation.queuePriority = .high
                imageDownloadQueue.addOperation(operation)
            }
        }
    }

    public func slowDownImageDownLoadTask(url: URL?){
        guard let imageUrl = url else{
            return
        }

        if let operation = imageDownloadQueue.operations.filter({ (obj) -> Bool in
            if let imageTask = obj as? GOJImageDownloadOperation{
                return imageTask.imageUrl == imageUrl && imageTask.state == .executing
            }
            return false
        }).first{
            operation.queuePriority = .low
        }
    }
}

