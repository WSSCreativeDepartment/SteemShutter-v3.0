//
//  SignatureCreator.swift
//  SteemShutter v3.0
//
//  Created by Mario Kardum on 17/07/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit

class SignatureCreator: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {
    
    
    // Text fiels to write your Steemit username
    
    @IBOutlet weak var signatureTextField: UITextField!
    
    
    // View your Steemit username
    @IBOutlet weak var signatureLabel: UILabel!
    
    // FontsButton opens the fontsPicker
    
    @IBOutlet weak var fontsButton: UIButton!
    @IBOutlet weak var fontsPicker: UIPickerView!
    
    
    // LabelFont is unwraped value that we equalize with the chosen font
    

    var labelFont: UIFont?
    
    
    // aSelfvote button saves your username and font
    
    @IBOutlet weak var aSelfvote: UIButton!
    
    
    // Fonts
    
    let fonts = ["HoeflerText-Black", "Farah", "BradleyHandITCTT-Bold", "Noteworthy-Bold", "SnellRoundhand-Bold", "MarkerFelt-Wide", "Avenir-BlackOblique", "Futura-CondensedExtraBold", "Courier-BoldOblique", "HiraKakuProN-W3", "Papyrus"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Rounding corners
        fontsButton.layer.cornerRadius = 30
        
        
        // Text and picker delegates
        
        self.signatureTextField.delegate = self
        fontsPicker.delegate = self
        fontsPicker.dataSource = self
        

    }
    
    
    // Fuctions for hiding keyboard when you tap soewhere else on the screen or press the "return" button
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    // Function that allows only lowercase letters and doesn't allow any whitespace
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //just change this charectar username  it's a text field
        if textFieldToChange == signatureTextField {
            let characterSetNotAllowed = CharacterSet.whitespaces
            if let _ = string.rangeOfCharacter(from:NSCharacterSet.uppercaseLetters) {
                return false
            }
            if let _ = string.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive) {
                return false
            } else {
                return true
            }
        }
        return true
    }
    
    
    // Resigning the first responder in the text field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signatureTextField.resignFirstResponder()
        
        
        // Adding "@" to username only for signature label
        
        signatureLabel.text = "@"  + signatureTextField.text!

        
        return true

    }
    
    // Funcions for fonts Picker
    
    
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
        labelFont = UIFont(name: fonts[row], size: 28)
        signatureLabel.font = labelFont
        fontsPicker.isHidden = true
        
    }
    
    
    
    
    
    // Fonts button reveals the picker if it was hidden.
    
    @IBAction func fontsAction(_ sender: Any) {
        signatureLabel.text = "@"  + signatureTextField.text!

        
        if fontsPicker.isHidden == true {
            fontsPicker.isHidden = false
            
        } else {
            fontsPicker.isHidden = true
        }
    }
    
    // SelfvoteButton saves your values, dismisses this view controller and takes you backto the main view controller with saved values
    
    @IBAction func selfVoteAction(_ sender: Any) {
        UserDefaults.standard.set(labelFont?.fontName, forKey: "font")
        UserDefaults.standard.set(signatureTextField.text, forKey: "signatureText")
        UserDefaults.standard.set(signatureLabel.text, forKey: "signatureLabel")
        
        dismiss(animated: true, completion: nil)



        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   

}
