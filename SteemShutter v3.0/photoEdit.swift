//
//  photoEdit.swift
//  SteemShutter v3.0
//
//  Created by Mario Kardum on 19/07/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit

class photoEdit: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {
    
    
    // Outlets
    //Setting zoom option for scrollView
    
    @IBOutlet weak var scrollView: UIScrollView!{
        
        didSet {
            scrollView.delegate = self
            scrollView.maximumZoomScale = 5.0
            scrollView.minimumZoomScale = 1.0
            
        }
    }
    
    // photo is image for data that came from cameraView viewController
    
    @IBOutlet weak var photo: UIImageView!
    
    // Buttons
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    // Start cropping button is defined later
    @IBOutlet weak var startCroppingButton: UIButton!
    
    // Buttons for photo editing
    
    @IBOutlet weak var clearFiltersButton: UIButton!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var openFiltersButton: UIButton!
    
    
    // Colored buttons
    
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    // other outlets
    
    @IBOutlet weak var fontPicker: UIPickerView!
    
    @IBOutlet weak var steemLogo: UIImageView!
    @IBOutlet weak var steemSignature: UILabel!
    
    @IBOutlet weak var cropFrame: CropFrame!
    
    // Image that comes with segue
    var image: UIImage?
    
    // Font color
    var pickedColor: UIColor?
    
    // Picked filter
    var filterName: CIFilter?
    
    // List of the filters in the picker. These are CIFilters and their original names as STRINGS to call them later
    let filters = ["CIPhotoEffectMono", "CISepiaTone", "CIColorMonochrome", "CIPhotoEffectChrome", "CIColorInvert", "CIPhotoEffectInstant", "CIPhotoEffectFade", "CIPhotoEffectTonal", "CIVignette", "CIPhotoEffectProcess", "CIMaskToAlpha", "CIColorPosterize", "CIFalseColor", "CIColorCube"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // picker delegate
        
        fontPicker.isHidden = true
        fontPicker.delegate = self
        fontPicker.dataSource = self
        pickedColor = UIColor.white
        
        // photo.image takes the data from image
        
        photo.image = image
        
        
        // pickedColor is white by default
        
        steemSignature.textColor = pickedColor
        // Outline of cropFrame
        
        
        // setting the crop frame
        self.cropFrame.layer.borderWidth = 1
        self.cropFrame.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        
        // Rounded corners for the color buttons
        
        pinkButton.layer.cornerRadius = 8
        redButton.layer.cornerRadius = 8
        blueButton.layer.cornerRadius = 8
        whiteButton.layer.cornerRadius = 8
        greenButton.layer.cornerRadius = 8
        blackButton.layer.cornerRadius = 8
        orangeButton.layer.cornerRadius = 8
        
        
        // I want app to work on different photo resolutions, so the size of Steem Logo depends on the photo's width. this is a call of resizeImage function
        
        self.steemLogo.image = resizeImage(image: steemLogo.image!, targetSize: CGSize(width: (photo.image?.size.width)!/12.1, height: (photo.image?.size.height)!/16.128))
        
        

    }
    
    
    // Fetching the username for steem signature from userDefaults
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "signatureLabel") as? String {
            steemSignature.text = x
        }
        
        if let y = UserDefaults.standard.object(forKey: "font") {
            steemSignature.font = UIFont(name: y as! String, size: 12)
        }
        
       
        
        
        
        
    }
    
    
    // Filter Picker
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filters[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterName = CIFilter(name: filters[row])
        photo.image = filtersDone(image: photo.image!)
        fontPicker.isHidden = true
    }
    
    // This is the function that asks for filter name picked from the picker. t uses it as identifier and applies it to your photo.
    
    func filtersDone(image:UIImage) -> UIImage {
        let cgimg = image.cgImage
        let coreImage = CIImage(cgImage: cgimg!)
        let filter = filterName
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        let context = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        let outputImage = context.createCGImage((filter?.outputImage)!, from: (filter?.outputImage?.extent)!)
        var newImage = UIImage(cgImage: outputImage!)
        return newImage
    }
    
    // function to resize that SteemLogo proportional to the photo
    
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
    
    // Function to DRAW the SteemLogoon your photo
    
    func combineTwo (bcgimage image1: UIImage, wtmimage image2: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image1.size);
        image1.draw(in: CGRect(x: 0, y: 0, width: image1.size.width, height: image1.size.height))
        
        
        image2.draw(at: CGPoint(x: (steemLogo.image?.size.width)!/3, y: ((photo.image?.size.height)!-(steemLogo.image?.size.height)!-((steemLogo.image?.size.height)!/3))))
        let newImage2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage2!
    }
    
    // Defining cropArea
    var cropArea:CGRect{
        get{
            let factor = photo.image!.size.width/view.frame.width
            let scale = 1/scrollView.zoomScale
            let imageFrame = photo.imageFrame()
            let x = (scrollView.contentOffset.x + cropFrame.frame.origin.x - imageFrame.origin.x) * scale * factor
            let y = (scrollView.contentOffset.y + cropFrame.frame.origin.y - imageFrame.origin.y) * scale * factor
            let width = cropFrame.frame.size.width * scale * factor
            let height = cropFrame.frame.size.height * scale * factor
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    
    // We included pinch to zoom for the photo
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photo
    }
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = pickedColor
        let strokeColor = UIColor.black
        
        let fname = steemSignature.font.fontName
        
        let textFont = UIFont(name: fname, size: ((steemLogo.image?.size.height)!/1.75))
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.strokeColor: strokeColor,
            NSAttributedStringKey.strokeWidth: -1,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    // Back button dismisses this viewController
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show/hide crop frame and crop the photo
    
    @IBAction func startCroppingAction(_ sender: Any) {
        
        if cropFrame.isHidden == true {
            cropFrame.isHidden = false
            startCroppingButton.setTitle("Finish cropping", for: .normal)
        } else {
            let croppedCGImage = photo.image?.cgImage?.cropping(to: cropArea)
            let croppedImage = UIImage(cgImage: croppedCGImage!)
            photo.image = croppedImage
            scrollView.zoomScale = 1
            cropFrame.isHidden = true
            startCroppingButton.setTitle("Start cropping", for: .normal)
            
        }
    }
    
    
    // Open filter picker
    
    @IBAction func filtersAction(_ sender: Any) {
        
        if fontPicker.isHidden {
            fontPicker.isHidden = false
        }
        
    }
    
    
    // Clear filters takes you back to your origijal image as you took it with your camera
    
    @IBAction func clearFiltersAction(_ sender: Any) {
        photo.image = image
    }
    
    
    // RotateAction calls the function for permanent photo rotation sice I don't have auto-orientation included
    
    @IBAction func rotateAction(_ sender: Any) {
        photo.image = photo.image?.rotate(radians: .pi/2)

    }
    
    
    // Colored buttons actions
    // Tap the colored button when you wish to color your signature
    
    @IBAction func pinkAction(_ sender: Any) {
        pickedColor = pinkButton.backgroundColor
        steemSignature.textColor = pinkButton.backgroundColor
    }
    
    @IBAction func redAction(_ sender: Any) {
        pickedColor = redButton.backgroundColor
        steemSignature.textColor = redButton.backgroundColor
    }
    
    @IBAction func whiteAction(_ sender: Any) {
        pickedColor = whiteButton.backgroundColor
        steemSignature.textColor = whiteButton.backgroundColor
    }
    
    @IBAction func greenAction(_ sender: Any) {
        pickedColor = greenButton.backgroundColor
        steemSignature.textColor = greenButton.backgroundColor
    }
    
    @IBAction func blackAction(_ sender: Any) {
        pickedColor = blackButton.backgroundColor
        steemSignature.textColor = blackButton.backgroundColor
    }
    
    @IBAction func orangeAction(_ sender: Any) {
        pickedColor = orangeButton.backgroundColor
        steemSignature.textColor = orangeButton.backgroundColor
    }
    
    @IBAction func blueAction(_ sender: Any) {
        pickedColor = blueButton.backgroundColor
        steemSignature.textColor = blueButton.backgroundColor
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        // Drawing signature text on the photo. It's size is proportional to resized steem logo
        self.photo.image = textToImage(drawText: steemSignature.text!, inImage: photo.image!, atPoint: CGPoint(x: (steemLogo.image?.size.width)!/0.8, y: ((photo.image?.size.height)!-(steemLogo.image?.size.height)!-((steemLogo.image?.size.height)!/5))))
        
        // Drawing SteemLogo on the photo
        self.photo.image = combineTwo(bcgimage: photo.image!, wtmimage: steemLogo.image!)
        
        
        // Setting the new size of the image (width: 1000, height proportional)
        
        // the photo width is 1000, this have to he he heigth if we want our photo to keep the ratio: height: ((photo.image?.size.height)!*1000/(photo.image?.size.width)!))
        
        let newPhotoSize = CGSize(width: 1000, height: ((photo.image?.size.height)!*1000/(photo.image?.size.width)!))
        
        self.photo.image = resizeImage(image: photo.image!, targetSize: newPhotoSize)
        
        
        
        // Save to photo library
        
        guard let imageToSave = photo.image
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
// Rotate extension
extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, self.scale)
        let context2 = UIGraphicsGetCurrentContext()!
        
        context2.translateBy(x: newSize.width/2, y: newSize.height/2)
        context2.rotate(by: CGFloat(radians))
        
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage2
    }
}

// Extension for the frame of cropFrame

extension UIImageView{
    func imageFrame()->CGRect{
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else{return CGRect.zero}
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        }else{
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
    
    
    
    
    
}

// I had to add this class, otherwise you wouldn"t be able to zoom inside the cropFrame

class CropFrame: UIView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
}
