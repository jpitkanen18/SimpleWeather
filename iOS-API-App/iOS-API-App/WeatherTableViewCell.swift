//
//  WeatherTableViewCell.swift
//  SimpleWeather
//
//  Created by Jese on 16.10.2019.
//  Copyright © 2019 jpitkanen18. All rights reserved.
//

 import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

}
