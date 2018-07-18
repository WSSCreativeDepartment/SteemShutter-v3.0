//
//  MemeModeTwo.swift
//  SteemShutter v3.0
//
//  Created by Mario Kardum on 18/07/2018.
//  Copyright © 2018 dumar022. All rights reserved.
//

import UIKit

class MemeModeTwo: UIViewController {
    
    
    // var meme is imageTwo from MemeModeOne view controller
    
    var meme: UIImage?
    
    
    // memeView is preview outlet for meme
    @IBOutlet weak var memeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeView.image = meme

    }
    
    
    // Dismissing this view controller without saving
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Saving meme to your photo library
    @IBAction func saveAction(_ sender: Any) {
        guard let imageToSave = memeView.image
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
