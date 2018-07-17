//
//  ViewController.swift
//  SteemShutter v3.0
//
//  Created by Mario Kardum on 17/07/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var openCameraButton: UIButton!
    @IBOutlet weak var signatureCreatorButton: UIButton!
    @IBOutlet weak var memeModeButton: UIButton!
    @IBOutlet weak var collageFramesButton: UIButton!
    
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var cntentLabel: UILabel!
    @IBOutlet weak var payoutLabel: UILabel!
    
    @IBOutlet weak var hiddenLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        openCameraButton.layer.cornerRadius = 12
        signatureCreatorButton.layer.cornerRadius = 12
        memeModeButton.layer.cornerRadius = 12
        collageFramesButton.layer.cornerRadius = 12
        
        
        if signatureLabel.text != nil {
            
            // Calling the main function
            SteemApi()
            
            
        }
            
            
        else {
            return
        }
        
        
        
        
        
    }
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
    
    func SteemApi() {
        
        
        // url SteemJS api (Content by blog), instead of username, the function adds the text from userLabel
        let url = URL(string: "https://api.steemjs.com/get_discussions_by_blog?query=%7B%22tag%22%3A%22" + signatureLabel.text! + "%22%2C%20%22limit%22%3A%20%221%22%7D")
        
        
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

