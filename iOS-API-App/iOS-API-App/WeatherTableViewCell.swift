//
//  WeatherTableViewCell.swift
//  SimpleWeather
//
//  Created by Jese on 16.10.2019.
//  Copyright © 2019 jpitkanen18. All rights reserved.
//

 import UIKit

class WeatherTableViewCell: UITableViewCell {
    var gradientLayer: CAGradientLayer!
    let coldColor = [UIColor(red:0.00, green:0.45, blue:1.00, alpha:1.0).cgColor, UIColor(red:0.00, green:0.90, blue:1.00, alpha:1.0).cgColor]
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        createGradientLayer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
     
        gradientLayer.frame = CGRect(x: 10, y: 8, width: self.contentView.frame.size.width - 20, height: 65)
    
        gradientLayer.colors = [UIColor(red:0.00, green:0.45, blue:1.00, alpha:1.0).cgColor, UIColor(red:0.00, green:0.90, blue:1.00, alpha:1.0).cgColor]
        gradientLayer.masksToBounds = false
        gradientLayer.cornerRadius = 10.0
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: -0.5)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }

}
