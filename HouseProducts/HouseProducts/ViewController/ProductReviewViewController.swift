//
//  ProductReviewViewController.swift
//  HouseProducts
//
//  Created by Pran Kishore on 25/07/18.
//  Copyright © 2018 Sample Projects. All rights reserved.
//

import UIKit

// User reviews the product he has liked or disliked.
class ProductReviewViewController: UIViewController {
    
    enum ReviewMode : Int {
        case list
        case grid
    }
    
    var viewModel : HPViewModel?
    
    @IBOutlet weak var viewSegment: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedReviewMode = ReviewMode.list {
        didSet {
            tableView.isHidden = selectedReviewMode == .grid
            collectionView.isHidden = selectedReviewMode == .list
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSegment()
        selectedReviewMode = .list
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSegment () {
        viewSegment.backgroundColor = UIColor.init(hexString: "5ac8fa")
        segment.layer.borderColor  = UIColor.white.cgColor
        segment.layer.borderWidth = 1.0
        segment.layer.cornerRadius = 5.0
        segment.selectedSegmentIndex = selectedReviewMode.rawValue
    }

    @IBAction func indexChanged(_ sender: AnyObject) {
        selectedReviewMode = segment.selectedSegmentIndex == 0 ? .list : .grid
    }
    
}

// MARK: - UITableView
extension ProductReviewViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel?.products?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        // Configure the cell...
        let image = UIImage(named: "PurplePlaceholder")
        let item = viewModel?.products?[indexPath.row]
        cell.mainImageView.kf.setImage(with: item?.imageMedia?.url, placeholder: image)
        cell.likeImageView.isHidden = !(item?.choice == .liked)
        cell.titleLabel.text = item?.title ?? "N/A"
        return cell
    }
    
}

// MARK: - UICollectionView
extension ProductReviewViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCollectionViewCell", for: indexPath) as! ReviewCollectionViewCell
        
        let image = UIImage(named: "PurplePlaceholder")
        let item = viewModel?.products?[indexPath.row]
        cell.mainImageView.kf.setImage(with: item?.imageMedia?.url, placeholder: image)
        cell.likeImageView.isHidden = !(item?.choice == .liked)
        return cell
    }
}
