//
//  MemeCollectionVC.swift
//  MemeApp
//
//  Created by Franck Ferront on 21/06/2015.
//  Copyright (c) 2015 UXperience. All rights reserved.
//

import UIKit
import Foundation

let reuseIdentifier = "Cell"

class MemeCollectionVC: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var appCollectionView: UICollectionView!
    
    @IBAction func addButton(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! UIViewController
        presentViewController(vc, animated:true, completion:nil)
    }
    

    var memes: [MemeObject]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
        
    }

    override func viewDidAppear(animated: Bool) {
        collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionMemeCell", forIndexPath: indexPath) as! memeCollectionViewCell
        let meme = memes[indexPath.item]
        
        cell.memeImageView.image = meme.memedImage
        cell.memeImageView.sizeToFit()
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("memeDetailVC") as! memeDetailVC
        detailController.meme = memes[indexPath.item]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
}
