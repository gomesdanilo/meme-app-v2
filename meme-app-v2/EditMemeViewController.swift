//
//  MainViewController.swift
//  meme-app-v1
//
//  Created by Danilo Gomes on 04/09/2017.
//  Copyright © 2017 Danilo Gomes. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController {

    var memes : [Meme]?
    
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
    
    var currentMeme = Meme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyFontStyles()
        mediaController.delegate = self
        cameraButton.isEnabled = mediaController.canOpenCamera()
        galleryButton.isEnabled = mediaController.canOpenGallery()
        
        resetModel()
        updateScreenFromModel()
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
        //resetModel()
        //updateScreenFromModel()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func updateModelWithTextFields(){
        currentMeme.topText = topTextField.text
        currentMeme.bottomText = bottomTextField.text
    }
    
    @IBAction func didTapOnExport(_ sender: Any) {
        
        updateModelWithTextFields()
        
        // Generate a memed image
        currentMeme.memedImage = generateMemedImage()
        
        if let img = currentMeme.memedImage {
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
        print("Saving meme image")
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: currentMeme.memedImage!)
        AppDelegate.sharedInstance().memes.append(meme)
    }
    
    @IBAction func didTapOnCamera(_ sender: Any) {
        mediaController.openCamera(viewController: self)
    }
    
    @IBAction func didTapOnGallery(_ sender: Any) {
        mediaController.openGallery(viewController: self, button: sender as! UIBarButtonItem)
    }
    
    func resetModel() {
        currentMeme.originalImage = nil
        currentMeme.memedImage = nil
        currentMeme.topText = AppConstants.defaultTopText
        currentMeme.bottomText = AppConstants.defaultBottomText
    }
    
    func updateScreenFromModel(){
        imageView.image = currentMeme.originalImage
        topTextField.text = currentMeme.topText
        bottomTextField.text = currentMeme.bottomText
        
        exportButton.isEnabled = currentMeme.originalImage != nil
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
}

extension EditMemeViewController : MediaControllerDelegate {
    
    func didReadPicture(picture: UIImage) {
        currentMeme.originalImage = picture
        currentMeme.memedImage = nil
        updateScreenFromModel()
    }

}
