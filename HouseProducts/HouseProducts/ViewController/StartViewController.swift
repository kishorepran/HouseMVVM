//
//  StartViewController.swift
//  HouseProducts
//
//  Created by Pran Kishore on 25/07/18.
//  Copyright © 2018 Sample Projects. All rights reserved.
//

import UIKit

//Start screen. The user enters the product select screen
class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClickStart(_ sender : UIButton) {
        performSegue(withIdentifier: "Start-Select", sender: self)
    }
}

