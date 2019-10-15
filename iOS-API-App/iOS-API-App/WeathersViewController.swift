//
//  WeathersViewController.swift
//  SimpleWeather
//
//  Created by Jese on 15.10.2019.
//  Copyright © 2019 jpitkanen18. All rights reserved.
//

import UIKit

class WeathersViewController: UITableViewController {
    
    var locations = [String]()
    var newLocation: String = ""
    var destinationInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locations = ["Espoo", "Helsinki", "Turku"]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row]
        return cell
    }
    
     @IBAction func done(segue: UIStoryboardSegue) {
        let locationsVC = segue.source as! ViewController
        newLocation = locationsVC.name
           
        locations.append(newLocation)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.destinationInt = indexPath.row
        self.performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            let destVC = segue.destination as! WeatherDetailViewController
            print(locations[destinationInt])
            destVC.city = locations[destinationInt]
        }
    }

}
