//
//  ProductCollectionRequestUseCase.swift
//  LBStore
//
//  Created by wira on 2/2/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

import UIKit




class ProductCollectionRequestUseCase: BaseRequestUseCase {

     var sessionTask : URLSessionTask?

    func initialize(completionHandler:@escaping(Article?,Error?)->Void) {
        let baseUrl = Constants.homePageUrl
        let url = URL(string: baseUrl)
        sessionTask?.cancel()
        sessionTask = super.getDataFromServerUsingGet(url: url!, completionHandler: completionHandler)
    }
}
