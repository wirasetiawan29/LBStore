//
//  ProductCollectionViewCell.swift
//  LBStore
//
//  Created by wira on 2/2/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell , ReuseIdentifier ,NibLoadableView{


    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!

    var sessionTask : URLSessionTask?
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
    }

    func updateInterface(title:String?,price : String? , discount :String?, isStar:Bool){
        titleLabel.text = title
        priceLabel.text = price
        discountLabel.text = discount
        starButton.isHidden = !isStar
    }
}
