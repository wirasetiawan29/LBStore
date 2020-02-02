//
//  CustomImageFlowLayout.swift
//  LBStore
//
//  Created by wira on 2/2/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

import UIKit

class CustomImageFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }

    override var itemSize: CGSize {
        set {}
        get {
            let numberOfColumns = Constants.NumberOfColumns
            let itemWidth = ((CGFloat(self.collectionView!.bounds.width)) / CGFloat(numberOfColumns))
            let itWidth = itemWidth - CGFloat((Constants.marginAround * (numberOfColumns + 1))/numberOfColumns)
            return CGSize(width: itWidth, height: CGFloat(Constants.cellHeight))
        }
    }
    private func setupLayout() {
        let margin:CGFloat = CGFloat(Float(Constants.marginAround))
        minimumInteritemSpacing = margin
        minimumLineSpacing = margin
        scrollDirection = .vertical
        sectionInset.top = margin
        sectionInset.left = margin
        sectionInset.right = margin
    }

}
