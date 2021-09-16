//
//  WeatherDetailViewController.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 06.08.2021.
//

import UIKit

class WeatherDetailViewController: UITableViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperatute: UILabel!
    @IBOutlet weak var tempFeelsLike: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cloudness: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windDirection: UILabel!
    
    var name = ""
    var temp = ""
    var tempFL = 0.0
    var image = ""
    var clouds = 0
    var humid = 0
    var press = 0.0
    var windS = 0.0
    var windD = 0
    
    var forecasts = [ForecastModel]()
    var unit = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.navigationController?.navigationBar.tintColor = .white

        cityName.text = name
        temperatute.text = temp
        tempFeelsLike.text = "\(String(format: "%.f", tempFL))°\(unit)"
        weatherImage.image = UIImage(systemName: image)
        cloudness.text = "\(clouds)%"
        humidity.text = "\(humid)%"
        pressure.text = "\(String(format: "%.f", press)) mm hPa"
        windSpeed.text = "\(String(format: "%.f", windS)) m/s"
        windDirection.text = "\(windD)°"
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .center
    
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "ForecastCell",
                            bundle: nil)
        self.tableView.register(cell,
                                forCellReuseIdentifier: "ForecastCell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell") as? ForecastCell else { return UITableViewCell() }
                cell.configure(forecast: forecasts[indexPath[1]], unit: unit)
                return cell
            }
      
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
}
