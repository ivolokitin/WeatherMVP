//
//  CurrentWeatherView.swift
//  WeatherMVP
//
//  Created by Ivan Volokitin on 24.08.2020.
//  Copyright © 2020 Ivan Volokitin. All rights reserved.
//

import UIKit

class CurrentWeatherView: UIView {
    
    // MARK: - Properties
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 80, weight: .regular)
        label.textColor = .white
        label.layer.shadow()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage().withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.shadow()
        return imageView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.shadow()
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .clear

        let descriptionStackView = UIStackView(arrangedSubviews: [weatherIcon, descriptionLabel])
        descriptionStackView.axis = .horizontal
        descriptionStackView.spacing = 10
        
        let weatherStackView = UIStackView(arrangedSubviews: [descriptionStackView, temperatureLabel])
        weatherStackView.axis = .vertical
        weatherStackView.spacing = 10

        addSubview(weatherStackView)
        weatherStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // descriptionStackView.widthAnchor.constraint(equalTo: widthAnchor),
            // descriptionLabel.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 5),
            weatherStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            weatherStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            weatherIcon.widthAnchor.constraint(equalToConstant: 50),
            weatherIcon.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
