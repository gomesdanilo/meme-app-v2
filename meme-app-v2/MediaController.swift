//
//  MediaController.swift
//  meme-app-v1
//
//  Created by Danilo Gomes on 04/09/2017.
//  Copyright © 2017 Danilo Gomes. All rights reserved.
//

import UIKit

protocol MediaControllerDelegate {
    func didReadPicture(picture : UIImage)
}

class MediaController: NSObject {
    var delegate : MediaControllerDelegate?
    
    func canOpenCamera() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func canOpenGallery() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    func presentImagePickerWith(viewController: UIViewController,
                                sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func openCamera(viewController: UIViewController){
        presentImagePickerWith(viewController: viewController, sourceType: .camera)
    }
    
    func openGallery(viewController: UIViewController, button : UIBarButtonItem){
        presentImagePickerWith(viewController: viewController, sourceType: .photoLibrary)
    }
}

extension MediaController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let del = self.delegate, let img = image {
            del.didReadPicture(picture: img)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

}
