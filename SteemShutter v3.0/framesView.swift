//
//  framesView.swift
//  SteemShutter v3.0
//
//  Created by Mario Kardum on 19/07/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit

class framesView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // Two UIImageViews to receive data from previous ViewController
    
    @IBOutlet weak var whiteBackground: UIImageView!
    @IBOutlet weak var pickedFrame: UIImageView!
    
    
    // Back and save buttons
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    // An image view that shows the image that was picked from photo library
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    // Buttons for placing the picked image inside a field in the frame
    
    @IBOutlet weak var frame1: UIButton!
    @IBOutlet weak var frame2: UIButton!
    @IBOutlet weak var frame3: UIButton!
    @IBOutlet weak var frame4: UIButton!
    @IBOutlet weak var frame5: UIButton!
    
    
    // Warning message outlets
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    
    
    // Image view for the final frame with photos inside
    
    @IBOutlet weak var finalFramedImage: UIImageView!
    
    
    // sizes A, B, C, D and E are changable depending of the chosen frame. Same with the points A, B, C, D and E.
    // They mark where on background image will the photo be placed. It is the upper-left corner point of the each photo
    var sizeA: CGSize?
    var sizeB: CGSize?
    var sizeC: CGSize?
    var sizeD: CGSize?
    var sizeE: CGSize?
    
    var pointA: CGPoint?
    var pointB: CGPoint?
    var pointC: CGPoint?
    var pointD: CGPoint?
    var pointE: CGPoint?
    
    //frameImage is the frame designed by utopian-io contributors.
    //backgroundImage is blue or white (blank) image that has the same size as the frameImage.
    // The picked photo draws itself on the backgroundImage and the frameImage comes over it
    // Those variable come from chooseTheFrame view controller
    var frameImage: UIImage?
    var backgroundImage: UIImage?
    
    
    var basicPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Placing the data from framesOne view controller into outlets
        
        pickedFrame.image = frameImage
        whiteBackground.image = backgroundImage

        // Let's round some corners
        messageView.layer.cornerRadius = 12
        messageButton.layer.cornerRadius = 18
        
        // This is for two-photo frame
        
        if sizeC == CGSize(width: 0, height: 0) {
            frame3.isHidden = true
            frame4.isHidden = true
            frame5.isHidden = true
        }
        
        // for three-photo frame
        if sizeC != CGSize(width: 0, height: 0),
            sizeD == CGSize(width: 0, height: 0) {
            frame4.isHidden = true
            frame5.isHidden = true
        }
        
        // for four-photo frame
        if sizeD != CGSize(width: 0, height: 0),
            sizeE == CGSize(width: 0, height: 0) {
            frame5.isHidden = true
        }
        
        // You know what the save button does
        saveButton.isHidden = false

        
        

    }
    
    // Functions for the image picker
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        pickedImage.image = selectedImage
        dismiss(animated: true, completion: nil)
        
        // ResizeImage func depends on var size (A,B, C, D or E)
    }
    func resizeImage(image: UIImage, targetSize: CGSize ) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // combineTwo func depends on var point (A,B, C, D or E )
    
    func combineTwo (bcgimage image1: UIImage, wtmimage image2: UIImage, thepoint point: CGPoint) -> UIImage {
        UIGraphicsBeginImageContext(image1.size);
        
        
        image1.draw(in: CGRect(x: 0, y: 0, width: image1.size.width, height: image1.size.height))
        
        
        image2.draw(at: point)
        let newImage2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage2!
    }
    
    @IBAction func pickAnImageAction(_ sender: Any) {
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true, completion: nil)
        
    }
    
    
    @IBAction func frame1Action(_ sender: Any) {
        
        // This is to prevent crushing
        // Instead of printing error, I added this warning message.
        // A user should firts pick a photo then pick a frame
        // The same is for the next four buttons
        
        
        if pickedImage.image == nil {
            messageView.isHidden = false
            messageLabel.isHidden = false
            messageButton.isHidden = false
        } else {
            
            //First let's call the resizeImge function to resize the picked photo to fit the frame
            // Same is for the next four buttons
            self.pickedImage.image = resizeImage(image: pickedImage.image!, targetSize: sizeA!)
            
            // Let's draw the resized photo onto white background
            self.whiteBackground.image = combineTwo(bcgimage: whiteBackground.image!, wtmimage: pickedImage.image!, thepoint: pointA!)
            
            
            // Let's draw the frame image onto the white backround with the photos drawn on it
            self.finalFramedImage.image = combineTwo(bcgimage: whiteBackground.image!, wtmimage: pickedFrame.image!, thepoint: basicPoint)
            
            
            // Now, let's hide those "helpful images"
            whiteBackground.isHidden = true
            pickedFrame.isHidden = true
        }
        
        
        
    }
    
    @IBAction func frame2Action(_ sender: Any) {
        
        if pickedImage.image == nil {
            messageView.isHidden = false
            messageLabel.isHidden = false
            messageButton.isHidden = false
        } else {
            self.pickedImage.image = resizeImage(image: pickedImage.image!, targetSize: sizeB!)
            self.whiteBackground.image = combineTwo(bcgimage: whiteBackground.image!, wtmimage: pickedImage.image!, thepoint: pointB!)
            self.finalFramedImage.image = combineTwo(bcgimage: whiteBackground.image!, wtmimage: pickedFrame.image!, thepoint: basicPoint)
            whiteBackground.isHidden = true
            pickedFrame.isHidden = true
        }
        
        
    }
    
    @IBAction func frame3Action(_ sender: Any) {
        if pickedImage.image == nil {
            messageView.isHidden = false
            messageLabel.isHidden = false
            messageButton.isHidden = false
        } else {
            self.pickedImage.image = resizeImage(image: pickedImage.image!, targetSize: sizeC!)
            self.whiteBackground.image = combineTwo(bcgimage: whiteBackground.image!, wtmimage: pickedImage.image!, thepoint: pointC!)
            self.finalFramedImage.image = combineTwo(bcgimage: whiteBackground.image!, wtmimage: pickedFrame.image!, thepoint: basicPoint)
            whiteBackground.isHidden = true
            pickedFrame.isHidden = true
        }
    }
    
    @IBAction func frame4Action(_ sender: Any) {
        if pickedImage.image == nil {
            messageView.isHidden = false
            messageLabel.isHidden = false
            messageButton.isHidden = false
        } else {
            self.pickedImage.image = resizeImage(image: pickedImage.image!, targetSize: sizeD!)
            self.whiteBackground.image = combineTwo(bcgimage: whiteBackground.image!, wtmimage: pickedImage.image!, thepoint: pointD!)
            self.finalFramedImage.image = combineTwo(bcgimage: whiteBackground.image!, wtmimage: pickedFrame.image!, thepoint: basicPoint)
            whiteBackground.isHidden = true
            pickedFrame.isHidden = true
        }
    }
    
    @IBAction func frame5Action(_ sender: Any) {
        if pickedImage.image == nil {
            messageView.isHidden = false
            messageLabel.isHidden = false
            messageButton.isHidden = false
        } else {
            self.pickedImage.image = resizeImage(image: pickedImage.image!, targetSize: sizeE!)
            self.whiteBackground.image = combineTwo(bcgimage: whiteBackground.image!, wtmimage: pickedImage.image!, thepoint: pointE!)
            self.finalFramedImage.image = combineTwo(bcgimage: whiteBackground.image!, wtmimage: pickedFrame.image!, thepoint: basicPoint)
            whiteBackground.isHidden = true
            pickedFrame.isHidden = true
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let imageToSave = finalFramedImage.image
            else {
                return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
