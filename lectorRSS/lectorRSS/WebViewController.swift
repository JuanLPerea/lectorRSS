//
//  WebViewController.swift
//  lectorRSS
//
//  Created by Juan Luis on 12/04/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class WebViewController: UIViewController, WKNavigationDelegate{

    @IBOutlet weak var navegadorView: WKView!
    var urlNoticia:URL!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navegadorView.navigationDelegate = self
        
        let url = urlNoticia!
        navegadorView.load(URLRequest(url: url))

        // Do any additional setup after loading the view.
    }
    
    @IBAction func volverBtn(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "volverNoticias", sender: self)
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
