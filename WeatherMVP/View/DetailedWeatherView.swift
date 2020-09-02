//
//  DetailedWeatherView.swift
//  WeatherMVP
//
//  Created by Ivan Volokitin on 27.08.2020.
//  Copyright © 2020 Ivan Volokitin. All rights reserved.
//

import UIKit

class DetailedWeatherView: UIView {
    
    // MARK: - Properties
    
    lazy var windBlockView = BlockView(imageName: "wind")
    
    lazy var pressureBlockView = BlockView(imageName: "pressure")
    
    lazy var humidityBlockView = BlockView(imageName: "humidity")
    
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
        backgroundColor = .darkGray
        alpha = 0.85
        layer.cornerRadius = 10
        
        let stackView = UIStackView(arrangedSubviews: [windBlockView, pressureBlockView, humidityBlockView])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        // stackView.alignment = .fill
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            // stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
}

class BlockView: UIView {
    
    // MARK: - Properties
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        return imageView
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var directionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location.north.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    init(imageName: String) {
        super.init(frame: .zero)
        
        configureUI()
        iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        if imageName == "wind" { addDirectionImage() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
                
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(greaterThanOrEqualTo: iconImageView.bottomAnchor, constant: 10),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        /*
        let stackView = UIStackView(arrangedSubviews: [iconImageView, valueLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // iconImageView.widthAnchor.constraint(equalToConstant: 50),
            // iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        */
    }
    
    func addDirectionImage() {
        addSubview(directionImageView)
        directionImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            directionImageView.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor),
            directionImageView.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor),
            
            directionImageView.widthAnchor.constraint(equalToConstant: 20),
            directionImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
