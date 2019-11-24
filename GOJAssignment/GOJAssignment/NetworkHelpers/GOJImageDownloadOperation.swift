//
//  GOJImageDownloadOperation.swift
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//

import UIKit

class GOJImageDownloadOperation : Operation{

    //MARK:- Variables
    let imageUrl : URL!
    var downloadHandler: GOJImageDownloadHandler?
    var completionHandlers: [(handler: GOJImageDownloadHandler, indexPath: IndexPath)] = [(GOJImageDownloadHandler, IndexPath)]()

    var state: GOJOperationState = GOJOperationState.ready{
        willSet{
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }

        didSet{
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    //MARK:- Init Methods
    required init (url: URL) {
        imageUrl = url
    }

    //MARK:- Overriden Methods
    override var isReady: Bool{
        return super.isReady && state == .ready
    }

    override var isExecuting: Bool{
        return state == .executing
    }

    override var isFinished: Bool{
        return state == .finished
    }

    override var isAsynchronous: Bool{
        return true
    }

    override func cancel() {
        super.cancel()
        state = .finished
    }

    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }

    override func main() {
        downloadImageFromUrl()
    }

    //MARK:- Public Methods
    public func downloadImageFromUrl() {
        let newSession = URLSession.shared
        let downloadTask = newSession.downloadTask(with: imageUrl) { [weak self](location, response, error) in
            
            guard let weakSelf = self else{
                return
            }
            
            var image: UIImage?
            if let locationUrl = location, let data = try? Data(contentsOf: locationUrl){
                image = UIImage(data: data)
            }
            weakSelf.downloadHandler?(image, weakSelf.imageUrl, nil, error)
            weakSelf.state = .finished
        }
        downloadTask.resume()
    }
}

