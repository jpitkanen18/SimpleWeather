//
//  WeathersViewController.swift
//  SimpleWeather
//
//  Created by Jese on 15.10.2019.
//  Copyright © 2019 jpitkanen18. All rights reserved.
//

import UIKit

class WeathersViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    var locations = [String]()
    var newLocation: String = ""
    var destinationInt = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        locations = ["Espoo", "Helsinki", "Turku"]
        titleLabel.title = "SimpleWeather"
        let cells = tableView.visibleCells
        for cell in cells {
            cell.backgroundColor = UIColor.cyan
            cell.layer.cornerRadius = 10.0
            cell.layer.masksToBounds = true
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! WeatherTableViewCell
        //cell.textLabel?.text = locations[indexPath.row]
        cell.cityLabel.text = locations[indexPath.row]
        cell.temperatureLabel.text = "--"
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.backgroundColor = UIColor.white
        cell.contentView.backgroundColor = UIColor.white
        cell.contentView.clipsToBounds = true
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 65))
        whiteRoundedView.layer.backgroundColor = UIColor.systemBlue.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 10.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        DispatchQueue.main.async {
            self.getTemp(city: self.locations[indexPath.row], cell: cell, row: indexPath.row)
        }
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
    func getTemp(city: String, cell: UITableViewCell, row: Int){
        let tcell = cell as! WeatherTableViewCell
        var url = URL(string: "http://YOUR IP HERE/city=" + locations[row] + "&fullData=false")
        let citySplit = city.split(separator: " ")
        var cityNew = ""
        if citySplit.count > 1{
            for split in citySplit{
                cityNew += split + "&"
            }
            let cityFinal = cityNew.dropLast()
            url = URL(string: "http://YOUR IP HERE/city=" + cityFinal + "&fullData=false")
        }
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
        guard let data = data else {
                print("meme")
                return
        }
        guard let weatherData = try? JSONDecoder().decode(weatherData.self, from: data) else {
            print("äää")
            return
        }
            DispatchQueue.main.async {
                print(weatherData)
                
                tcell.temperatureLabel.text = weatherData.temperature
            }
        }
        task.resume()
    }

}
