//
//  TodayViewController.swift
//  SteemShutter Extension
//
//  Created by Mario Kardum on 17/07/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit
import NotificationCenter
import SwiftyJSON
import SteemShutter_Framework

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var payoutLabel: UILabel!
    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        
        if let name = UserDefaults.init(suiteName: "group.shutter")?.value(forKey: "MyNameIs"){
            
            //   Fetching username from ViewController. It remains saved in the app when it is turned off or when it works in the background, untill you change it
            
            titleLabel.text = name as? String
            
        }
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
       
        
        completionHandler(NCUpdateResult.newData)
        
        SteemApi()
        
    }
    // The main function is the same as in ViewController
    func SteemApi() {
        let url = URL(string: "https://api.steemjs.com/get_discussions_by_blog?query=%7B%22tag%22%3A%22" + titleLabel.text! + "%22%2C%20%22limit%22%3A%20%221%22%7D")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String: AnyObject]]
                    
                    // Calling the pending payout
                    if let payout = json[0]["pending_payout_value"] {
                        DispatchQueue.main.async {
                            self.payoutLabel.text = payout as? String
                        }
                    }
                
                    
                    
                    
                    
                }catch let error as NSError{
                    print(error)
                }
            }
            
            
            
            
            
        }).resume()
        
    }
    
}
