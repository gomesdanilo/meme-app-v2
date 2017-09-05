//
//  MainViewController.swift
//  meme-app-v1
//
//  Created by Danilo Gomes on 04/09/2017.
//  Copyright © 2017 Danilo Gomes. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var exportButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var canvas: UIView!
    var mediaController = MediaController()
    var sharingController = SharingController()
    
    // Data Section
    var memedImage : UIImage?
    var memeToEdit : Meme?
    var dataLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyFontStyles()
        mediaController.delegate = self
        cameraButton.isEnabled = mediaController.canOpenCamera()
        galleryButton.isEnabled = mediaController.canOpenGallery()
    }
    
    func applyFontStyles(){
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3,
            NSParagraphStyleAttributeName: paragraphStyle]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }

    @IBAction func didTapOnCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapOnExport(_ sender: Any) {
        
        // Generate a memed image
        memedImage = generateMemedImage()
        
        if let img = memedImage {
            sharingController.shareImage(image: img, viewController: self, button: sender as! UIBarButtonItem, completionHandler: { (success) in
                if success {
                    // Saves model here.
                    self.save()
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    func save() {
        print("Saving meme image to shared data")
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text,
                        originalImage: imageView.image, memedImage: memedImage)
        AppDelegate.sharedInstance().memes.append(meme)
    }
    
    @IBAction func didTapOnCamera(_ sender: Any) {
        mediaController.openCamera(viewController: self)
    }
    
    @IBAction func didTapOnGallery(_ sender: Any) {
        mediaController.openGallery(viewController: self, button: sender as! UIBarButtonItem)
    }
    
    func createMemeCopy(copy : Meme) {
        imageView.image = copy.originalImage
        memedImage = copy.memedImage
        topTextField.text = copy.topText
        bottomTextField.text = copy.bottomText
    }
    
    func createEmptyMeme() {
        imageView.image = nil
        memedImage = nil
        topTextField.text = AppConstants.defaultTopText
        bottomTextField.text = AppConstants.defaultBottomText
    }
    
    func generateMemedImage() -> UIImage {
        
        // Render view to an image, just canvas part. no toolbars.
        UIGraphicsBeginImageContext(self.canvas.frame.size)
        self.canvas.drawHierarchy(in: self.canvas.bounds, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        if(!dataLoaded)
        {
            dataLoaded = true
            
            if memeToEdit != nil {
                // Edit mode
                createMemeCopy(copy: memeToEdit!)
            } else {
                // Add mode
                createEmptyMeme()
            }
            updateShareButtonVisibility()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func updateShareButtonVisibility(){
        exportButton.isEnabled = imageView.image != nil
    }
}

extension EditMemeViewController : MediaControllerDelegate {
    
    func didReadPicture(picture: UIImage) {
        memedImage = nil
        imageView.image = picture
        updateShareButtonVisibility()
    }

}
