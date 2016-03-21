//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Chris Garvey on 12/11/15.
//  Copyright © 2015 Chris Garvey. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    
    var memeIndex: Int!
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Hide the tab bar */
        tabBarController?.tabBar.hidden = true
        
        /* Add an "Edit" bar button to the navigation bar */
        /* Citation: https://www.hackingwithswift.com/example-code/uikit/how-to-add-a-bar-button-to-a-navigation-bar */
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editMeme")
        
        imageView!.image = memes[memeIndex].memedImage
    }
    
    
    // MARK: - Edit Meme Method
    
    func editMeme() {
        var controller: MemeEditorViewController
        controller = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        /* Set the location of the meme that will be edited */
        controller.memeIndex = memeIndex
        
        /* Set the property alerting the Meme Editor that this is not a new meme */
        controller.newMeme = false
        
        /* Present the Meme Editor */
        presentViewController(controller, animated: true, completion: nil)
    }
}
