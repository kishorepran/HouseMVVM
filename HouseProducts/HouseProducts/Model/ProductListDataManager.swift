//
//  ProductListDataManager.swift
//  HouseProducts
//
//  Created by Pran Kishore on 25/07/18.
//  Copyright © 2018 Sample Projects. All rights reserved.
//

import Foundation

public class ProductListRouter : APIRouter {
    override var path : String {
        return "categories/100/articles"
    }
}

class ProductListDataManager: NSObject {
    public func productList(success:@escaping (Data) -> Void, failure:@escaping (HPError) -> Void) {
        let params = ["appDomain":"1","locale":"de_DE","limit":"10"]
        let router = ProductListRouter.init(params)
        HPService.request(router, success: success, failure: failure)
    }
}
