//
//  ViewController.swift
//  SteemShutter v3.0
//
//  Created by Mario Kardum on 17/07/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit
import SwiftyJSON
import SteemShutter_Framework

class ViewController: UIViewController {
    
    // Buttons
    // Each button opens a segue and re-directs a user to another view controller
    
    @IBOutlet weak var openCameraButton: UIButton!
    @IBOutlet weak var signatureCreatorButton: UIButton!
    @IBOutlet weak var memeModeButton: UIButton!
    @IBOutlet weak var collageFramesButton: UIButton!
    
    
    // Labels (static text fields)
    
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var cntentLabel: UILabel!
    @IBOutlet weak var payoutLabel: UILabel!
    
    // Havinga few hidden labels is always useful, sometimes it is better than forcing unwrap of optional vars
    
    @IBOutlet weak var hiddenLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Let's get closer to Apple image by rounding some corners
        
        openCameraButton.layer.cornerRadius = 12
        signatureCreatorButton.layer.cornerRadius = 12
        memeModeButton.layer.cornerRadius = 12
        collageFramesButton.layer.cornerRadius = 12
        
        
        
        
        // Calling SteemApi function that fetches info about user's most recent post on Steemit
        // To call this function, it is necessarry to have a saved signature. So if there is no any saved signature, the function will just stay quiet
        
        
        if signatureLabel.text != nil {
            
            // Calling the main function
            SteemApi()
            
            
        }
            
            
        else {
            return
        }
        
        
        
        
        
    }
    
    
    // When you get to the Signature Creator View controller, these three vars are always stay saved until you change them
    // Fetching those vars needed for call SteemApi function
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "signatureLabel") as? String {
            hiddenLabel.text = x
        }
        
        if let y = UserDefaults.standard.object(forKey: "font") {
            signatureLabel.font = UIFont(name: y as! String, size: 12)
        }
       
        if let z = UserDefaults.standard.object(forKey: "signatureText") as? String {
            signatureLabel.text = z
        }
        
        if signatureLabel.text != nil {
            
            // Calling the main function
            SteemApi()
            
            
        }
            
            
        else {
            return
        }
        
        
        
    }
    
    @IBAction func signatureCreatorAction(_ sender: Any) {
        performSegue(withIdentifier: "signatureSegue", sender: nil)
        
        
    }
    
    
    @IBAction func memeModeAction(_ sender: Any) {
        
        performSegue(withIdentifier: "memeSegue", sender: nil)
        
        
    }
    
    
    @IBAction func framesAction(_ sender: Any) {
        
        performSegue(withIdentifier: "framesSegueOne", sender: nil)
        
    }
    
    
    
    
    
    func SteemApi() {
        
        
        // url SteemJS api (Content by blog), instead of username, the function adds the text from signatureLabel
        let url = URL(string: "https://api.steemjs.com/get_discussions_by_blog?query=%7B%22tag%22%3A%22" + signatureLabel.text! + "%22%2C%20%22limit%22%3A%20%221%22%7D")
        
        
        
        // We will use SwiftyJSON for this
        
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String: AnyObject]]
                    
                    
                    //Let's call pending payout
                    if let payout = json[0]["pending_payout_value"] {
                        DispatchQueue.main.async {
                            self.payoutLabel.text = payout as? String
                        }
                    }
                    
                    // Let's call the title of the post
                    if let title = json[0]["title"] {
                        DispatchQueue.main.async {
                            self.cntentLabel.text = title as? String
                        }
                    }
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        
        }).resume()
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

