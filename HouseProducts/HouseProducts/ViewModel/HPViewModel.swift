//
//  HPViewModel.swift
//  HouseProducts
//
//  Created by Pran Kishore on 25/07/18.
//  Copyright © 2018 Sample Projects. All rights reserved.
//

import UIKit

protocol ViewModelDelegate : class {
    func viewModelDidUpdate(sender : HPViewModel)
    func viewModelUpdateFailed(error : HPError)
}

class HPViewModel: NSObject {
    
    weak var delegate : ViewModelDelegate?
    let dataManager = ProductListDataManager()
    
    var products : [Product]?  {
        didSet {
            delegate?.viewModelDidUpdate(sender: self)
        }
    }
    
    //List of total items
    var totalItems : Int {
        return products?.count ?? 0
    }
    
    //Count for total liked items
    var totalLikedItems : Int {
        guard let  items = products else {return 0}
        let likedItems = items.filter { (item) -> Bool in
            return item.choice == .liked
        }
        return likedItems.count
    }
    
    //Check if user reviwed all items
    var isAllItemsReviewed : Bool {
        guard let  items = products else {return false}
        let item = items.first { (element) -> Bool in
            element.choice == .undetermined
        }
        return item == nil
    }
    
    //Web service call
    func getProductsList() {
        
        dataManager.productList(success: { (data) in
            let decoder = JSONDecoder()
            do {
                let item = try decoder.decode(Response<Product>.self, from: data)
                if let element = item.data?.articles {
                    self.products = element
                } else  {
                    self.delegate?.viewModelUpdateFailed(error: MGServerResponseError.UnExpectedData)
                }
            } catch {
                self.delegate?.viewModelUpdateFailed(error: MGServerResponseError.JsonParsing)
                print(error)
            }
        }) { (error) in
            self.delegate?.viewModelUpdateFailed(error: error)
            print(error)
        }
    }
}

