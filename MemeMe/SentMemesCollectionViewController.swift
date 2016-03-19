//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Chris Garvey on 12/11/15.
//  Copyright © 2015 Chris Garvey. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemesCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
        tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / space
                
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space + 1
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SentMemesCollectionViewCell
        cell.sentMemesImageView?.image = memes[indexPath.row].memedImage
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.memeIndex = indexPath.row
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newMemeSegue" {
            let controller = segue.destinationViewController as! MemeEditorViewController
            // Set the newMeme property to true so the Meme Editor knows this is a new meme
            controller.newMeme = true
        }
    }

}
