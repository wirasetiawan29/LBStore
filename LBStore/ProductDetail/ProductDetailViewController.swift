//
//  ProductDetailViewController.swift
//  LBStore
//
//  Created by wira on 2/2/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

import UIKit

class ProductDetailViewController: BaseViewController {

    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var viewModel: ProductDetailViewModel?
    @IBOutlet weak var imageCollectionView: UICollectionView!

    lazy var flowLayout: UICollectionViewFlowLayout =  {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: self.imageCollectionView.bounds.size.width, height: self.imageCollectionView.bounds.size.height)
        _flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        _flowLayout.minimumLineSpacing = 0
        return _flowLayout
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCollectionView()
        inializeScreenWithData()
    }

    private func inializeScreenWithData(){
        titleLabel.text = viewModel?.productSelected?.title
        if let price = viewModel?.productSelected?.price {
            priceLabel.text = price
        } else {
            priceLabel.text = nil
        }
    }

    private func initializeCollectionView(){
        imageCollectionView.collectionViewLayout = flowLayout
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.register(cell: ProductImageCollectionViewCell.self)
    }

    //MARK: action function
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addtoCartButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickCartButton(_ sender: Any) {
        let viewController = CartViewController()
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }

}

extension ProductDetailViewController : UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ProductImageCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let imageURL = (viewModel?.productSelected?.imageURL ?? "")
        cell.sessionTask?.cancel()
        cell.sessionTask = cell.productImageView.downloadImage(from: imageURL, placeholderImageName: "")
        return cell
    }

}

