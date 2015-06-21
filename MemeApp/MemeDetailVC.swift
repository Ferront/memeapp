//
//  MemeDetailVC.swift
//  MemeApp
//
//  Created by Franck Ferront on 21/06/2015.
//  Copyright (c) 2015 UXperience. All rights reserved.
//

import Foundation
import UIKit

class memeDetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: MemeObject!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView!.image = meme.memedImage
        tabBarController?.tabBar.hidden = true
        navigationController?.hidesBarsOnTap = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
    }
    
    
}
