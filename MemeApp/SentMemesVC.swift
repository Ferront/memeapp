//
//  SentMemesVC.swift
//  MemeApp
//
//  Created by Franck Ferront on 21/06/2015.
//  Copyright (c) 2015 UXperience. All rights reserved.
//

import Foundation
import UIKit


class SentMemesVC: UITableViewController, UITableViewDataSource {
    
    
    @IBAction func createNewMemes(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! UIViewController
        presentViewController(vc, animated:true, completion:nil)
        
        
    }
    
    var memes: [MemeObject]!
    var appDelegate: AppDelegate!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = appDelegate.memes
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = appDelegate.memes
        
        //add edit button to tableview
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return memes.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Set the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as! UITableViewCell
        let memeCell = memes[indexPath.row]
        
        // Configure the cell...
        cell.imageView?.image = memeCell.memedImage
        cell.textLabel?.text = memeCell.haut
        cell.detailTextLabel?.text = memeCell.bas
        
        return cell
    }

    override func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("memeDetailVC") as! memeDetailVC
        detailController.meme = self.memes[indexPath.row]
        
        
        navigationController!.pushViewController(detailController, animated: true)
        
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            //delete items from the model
            memes.removeAtIndex(indexPath.row)
            appDelegate.memes.removeAtIndex(indexPath.row)
            
            //remove the item from the tableview
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            
        default:
            return
        }
        
        //reload data to reflect changes
        tableView.reloadData()
        
    }

    
}