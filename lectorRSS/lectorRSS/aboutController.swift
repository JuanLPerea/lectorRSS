//
//  aboutControllerViewController.swift
//  lectorRSS
//
//  Created by Juan Luis on 14/04/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class aboutController: UIViewController {


    @IBOutlet weak var enlaceInteres: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        enlaceInteres.isEditable = false
        enlaceInteres.dataDetectorTypes = .link
        
      
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
