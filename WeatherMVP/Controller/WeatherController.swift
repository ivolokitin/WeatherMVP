//
//  WeatherController.swift
//  WeatherMVP
//
//  Created by Ivan Volokitin on 21.08.2020.
//  Copyright © 2020 Ivan Volokitin. All rights reserved.
//

import UIKit
import CoreLocation

private let cvReuseIdentifier = "HourlyCell"

private let tvReuseIdentifier = "DailyCell"

class WeatherController: UIViewController {
    
    // MARK: - Properties
    
    private var locationManager = CLLocationManager()
    
    private var location: CLLocation?
    
    private var weatherVM: WeatherViewModel!
    
    private let currentWeatherView = CurrentWeatherView(frame: .zero)
    
    private let detailedWeatherView = DetailedWeatherView(frame: .zero)
    
    private var collectionView: UICollectionView!
    
    private var tableView: UITableView!
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        
        /*
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "globe")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 25, height: 25)
        let attachmentString = NSAttributedString(attachment: imageAttachment)

        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)

        let textString = NSAttributedString(string: label.text ?? "")
        mutableAttributedString.append(textString)

        label.attributedText = mutableAttributedString
        // https://stackoverflow.com/questions/19318421/how-to-embed-small-icon-in-uilabel
        */
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.shadow()
        label.alpha = 0.7
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        // scrollView.backgroundColor = .orange
        // scrollView.isScrollEnabled = true
        // scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*2)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 1.15)
        return scrollView
    }()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
        checkLocationServices()
        // fetchWeather()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - CoreLocation
    
    func checkLocationServices() {
        
        /// This app has attempted to access privacy-sensitive data without a usage description.
        /// Info.plist - Privacy - Privacy - Location When In Use Usage Description
        
        // if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            // locationManager.startUpdatingLocation()
            
        } else {
            
            let alertController = UIAlertController(title: "Location services are disabled on the device",
                                                    message: "You can enable location services by toggling the Location Services switch in Settings > Privacy.",
                                                    preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func fetchCity() {
        guard let location = location else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ru-RU")) { placemarks, error in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            guard let city = placemark.locality else { return }
            
            self.locationLabel.set(city)
        }
    }
    
    // MARK: - API
    
    func fetchWeather() {
        
        /// App Transport Security policy requires the use of a secure connection.
        /// Info.plist - App Transport Security Settings - Allow Arbitrary Loads - YES

        guard let location = location else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let urlString = "http://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&exclude=minutely&lang=ru&appid=b23c17b4265eab334df4fe1eadbe1311"
        
        //  Example http://api.openweathermap.org/data/2.5/onecall?lat=30.489772&lon=-99.771335&units=metric&exclude=minutely&lang=ru&appid=b23c17b4265eab334df4fe1eadbe1311
        
        decodeJSON(urlString: urlString, modelType: WeatherModel.self) { data in
            if let weatherData = data {
                self.weatherVM = WeatherViewModel(current: weatherData.current, hourly: weatherData.hourly, daily: weatherData.daily)
                
                DispatchQueue.main.async {
                    self.configureUI()
                    self.updateWeatherInfo()
                }
                
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "image")!)
        
        view.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationLabel.widthAnchor.constraint(equalToConstant: view.frame.width),
            // locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            // locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(scrollView)
        // scrollView.frame = view.frame
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            // scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(currentWeatherView)
        // currentWeatherView.backgroundColor = .blue
        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentWeatherView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            currentWeatherView.widthAnchor.constraint(equalToConstant: view.frame.width),
            currentWeatherView.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        ])
        
        configureCollectionView()
        scrollView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.height / 5)
        ])
        
        configureTableView()
        scrollView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            // tableView.widthAnchor.constraint(equalToConstant: view.frame.width),
            // tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
            tableView.heightAnchor.constraint(equalToConstant: view.frame.height / 4)
        ])
        
        scrollView.addSubview(detailedWeatherView)
        detailedWeatherView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailedWeatherView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            detailedWeatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            detailedWeatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            // detailedWeatherView.widthAnchor.constraint(equalToConstant: view.frame.width),
            detailedWeatherView.heightAnchor.constraint(equalToConstant: view.frame.height / 5)
        ])
    }
    
    func updateWeatherInfo() {
        fetchCity()
        
        // Current
        currentWeatherView.weatherIcon.image = weatherVM.icon
        currentWeatherView.descriptionLabel.text = weatherVM.description
        currentWeatherView.temperatureLabel.text = weatherVM.currentTemperature
        
        // Detailed
        detailedWeatherView.humidityBlockView.valueLabel.text = weatherVM.humidity
        detailedWeatherView.pressureBlockView.valueLabel.text = weatherVM.pressure
        detailedWeatherView.windBlockView.valueLabel.text = weatherVM.windSpeed
        detailedWeatherView.windBlockView.directionImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double(weatherVM.degree) * Double.pi / 180))
    }
        
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: cvReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
    }
    
    func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DailyCell.self, forCellReuseIdentifier: tvReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 10
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .darkGray
        tableView.alpha = 0.85
        
        /*
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        */
    }
}

// MARK: - CoreLocation protocols

extension WeatherController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("U")
        if location == nil {
            location = locationManager.location
            fetchWeather()
        } else {
            locationManager.stopUpdatingLocation()
        }
        
        /*
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location!, preferredLocale: Locale(identifier: "ru-RU")) { placemarks, error in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            
            print(placemark.locality!)
        }
        */
    }
}



// MARK: - UICollectionView protocols

extension WeatherController: UICollectionViewDelegate {
    
}

extension WeatherController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherVM.numOfHours
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cvReuseIdentifier, for: indexPath) as! HourlyCell
        
        let height = collectionView.frame.height - 20
        cell.cellView.heightAnchor.constraint(equalToConstant: height - weatherVM.heightByTemperature[indexPath.row]).isActive = true
        
        cell.iconImageView.image = weatherVM.hourlyIconImage(indexPath.row)
        cell.temperatureLabel.text = weatherVM.hourlyTemperatures[indexPath.row]
        cell.hourLabel.text = weatherVM.hours[indexPath.row]
        return cell
    }
}

extension WeatherController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 7, height: collectionView.frame.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        // splace between two cell vertically
        return 10
    }
}

// MARK: - UITableView protocols

extension WeatherController: UITableViewDelegate {
    
}

extension WeatherController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherVM.numOfDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tvReuseIdentifier, for: indexPath) as! DailyCell
        
        cell.dayLabel.text = weatherVM.days[indexPath.row]
        cell.temperatureLabel.text = weatherVM.dailyTemperatures[indexPath.row]
        cell.iconImageView.image = weatherVM.dailyIconImage(indexPath.row)
        return cell
    }
}
