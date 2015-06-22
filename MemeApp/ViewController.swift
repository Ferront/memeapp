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
    @IBOutlet weak var topbar: UIToolbar!
    @IBOutlet weak var bottombar: UIToolbar!
    @IBOutlet weak var sharebutton: UIBarButtonItem!
    @IBOutlet weak var camera: UIBarButtonItem!
    
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
        sharebutton.enabled=true
    }
    
    // dismiss text instruction to guide user
    func showHelp(){
        TextInstruction.hidden=false
        flecheimg.hidden=false
        top_text.hidden=true
        bottom_text.hidden=true
        imageView.hidden=true
        sharebutton.enabled=false

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
        imageView.image = image
            
        if (newMedia == true)
        {
            UIImageWriteToSavedPhotosAlbum(image, self,"image:didFinishSavingWithError:contextInfo:", nil)
            imageView.hidden=false
        }
        
    }
    
    // error message if image impossible to save
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
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //check camera is available
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            camera.enabled=true
        } else {
            camera.enabled=false
        }
        
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
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        top_text.resignFirstResponder()
        bottom_text.resignFirstResponder()
        
        return true
    }
    
    // manage keyboard overlapping to enter text in textfield
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottom_text.isFirstResponder()
        {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Store a Meme
    func saveMeme(){
        var meme = MemeObject(haut: top_text.text!, bas: bottom_text.text!, image: imageView.image!, memedImage: generatedMemedImage())
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
            
        appDelegate.memes.append(meme)
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Generate a Meme
    func generatedMemedImage() -> UIImage {
        // hide the toolbars
        topbar.hidden = true
        bottombar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //after the meme is generated show toolbars
        topbar.hidden = false
        bottombar.hidden = false
        
        return memedImage
    }
    
    
    @IBAction func shareit(sender: AnyObject) {
        
        var instantImage = generatedMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [instantImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.saveMeme()
                
            }
        }
        
        self.presentViewController(activityViewController, animated: true, completion: nil)

        
    }
    

}

