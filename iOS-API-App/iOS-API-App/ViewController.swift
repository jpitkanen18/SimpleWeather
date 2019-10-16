//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Jese on 15.10.2019.
//  Copyright © 2019 jpitkanen18. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var locationName: UITextField!
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationName.placeholder = "Enter a location name"
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            name = locationName.text!
        }
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

