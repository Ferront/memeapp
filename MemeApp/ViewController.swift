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



    var imagePicker = UIImagePickerController()
    var newMedia: Bool?

    @IBOutlet weak var flecheimg: UIImageView! //decoration image
    @IBOutlet weak var TextInstruction: UILabel! // help guidance for user
    @IBOutlet weak var top_text: UITextField! // text entered by user
    @IBOutlet weak var bottom_text: UITextField! // text entered by user
    @IBOutlet var imageView: UIImageView!
    
    
    // open Camera to take picture
    @IBAction func useCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
                newMedia = true
                HideHelp()
            
        }
    }
    
    // Open list of pictures
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
                HideHelp()
                
                
        }
    }
    
    // manage help for user first time
    func HideHelp (){
        TextInstruction.hidden=true
        flecheimg.hidden=true
        top_text.hidden=false
        bottom_text.hidden=false
        imageView.hidden=false
    }
    
    // dismiss text instruction to guide user
    func showHelp(){
        TextInstruction.hidden=false
        flecheimg.hidden=false
        top_text.hidden=true
        bottom_text.hidden=true
        imageView.hidden=true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            imageView.image = image
            
            if (newMedia == true)
            {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
                imageView.hidden=false
                
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
            
            showHelp()
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
        
        showHelp()
        
        
        // text attibutes, negative stroke to be able to fill letters
        let memeTextAttributes =
        [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 50)!,
            NSStrokeWidthAttributeName : -4.0,
            NSStrokeColorAttributeName : UIColor.blackColor()
            // ajouter alignement text
            
        ]
        
        
        top_text.defaultTextAttributes = memeTextAttributes as [NSObject : AnyObject]
        bottom_text.defaultTextAttributes = memeTextAttributes as [NSObject : AnyObject]

        
        top_text.text="Tap to add text here"
        top_text.textAlignment = NSTextAlignment.Center;
        bottom_text.text="Tap to add text here"
        bottom_text.textAlignment = NSTextAlignment.Center;
        
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
        self.view.frame.origin.y = 0
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    

}

