//
//  SignatureCreator.swift
//  SteemShutter v3.0
//
//  Created by Mario Kardum on 17/07/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit

class SignatureCreator: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var signatureTextField: UITextField!
    @IBOutlet weak var signatureLabel: UILabel!
    
    @IBOutlet weak var fontsButton: UIButton!
    @IBOutlet weak var fontsPicker: UIPickerView!
    var labelFont: UIFont?
    
    @IBOutlet weak var aSelfvote: UIButton!
    
    let fonts = ["HoeflerText-Black", "Farah", "BradleyHandITCTT-Bold", "Noteworthy-Bold", "SnellRoundhand-Bold", "MarkerFelt-Wide", "Avenir-BlackOblique", "Futura-CondensedExtraBold", "Courier-BoldOblique", "HiraKakuProN-W3", "Papyrus"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fontsButton.layer.cornerRadius = 30
        
        self.signatureTextField.delegate = self
        fontsPicker.delegate = self
        fontsPicker.dataSource = self
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signatureTextField.resignFirstResponder()
        
        return true

    }
    
    
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
    
    
    
    
    
    
    
    @IBAction func fontsAction(_ sender: Any) {
        signatureLabel.text = "@"  + signatureTextField.text!

        
        if fontsPicker.isHidden == true {
            fontsPicker.isHidden = false
            
        } else {
            fontsPicker.isHidden = true
        }
    }
    
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
