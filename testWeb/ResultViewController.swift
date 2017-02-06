//
//  ResultViewController.swift
//  testWeb
//
//  Created by T.T on 2017/02/06.
//  Copyright © 2017年 T.T. All rights reserved.
//

//
//  ViewController.swift
//  testWeb
//
//  Created by T.T on 2017/02/04.
//  Copyright © 2017年 T.T. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController{
    
    var recievedText = ""
    
    @IBOutlet weak var uiLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiLabel.numberOfLines = 0
        uiLabel.adjustsFontSizeToFitWidth = true
        uiLabel.text = "honyahonya"
        uiLabel.text = recievedText
        print(recievedText)
        print("transp!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

