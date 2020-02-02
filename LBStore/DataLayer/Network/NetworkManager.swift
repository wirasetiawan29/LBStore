//
//  NetworkManager.swift
//  LBStore
//
//  Created by wira on 2/2/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {


    enum URLError : Error {
        case URLISNIL
        case URLBadScheme
    }

    struct NetworkError : Error {
        var errorCode : String
        var errorType : String
    }

    static var shared = NetworkManager()
    private override init() {
        super.init()

    }

    private lazy var queue : OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 4
        return queue
    }()

    private lazy var session : URLSession = {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: self.queue)
        return  session
    }()

    func getData(url : URL , completionHandler:@escaping(Data? , Error?)->Void) -> URLSessionTask {
        let sessionTask = self.session.dataTask(with: url) { (data, response, error) in
           completionHandler(data,error)
        }
        sessionTask.resume()
        return sessionTask
    }

}
