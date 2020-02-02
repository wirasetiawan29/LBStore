//
//  ProductCollectionViewModel.swift
//  LBStore
//
//  Created by wira on 2/2/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

class ProductCollectionViewModel: BaseViewModel {

    private var currentPage : Int = 0
    private let pageSize : Int = 30
    private var requestUseCase :ProductCollectionRequestUseCase?
    var boolLoading : Bool = false
    var boolMoreDataAvailable : Bool = true
    var productPromo :[ProductPromo]?
    var category :[Category]?

    var numberOfSection = 0

    func getProductInfo(completionHandler : @escaping(Article?)->Void ,useCase : ProductCollectionRequestUseCase = ProductCollectionRequestUseCase() ) {
        boolLoading = true;
        requestUseCase = useCase
        requestUseCase?.initialize(completionHandler: { (responseDTO, error) in
            self.boolLoading = false
            let data = responseDTO?.first
            self.productPromo = data!.data.productPromo
            self.category = data!.data.category
            self.currentPage = self.currentPage + 1
            completionHandler(nil)
        })
    }

}
