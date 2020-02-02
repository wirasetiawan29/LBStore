//
//  ProductImageCollectionViewCell.swift
//  LBStore
//
//  Created by wira on 2/2/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

import UIKit

class ProductImageCollectionViewCell: UICollectionViewCell, ReuseIdentifier, NibLoadableView {

    @IBOutlet weak var productImageView: UIImageView!
    var sessionTask : URLSessionTask?

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
    }
}
