//
//  ProductSelectViewController.swift
//  HouseProducts
//
//  Created by Pran Kishore on 25/07/18.
//  Copyright © 2018 Sample Projects. All rights reserved.
//

import UIKit
import JGProgressHUD
import Kingfisher
// User records his like or dislike for the given product
class ProductSelectViewController: UIViewController {
    
    let hud = JGProgressHUD(style: .dark)
    let viewModel = HPViewModel()
    
    @IBOutlet weak var labelLikeCount: UILabel!
    @IBOutlet weak var buttonReview: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var currentIndex : IndexPath {
        return collectionView.indexPathsForVisibleItems.first ?? IndexPath.init(row: 0, section: 0)
    }
    
    var nextIndex : IndexPath {
        let totalItems = viewModel.products?.count ?? 1
        let row = min(currentIndex.row+1, totalItems-1)
        return IndexPath.init(row: row , section: currentIndex.section)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.delegate = self
        viewModel.getProductsList()
        //Progress
        hud.show(in: self.view, animated: true)
        updateLikeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClickReview(_ sender : UIButton) {
        performSegue(withIdentifier: "Select-Review", sender: self)
    }
    
    @IBAction func buttonClickLike(_ sender : UIButton) {
        collectionView.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: true)
        if let product = viewModel.products?[currentIndex.row] {
            product.choice = .liked
            updateLikeUI()
        }
    }
    
    @IBAction func buttonClickDislike(_ sender : UIButton) {
        collectionView.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: true)
        if let product = viewModel.products?[currentIndex.row] {
            product.choice = .unliked
            updateLikeUI()
        }
    }
    
    func updateLikeUI() {
        labelLikeCount.text = "Items Liked \(viewModel.totalLikedItems) / \(viewModel.totalItems)"
        buttonReview.isEnabled = viewModel.isAllItemsReviewed
        if viewModel.isAllItemsReviewed {
            showErrorAlert("All Items are selected.\nChoices can be reviewed now.")
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationVC = segue.destination as? ProductReviewViewController {
            destinationVC.viewModel = viewModel
        }
    }
    
}

extension ProductSelectViewController: UICollectionViewDelegate {
    
}

extension ProductSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
}

extension ProductSelectViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        
        let image = UIImage(named: "Placeholder")
        let item = viewModel.products?[indexPath.row]
        cell.mainImageView.kf.setImage(with: item?.imageMedia?.url, placeholder: image)
        
        return cell
    }
}


extension ProductSelectViewController : ViewModelDelegate {
    
    func viewModelDidUpdate(sender : HPViewModel) {
        //Progress
        hud.dismiss()
        collectionView.reloadData()
    }
    
    func viewModelUpdateFailed(error: HPError) {
        //Progress
        hud.dismiss()
        showAlert(for: error)
    }
}
