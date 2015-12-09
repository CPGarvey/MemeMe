//
//  MemeEditorViewController.swift
//  MemeMe-2.0
//
//  Created by Chris Garvey on 11/17/15.
//  Copyright © 2015 Chris Garvey. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // Dictionary of default text attributes for the text fields
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0 // citation: Udacity forum
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetView(topTextField, initialText: "TOP", attributes: memeTextAttributes, alignment: .Center)
        resetView(bottomTextField, initialText: "BOTTOM", attributes: memeTextAttributes, alignment: .Center)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable camera if device does not have a camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // Hide the status bar during app use - citation: http://stackoverflow.com/questions/24236912/how-do-i-hide-the-status-bar-in-a-swift-ios-app
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // UITextFieldDelegate method to clear the text when user first starts editing the text fields
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
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
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate method that sends the selected image to the image view
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            if let image = info[UIImagePickerControllerOriginalImage]as? UIImage {
                imagePickerView.image = image
                shareButton.enabled = true
            }
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Reset image and text if user presses the Cancel button
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        resetView(topTextField, initialText: "TOP", attributes: memeTextAttributes, alignment: .Center)
        resetView(bottomTextField, initialText: "BOTTOM", attributes: memeTextAttributes, alignment: .Center)
    }
    
    // Share the meme through the activity view controller when the share button is pressed
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(nextController, animated: true, completion: nil)
        
        // citation (lines 130-134): Udacity forum
        nextController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // Save the meme
    func save() {
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
    }
    
    // Generate the image for the meme
    func generateMemedImage() -> UIImage {
        
        // Hide toolbars
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbars
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // Shift the view up if user entering text in bottom text field
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() == true {
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Shift the view back down if user finished entering text in bottom text field
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() == true {
        view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Method to reset the text fields when user loads the app or presses cancel (inspired by suggestion from code reviewer)
    func resetView(textField: UITextField, initialText: String, attributes: [String : NSObject], alignment: NSTextAlignment) {
        textField.text = initialText
        textField.delegate = self
        textField.defaultTextAttributes = attributes
        textField.textAlignment = alignment
        
        shareButton.enabled = false
        imagePickerView.image = nil
    }
}
