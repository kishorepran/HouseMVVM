//
//  HPService.swift
//  HouseProducts
//
//  Created by Pran Kishore on 25/07/18.
//  Copyright © 2018 Sample Projects. All rights reserved.
//

import Alamofire
import Foundation

struct APIConstants {
    static let baseURL = "https://api-mobile.home24.com/api/v2.0/"
}

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

public class APIRouter : APIConfiguration {
    
    let method : HTTPMethod = .get
    var path : String {
        return "categories/100/articles"
    }
    
    var parameters : Parameters?
    
    init(_ params : Parameters? = nil ) {
        parameters = params
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try APIConstants.baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(60)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

class HPService: NSObject {
    static func request(_ request: URLRequestConvertible, success:@escaping (Data) -> Void, failure:@escaping (HPError) -> Void){
        #if DEBUG
        let sample = try? request.asURLRequest()
        print("Response for \(String(describing: sample?.url))")
        if let test = sample?.httpBody ,let params = String.init(data:test, encoding: .utf8) {
            print("Params \(params)")
        }
        #endif
        //Response data is used as we don't want to parse data twice. i.e. once in Alamofire and one in codable class.
        Alamofire.request(request).responseData { (responseObject) -> Void in
            if let data = responseObject.data , responseObject.result.isSuccess {
                #if DEBUG
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json.debugDescription)
                #endif
                success(data)
            }
            if responseObject.result.isFailure {
                var item : HPError
                if let error = responseObject.result.error as NSError? {
                    //Known error.
                    item = MGServiceError.init(error: error)
                } else {
                    //Other failures
                    item = MGServiceError.init(errorCode: MGServiceError.ErrorCode.unknownError)
                }
                failure(item)
            }
        }
    }
}
