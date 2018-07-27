//
//  HPError.swift
//  HouseProducts
//
//  Created by Pran Kishore on 25/07/18.
//  Copyright © 2018 Sample Projects. All rights reserved.
//

import Foundation
/// This protocol defines the requirements for a single error case. Custom error classes should

/// use an enum to have multiple error cases in one class. That enum must then implement this

/// protocol.

public protocol HPErrorCode {
    
    /// the error code (readonly)
    
    var code: Int {get}
    
    /// the error domain (readonly)
    var domain: String {get}
    
    /// The error's localized description. Note that this is the fully resolved string, not just the key
    
    /// This is because resolving the string down in HPError would not work, when the error strings are
    
    /// defined the strings files of their own module/product. (readonly)
    
    var localizedMessage: String {get}
    
    /// The error's localized title (optional, readonly)
    var localizedTitle: String? {get}
    
}

/// Represents a custom app-generated error. This class is an abstract NSError wrapper. Concrete errors should be

/// Implemented as subclasses of this class. The various error cases can be added through an enum that implements

open class HPError: NSError {
    
    /// The error code is an object that must implement HPErrorCode
    /// Should be an enum but can be anything else as well!
    public var errorCode: HPErrorCode
    
    
    
    open var localizedMessage: String {
        return errorCode.localizedMessage
    }
    
    open var localizedTitle: String? {
        return errorCode.localizedTitle
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    /// Creates an error instance using the given HPErrorCode.
    
    public init(errorCode: HPErrorCode) {
        self.errorCode = errorCode
        super.init(domain: errorCode.domain, code: errorCode.code, userInfo: nil)
        
    }
    
}

/// Error class in case of networking  errors. Like no internet request time out etc.
class MGServiceError: HPError {
    
    enum ErrorCode: Int, HPErrorCode {
        
        case unknownError
        case connectionError
        case requestTimeOut
        case noNetwork
        
        var code: Int {
            return rawValue
        }
        var domain: String {
            return "WebService"
        }
        
        var localizedMessage: String {
            switch self {
            case .unknownError:
                return "Unknown error. Please try again later."
            case .connectionError:
                return "Could not connect to server. Please try again later."
            case .noNetwork:
                return "Not connected to internet. Please check your connection"
            case .requestTimeOut:
                return "Request Timed out"
            }
            
        }
        var localizedTitle: String? {
            return "House Product"
        }
        
    }
    
    static func customError(for error: NSError) -> ErrorCode {
        switch error.code {
        case -1009:
            return .noNetwork
        case -1001:
            return .requestTimeOut
        case -1008...(-1002):
            return .connectionError
        default:
            return .unknownError
        }
    }
    
    public convenience init(error: NSError) {
        let item = MGServiceError.customError(for: error)
        self.init(errorCode: item)
    }
}

/// Error class in case of error in server responses. E.G.: Blank JSON with 200 or error message embedded in server response.
class MGServerResponseError: HPError {
    
    static let JsonParsing = MGServerResponseError.init(errorCode: ErrorCode.jsonParsingError)
    static let UnExpectedData = MGServerResponseError.init(errorCode: ErrorCode.jsonParsingError)
    static let Unknown = MGServerResponseError.init(errorCode: ErrorCode.unknownError)
    
    enum ErrorCode: HPErrorCode {
        
        case jsonParsingError
        case unExpectedData
        case serverErrorMessage(String)
        case unknownError
        
        var code: Int {
            return 10
        }
        var domain: String {
            return "ServerResponse"
        }
        
        var localizedMessage: String {
            switch self {
            case .serverErrorMessage(let message):
                return message
            case .unExpectedData:
                return "Unexpected / No Data"
            default:
                return "Internal error. Please try again later."
            }
            
        }
        var localizedTitle: String? {
            return "House Product"
        }
        
    }
    
    public convenience init(error: String) {
        let item = ErrorCode.serverErrorMessage(error)
        self.init(errorCode: item)
    }
}
