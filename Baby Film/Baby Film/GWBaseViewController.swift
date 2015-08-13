//
//  GWBaseViewController.swift
//  Baby Film
//
//  Created by Will Ge on 8/12/15.
//  Copyright (c) 2015 gewill.org. All rights reserved.
//

import UIKit

class GWBaseViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - set setToolbar show in this View Controller, but hidded in other will appear View Controller
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(true, animated: animated)
        
    }
    
     override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }


}
