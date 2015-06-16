//
//  ViewController.swift
//  MemeApp
//
//  Created by Franck Ferront on 15/06/2015.
//  Copyright (c) 2015 UXperience. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var chooseBuuton: UIButton!
    var imagePicker = UIImagePickerController()
    var newMedia: Bool?

    @IBOutlet weak var top_text: UITextField!
    @IBOutlet weak var bottom_text: UITextField!
    //var contentMode: UIViewContentMode

    //@IBOutlet weak var imagePickerView: UIImageView!
   
//    @IBAction func btnClicked(){
//        
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
//            println("Button capture")
//            
//            
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
//            imagePicker.allowsEditing = false
//            
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
//        
//    }
//    
    
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        self.dismissViewControllerAnimated(true, completion: { () -> Void in
//            
//        })
//        
//        imageView.image = image
//        
//    }
    
    @IBAction func useCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
                newMedia = true
        }
    }
    
    @IBAction func useCameraRoll(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = false
                imageView.hidden=false
                
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if (mediaType.isEqualToString(kUTTypeImage as String))
        {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            imageView.image = image
            
            if (newMedia == true)
            {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
                imageView.hidden=false
                
            }
            else if mediaType.isEqualToString(kUTTypeMovie as! String)
            {
                // Code to support video here
            }
            
        }
    }
    

    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blueColor(),
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSBackgroundColorAttributeName : UIColor.lightGrayColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : 2
        ]
        
        top_text.defaultTextAttributes=memeTextAttributes
        bottom_text.defaultTextAttributes=memeTextAttributes
        
        top_text.text="Tap to add text here"
        top_text.textAlignment=NSTextAlignment.Center;
        bottom_text.text="Tap to add text here"
        bottom_text.textAlignment=NSTextAlignment.Center;
        
        top_text.delegate=self;
        bottom_text.delegate=self;

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    

}

