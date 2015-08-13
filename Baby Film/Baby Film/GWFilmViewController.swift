//
//  GWFilmViewController.swift
//  Grow Up Everyday
//
//  Created by Will Ge on 8/12/15.
//  Copyright (c) 2015 gewill.org. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class GWFilmViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - play testVideo by AVPlayerViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAVPlayerSegue" {
            let videoURL = NSBundle.mainBundle().URLForResource("TestVideo",
                withExtension: "m4v")
            let videoViewController = segue.destinationViewController as! AVPlayerViewController
            videoViewController.player = AVPlayer(URL: videoURL)
        }
    }

}
