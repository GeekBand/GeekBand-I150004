//
//  GWCameraViewController.swift
//  Baby Film
//
//  Created by Will Ge on 8/12/15.
//  Copyright (c) 2015 gewill.org. All rights reserved.
//

import UIKit

class GWCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var imageView: UIImageView!

    //MARK: - takePhoto method
    @IBAction func takePhoto(sender: AnyObject) {
        
        // setup UIImagePickerController
        var picker = UIImagePickerController()
        
        let sourceType = UIImagePickerControllerSourceType.Camera
        
        if (UIImagePickerController.isSourceTypeAvailable(sourceType)) {
            
            picker.sourceType = sourceType
            
            let frontCamera = UIImagePickerControllerCameraDevice.Front
            let rearCamera = UIImagePickerControllerCameraDevice.Rear
            
            // perfer rear camera
            if (UIImagePickerController.isCameraDeviceAvailable(rearCamera)) {
                picker.cameraDevice = rearCamera
            } else {
                picker.cameraDevice = frontCamera
            }
            
            // set delegate
            picker.delegate = self
            
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
    }
    
    
    //MARK: - loadFromLibrary
    @IBAction func loadFromLibrary(sender: AnyObject) {
        
        var picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    

    // MARK: - UIImagePickerControllerDelegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        print("Finish Camera")
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        print("Canceled Camera")
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    


}
