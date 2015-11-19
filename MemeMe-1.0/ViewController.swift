//
//  ViewController.swift
//  MemeMe-1.0
//
//  Created by Chris Garvey on 11/17/15.
//  Copyright © 2015 Chris Garvey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable camera if device does not have a camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }

    // Hide the status bar during app use
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // Pick an image from Album
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Pick an image from Camera
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate method that sends the selected image to the image view
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            if let image = info[UIImagePickerControllerOriginalImage]as? UIImage {
                self.imagePickerView.image = image
            }
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
    }
    
}

