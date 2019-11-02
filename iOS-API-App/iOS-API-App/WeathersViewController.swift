//
//  WeathersViewController.swift
//  SimpleWeather
//
//  Created by Jese on 15.10.2019.
//  Copyright © 2019 jpitkanen18. All rights reserved.
//

import UIKit
import CoreData

class WeathersViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var locations = [String]()
    var temps = [Int]()
    var newLocation: String = ""
    var destinationInt = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        titleLabel.title = "SimpleWeather"
        fetchData()
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
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FetchedWeather")
            let container = appDelegate.persistentContainer
            do {
                if let objects = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject] {
                    for object in objects{
                        if object.value(forKey: "cityName") as? String == locations[indexPath.row]{
                            container.viewContext.delete(object)
                            tableView.beginUpdates()
                            locations.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                            tableView.endUpdates()
                            do{
                                try container.viewContext.save()
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            catch{
                print(error)
            }
            
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! WeatherTableViewCell
        cell.cityLabel.text = locations[indexPath.row]
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.backgroundColor = UIColor.white
        cell.contentView.backgroundColor = UIColor.white
        cell.contentView.clipsToBounds = true
        DispatchQueue.main.async {
            if cell.temperatureLabel.text == "--"{
                self.getTemp(city: self.locations[indexPath.row], cell: cell, row: indexPath.row)
            }
        }
        return cell
    }
    
     @IBAction func done(segue: UIStoryboardSegue) {
        let locationsVC = segue.source as! ViewController
        newLocation = locationsVC.name
        let container = appDelegate.persistentContainer
        guard let entity = NSEntityDescription.entity(forEntityName: "FetchedWeather", in: container.viewContext) else {
            fatalError("Wäää")
        }
        let city = NSManagedObject(entity: entity, insertInto: container.viewContext)
        city.setValue(newLocation, forKey: "cityName")
        do {
            try container.viewContext.save()
        }
        catch {
            print(error)
        }
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
        var url = URL(string: "http://" + ip + ":6969/city=" + locations[row] + "&fullData=false")
        let citySplit = city.split(separator: " ")
        var cityNew = ""
        if citySplit.count > 1{
            for split in citySplit{
                cityNew += split + "&"
            }
            let cityFinal = cityNew.dropLast()
            url = URL(string: "http://" + ip + ":6969/city=" + cityFinal + "&fullData=false")
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
                let temp = Int(weatherData.temperature.dropLast(2))!
                switch temp{
                case 0...5:
                    tcell.gradientLayer.colors = tcell.coldColor
                case 5...24:
                    tcell.gradientLayer.colors = tcell.warmColor
                case let temp where temp < 0:
                    tcell.gradientLayer.colors = tcell.subzero
                case let temp where temp > 25:
                    tcell.gradientLayer.colors = tcell.hotColor
                default:
                    tcell.gradientLayer.colors = tcell.coldColor
                }
            }
        }
        task.resume()
    }
    func fetchData() {
        let container = appDelegate.persistentContainer
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FetchedWeather")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"cityName", ascending: true)]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            if let objects = try container.viewContext.fetch(fetchRequest) as? [NSManagedObject] {
                for object in objects{
                    if let cityName = object.value(forKey: "cityName") as? String, let cityTemp = object.value(forKey: "cityTemp") as? Int{
                        locations.append(cityName)
                        temps.append(cityTemp)
                    }
    
                }
            }

        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        do {
            try fetchedResultController.performFetch()
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

}
