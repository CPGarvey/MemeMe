//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Chris Garvey on 12/10/15.
//  Copyright © 2015 Chris Garvey. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
   
    // MARK: - Property
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        /* Citation: https://discussions.udacity.com/t/cant-get-table-view-to-work-doesnt-display-any-cells/34898 */
        tableView.reloadData()
    }
    
    
    // MARK: - Tableview Data Source Protocol Methods - Configuring Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell", forIndexPath: indexPath)
        cell.imageView?.image = memes[indexPath.row].memedImage
        cell.textLabel?.text = memes[indexPath.row].topText + " " + memes[indexPath.row].bottomText
        return cell
    }
    
    
    // MARK: - Tableview Data Source Protocol Methods - Inserting or Deleting Table Rows
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            /* Citation: http://stackoverflow.com/questions/29294099/delete-a-row-in-table-view-in-swift */
            appDelegate.memes.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Tableview Delegate Method - Managing Selections
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.memeIndex = indexPath.row
        navigationController!.pushViewController(detailController, animated: true)
    }

    
    // MARK: - Segue Method
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newMemeSegue" {
            let controller = segue.destinationViewController as! MemeEditorViewController
            /* Set the newMeme property to true so the Meme Editor knows this is a new meme */
            controller.newMeme = true
        }
    }

}
