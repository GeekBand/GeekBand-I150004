//
//  GWCameraViewController.swift
//  Baby Film
//
//  Created by Will Ge on 8/12/15.
//  Copyright (c) 2015 gewill.org. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation

class GWCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var tempVideo: NSURL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBOutlet weak var imageView: UIImageView!

    //MARK: - take Photo method
    @IBAction func takePhoto(sender: AnyObject) {
        
        //TODO: review camera permission
        
        
        // setup UIImagePickerController
        var picker = UIImagePickerController()
        
        
        // set sourceType to camera
        let mySourceType = UIImagePickerControllerSourceType.Camera
        
        if (UIImagePickerController.isSourceTypeAvailable(mySourceType)) {
            
            picker.sourceType = mySourceType
            
            let frontCamera = UIImagePickerControllerCameraDevice.Front
            let rearCamera = UIImagePickerControllerCameraDevice.Rear
            
            // perfer rear camera
            if (UIImagePickerController.isCameraDeviceAvailable(rearCamera)) {
                picker.cameraDevice = rearCamera
            } else {
                
                let alert = UIAlertView.init(title:"", message: "You don't have a near camera.", delegate: self, cancelButtonTitle: "Get it")
                alert.show()
            }
            
            // set mediaTypes to Video
            let myMediaTypes = [kUTTypeMovie!]
            if ((UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)) != nil) {
                
                picker.mediaTypes = myMediaTypes
            }
            
            // set videoQuality and videoMaximumDuration
            picker.videoQuality = UIImagePickerControllerQualityType.TypeHigh
            picker.videoMaximumDuration = 1
            
            // set delegate
            picker.delegate = self
            
            
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
    }
    
    
      //MARK: - load Photo Library method
//    @IBAction func loadFromLibrary(sender: AnyObject) {
//        
//        var picker = UIImagePickerController()
//        picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
//        picker.delegate = self
//        self.presentViewController(picker, animated: true, completion: nil)
//    }
//    

    // MARK: - UIImagePickerControllerDelegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        print("Finish Camera")
//        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        self.imageView.image = image
//        picker.dismissViewControllerAnimated(true, completion: nil)
        
        // save video to photo library
        let tempImage = info[UIImagePickerControllerMediaURL] as! NSURL!
        tempVideo = tempImage
        let pathString = tempImage.relativePath
        UISaveVideoAtPathToSavedPhotosAlbum(pathString, self, nil, nil)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        print("Canceled Camera")
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: - play video by AVPlayerViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAVPlayerSegue" {
            if ((tempVideo) != nil) {
            let videoViewController = segue.destinationViewController as! AVPlayerViewController
            videoViewController.player = AVPlayer(URL: tempVideo)
            }
        }
    }
    



}
