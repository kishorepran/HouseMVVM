//
//  CommonExtensions.swift
//  HouseProducts
//
//  Created by Pran Kishore on 26/07/18.
//  Copyright © 2018 Sample Projects. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /**
     Show Error alert with a title and message. Does not have any thing in completion. Stays on the view controller that is being called.
     
     - Parameter error: Type of error that could be displayed to user.
     */
    func showAlert(for error:HPError) {
        showErrorAlert(error.localizedTitle, message:error.localizedMessage)
    }
    /**
     Show Error alert with a title and message. Does not have any thing in completion. Stays on the view controller that is being called.
     
     - Parameter title: Title of the alert. Defaults to "Merlin Group"
     - Parameter message: Message to be displayed to user
     */
    func showErrorAlert(_ title:String?, message:String) {
        
        let text : String = title ?? "House Product"
        let alertController = UIAlertController(title: text, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(_ message:String) {
        showErrorAlert(nil, message: message)
    }
}
