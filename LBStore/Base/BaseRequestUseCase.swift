//
//  BaseRequestUseCase.swift
//  LBStore
//
//  Created by wira on 2/2/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

import UIKit

class BaseRequestUseCase {

    func initialize()  {
        fatalError("This is an Abstract Base class, Method should be override")
    }
    func getDataFromServerUsingGet(url : URL, completionHandler:@escaping(Article? , Error?) -> Void) -> URLSessionTask{

        return NetworkManager.shared.getData(url:url) { (data, error) in
            if let error = error  {
                DispatchQueue.main.async {
                    completionHandler(nil , error)
                }
            } else{
                guard let unwrappedData = data else {
                    DispatchQueue.main.async {
                        completionHandler(nil,nil);
                    }
                    return
                }
                do {
                    let response = try JSONDecoder().decode(Article.self, from: unwrappedData)
                    DispatchQueue.main.async {
                        completionHandler(response,nil)
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completionHandler(nil,error)
                    }
                }
            }
        }

    }
}
