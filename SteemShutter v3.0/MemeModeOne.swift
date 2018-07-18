//
//  MemeModeOne.swift
//  SteemShutter v3.0
//
//  Created by Mario Kardum on 17/07/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit

class MemeModeOne: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {
    
    
    // Next and Back buttons - outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    // top text field and bottom text field - outlets
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    // Button for opening Photo Library- Pick any photo for your meme
    
    @IBOutlet weak var chooseTheImageButton: UIButton!
    
    // Button that  reveals fontsPicker
    
    @IBOutlet weak var fontsButton: UIButton!
    
    
    // Color buttons - outlets
    
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    // Picked image goes to this imageView
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    // fonts Picker
    
    @IBOutlet weak var fontsPicker: UIPickerView!
    
    // Font list
    
    let fonts = ["HoeflerText-Black", "Farah", "BradleyHandITCTT-Bold", "Noteworthy-Bold", "SnellRoundhand-Bold", "MarkerFelt-Wide", "Avenir-BlackOblique", "Futura-CondensedExtraBold", "Courier-BoldOblique", "HiraKakuProN-W3", "Papyrus"]
    
    // Values that define chosen color and font
    
    var chosenFont: UIFont?
    var chosenColor: UIColor?
    var strokeColor = UIColor.black
    
    
    // imageOne and imageTwo: imageOne is chosen photo with top text drawn on it, image two is imageOne with bottom text (complete meme)
    
    var imageOne: UIImage?
    var imageTwo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Let's round some corners
        
        chooseTheImageButton.layer.cornerRadius = 12
        
        fontsButton.layer.cornerRadius = 23
        
        pinkButton.layer.cornerRadius = 8
        redButton.layer.cornerRadius = 8
        whiteButton.layer.cornerRadius = 8
        greenButton.layer.cornerRadius = 8
        blueButton.layer.cornerRadius = 8
        orangeButton.layer.cornerRadius = 8
        blackButton.layer.cornerRadius = 8
        
        
        
        //Next button reveals itself AFTER you pick an image
        
        nextButton.isHidden = true
        
        
        
        // Picker and text field delegates
        
        
        self.topText.delegate = self
        self.bottomText.delegate = self
        fontsPicker.delegate = self
        fontsPicker.isHidden = true
        fontsPicker.dataSource = self
        

    }
    
    
    // Picker functions
    
    // Choose ONLY one font
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fonts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fonts[row]
    }
    
    // setting the chosen font for the top and bottom meme text
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenFont = UIFont(name: fonts[row], size: 28)
        topText.font = chosenFont
        bottomText.font = chosenFont
        
        
        // Hiding picker when you chose a font
        fontsPicker.isHidden = true
        
    }
    
    // Image Picker
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info [UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        
       
        nextButton.isHidden = false
    }
    
    // Resigning first responder when you are finished with each text field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        topText.resignFirstResponder()
        bottomText.resignFirstResponder()
        return true
    }
    
    
    
    
    // Function that draws meme text on the photo
    
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        
        // Defining the colors
        let textColor = chosenColor
        let strokeColor = UIColor.black
        
        // The font is same for both text fields
        
        let fontix = topText.font?.fontName
        
        
        let textFont = UIFont(name: fontix!, size: (imageView.image?.size.width)!/10.4)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            
            
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.strokeColor: strokeColor,
            NSAttributedStringKey.strokeWidth: -3.0,
            NSAttributedStringKey.paragraphStyle: paragraph,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        let rect2 = CGRect(x: point.x - rect.size.width/2, y: point.y, width: rect.size.width, height: rect.size.height)
        
        text.draw(in: rect2, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    // Back button dismisses this view cntroller and takes you back at the beginning
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    // Open photo library and choose the image
    @IBAction func chooseImageAction(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true, completion: nil)
        
    }
    
    // Open fontsPicker
    @IBAction func fontsAction(_ sender: Any) {
        if fontsPicker.isHidden == true {
            fontsPicker.isHidden = false
        } else {
            fontsPicker.isHidden = true
        }
    }
    
    
    
    // The comment for the next button is the same for all COLOR buttons
    
    @IBAction func pinkAction(_ sender: Any) {
        // cosen color is the color of the drawn text
        chosenColor = pinkButton.backgroundColor
        
        
        // Top text and bottom text are colored as the button you tapped
        topText.textColor = pinkButton.backgroundColor
        bottomText.textColor = pinkButton.backgroundColor
    }
    @IBAction func redAction(_ sender: Any) {
        chosenColor = redButton.backgroundColor
        topText.textColor = redButton.backgroundColor
        bottomText.textColor = redButton.backgroundColor
    }
    @IBAction func whiteAction(_ sender: Any) {
        chosenColor = whiteButton.backgroundColor
        topText.textColor = whiteButton.backgroundColor
        bottomText.textColor = whiteButton.backgroundColor
    }
    @IBAction func greenAction(_ sender: Any) {
        chosenColor = greenButton.backgroundColor
        topText.textColor = greenButton.backgroundColor
        bottomText.textColor = greenButton.backgroundColor
    }
    @IBAction func blackAction(_ sender: Any) {
        chosenColor = blackButton.backgroundColor
        topText.textColor = blackButton.backgroundColor
        bottomText.textColor = blackButton.backgroundColor
    }
    @IBAction func orangeAction(_ sender: Any) {
        chosenColor = orangeButton.backgroundColor
        topText.textColor = orangeButton.backgroundColor
        bottomText.textColor = orangeButton.backgroundColor
    }
    @IBAction func blueAction(_ sender: Any) {
        chosenColor = blueButton.backgroundColor
        topText.textColor = blueButton.backgroundColor
        bottomText.textColor = blueButton.backgroundColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // MemeModeTwo is next view controller
        // memeGo is just a helpful var
        // imageTwo is finished meme
 
        var memeGo = segue.destination as! MemeModeTwo
        
        memeGo.meme = imageTwo
    }
    
    
    // Tap next button to take your meme to next view controller
    
    
    @IBAction func nextAction(_ sender: Any) {
        
        // I had to count carefully the position of each text field onto picked image
        
        // First, let's draw the top text on the picked image and generate imageOne
        self.imageOne = textToImage(drawText: topText.text!, inImage: imageView.image!, atPoint: CGPoint(x: ((imageView.image?.size.width)!/2), y: (((imageView.image?.size.height)!/30))))
        
        
        // Now, let's draw the bototm text into imageOne and generate imageTwo - full meme
        self.imageTwo = textToImage(drawText: bottomText.text!, inImage: imageOne!, atPoint: CGPoint(x: ((imageOne?.size.width)!/2), y: ((imageOne?.size.height)!-((imageOne?.size.height)!/4.4))))
        
        // Performing the segue
        performSegue(withIdentifier: "memeNext", sender: nil)
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
