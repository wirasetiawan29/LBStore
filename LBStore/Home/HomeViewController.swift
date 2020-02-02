//
//  HomeViewController.swift
//  LBStore
//
//  Created by wira on 2/2/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

import UIKit
import GoogleSignIn

protocol ProductDetailRouter {
    func routeToProductDetailController(selectedProduct:ProductPromo)
}

class HomeViewController: BaseViewController {

    @IBOutlet weak var logoutButton: UIButton!
    var viewModel: ProductCollectionViewModel?
    @IBOutlet weak var collectionView: UICollectionView!
    private var refreshControl:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpUI()
    }

    func setUpData() {
        viewModel = ProductCollectionViewModel()
        initializeCollectionView()
        fetchData()
        initRefreshControl()
    }

    func setUpUI() {

    }

    func deleteUser() {
         let userDefaults = UserDefaults.standard
         userDefaults.removeObject(forKey: "username")
         userDefaults.synchronize()
     }


    @IBAction func onClickLogoutButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        deleteUser()
        let loginViewController = LoginViewController()
        let navController = UINavigationController(rootViewController: loginViewController)
        navController.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = navController
    }

    private func initializeCollectionView() {
        let collectionViewLayout = CustomImageFlowLayout()
        self.collectionView.collectionViewLayout = collectionViewLayout
        self.collectionView.register(cell: ProductCollectionViewCell.self)
    }

    @objc func fetchData(){
        viewModel?.getProductInfo(completionHandler: { (message) in
            if message != nil{
                self.refreshControl.endRefreshing()
            }else {
                self.collectionView.reloadData()
                self.collectionView.backgroundColor = Constants.appBackgroundColor
                self.refreshControl.endRefreshing()
            }
        })
    }
    private func initRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(fetchData), for: UIControl.Event.valueChanged)
        collectionView!.addSubview(refreshControl)
    }
    
    @IBAction func onClickCartButton(_ sender: Any) {
        let viewController = CartViewController()
             self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    
}

extension HomeViewController : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let count = viewModel?.productPromo?.count {
            if indexPath.row == count - 1 && viewModel?.boolLoading == false && viewModel?.boolMoreDataAvailable == true {
                self.viewModel?.getProductInfo(completionHandler: { (message) in
                    if message != nil {
                        // Show Alert
                    }else {
                        self.collectionView.reloadData()
                    }
                })
            }
        }
    }
}

extension HomeViewController : UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.productPromo?.count) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell : ProductCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        let product = viewModel?.productPromo?[indexPath.item]

        cell.updateInterface(title: product?.title, price: product?.productPromoDescription, discount: product?.price,  isStar: product!.loved.boolValue)
        let imageURL = (product?.imageURL ?? "")
        cell.sessionTask?.cancel()
        cell.sessionTask = cell.myImageView.downloadImage(from: imageURL, placeholderImageName: "placeholder")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedProduct = viewModel?.productPromo?[indexPath.item]
        {
            self.routeToProductDetailController(selectedProduct: selectedProduct)

        }
    }


    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CartHeaderCollectionReusableView", for: indexPath)
            // Customize headerView here
            return headerView
        }
        fatalError()
    }


}

extension  HomeViewController : ProductDetailRouter {
    func routeToProductDetailController(selectedProduct: ProductPromo) {
        let productDetailViewModel = ProductDetailViewModel()
        productDetailViewModel.productSelected = selectedProduct
        let controller:ProductDetailViewController? = ProductDetailViewController()
        controller?.viewModel = productDetailViewModel
        self.navigationController?.pushViewController(controller!, animated: true)
    }
}

extension Int {
    var boolValue: Bool { return self != 0 }
}
