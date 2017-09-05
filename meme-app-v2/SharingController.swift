//
//  SharingController.swift
//  meme-app-v1
//
//  Created by Danilo Gomes on 04/09/2017.
//  Copyright © 2017 Danilo Gomes. All rights reserved.
//

import UIKit

class SharingController: NSObject {
    
    var activityViewController : UIActivityViewController?
    
    
    func shareImage(image : UIImage,
                    viewController : UIViewController,
                    button : UIBarButtonItem, completionHandler : @escaping (_ success : Bool) -> Void) {
        
        // This code will automatically open fullscreen on iPhone and popover on iPad.
        activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController?.completionWithItemsHandler = {(acitivityType, success, activityItems, error) in
            completionHandler(success)
        }
        
        viewController.present(activityViewController!, animated: true, completion: nil)
        
        // Used on popover mode to show on iPad
        activityViewController!.popoverPresentationController?.permittedArrowDirections = .any
        activityViewController!.popoverPresentationController?.barButtonItem = button
    }
}
