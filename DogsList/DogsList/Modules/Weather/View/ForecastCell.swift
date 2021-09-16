//
//  ForecastCell.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 11.08.2021.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    func configure(forecast: ForecastModel, unit: String ) {
        DispatchQueue.main.async {
            let day = self.getDayOfWeek(utcTime: forecast.timeInterval)
            self.dayLabel.text = day
            self.icon.image = UIImage(systemName: forecast.conditionName)
            self.tempLabel.text = "\(String(format: "%.f", forecast.temperature)) °\(unit)"
        }
    }
    
    func getDayOfWeek(utcTime: TimeInterval) -> String {
        let date = NSDate(timeIntervalSince1970: utcTime )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date as Date)
        return dayInWeek
    }
}
