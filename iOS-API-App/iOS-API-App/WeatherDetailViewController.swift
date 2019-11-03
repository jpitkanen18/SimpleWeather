//
//  WeatherDetailViewController.swift
//  SimpleWeather
//
//  Created by Jese on 15.10.2019.
//  Copyright © 2019 jpitkanen18. All rights reserved.
//

import UIKit
let ip = "YOUR IP HERE" //This is a global variable which is a big nono but let's just ignore that aight :D
class WeatherDetailViewController: UIViewController {
    
    var city = ""
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateNow: UILabel!
    var gradientLayer: CAGradientLayer!
    var color = UIColor.white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var url = URL(string: "http://" + ip + ":6969/city=" + city + "&fullData=true")
        tempLabel.textColor = color
        cityLabel.textColor = color
        sunrise.textColor = color
        sunset.textColor = color
        descLabel.textColor = color
        dateNow.textColor = color
        let citySplit = city.split(separator: " ")
        var cityNew = ""
        if citySplit.count > 1{
            for split in citySplit{
                cityNew += split + "&"
            }
            let cityFinal = cityNew.dropLast()
            url = URL(string: "http://" + ip + ":6969/city=" + cityFinal + "&fullData=true")
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
                self.tempLabel.text = weatherData.temperature
                self.sunrise.text = "Sunrise\n" + weatherData.sunrise
                self.sunset.text = "Sunset\n" + weatherData.sunset
                self.descLabel.text = weatherData.description
                self.dateNow.text = "Local time\n" + weatherData.timenow
                let temp = Int(weatherData.temperature.dropLast(2))!
                let tcell = WeatherTableViewCell()
                switch temp{
                case 0...5:
                    self.createGradientLayer(colors: tcell.coldColor)
                case 5...24:
                    self.createGradientLayer(colors: tcell.warmColor)
                case let temp where temp < 0:
                    self.createGradientLayer(colors: tcell.subzero)
                case let temp where temp > 25:
                    self.createGradientLayer(colors: tcell.hotColor)
                default:
                    self.createGradientLayer(colors: tcell.coldColor)
                }
            }
        }
        task.resume() 
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            if self.tempLabel.text == "--" {
            let ac = UIAlertController(title: "Weather data not found", message: "Weather data not found for " + self.city, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(ac, animated: true, completion: nil)
            }
    })
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createGradientLayer(colors: [CGColor]) {
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        gradientLayer.colors = colors
        gradientLayer.masksToBounds = false
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: -0.5)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    

}
struct weatherData: Decodable {
    let temperature: String
    let description: String
    let sunrise: String
    let sunset: String
    let timenow: String
    
    enum CodingKeys : String, CodingKey {
        case description
        case temperature
        case sunrise
        case sunset
        case timenow
        
    }
}
