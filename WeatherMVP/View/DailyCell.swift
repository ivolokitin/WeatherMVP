//
//  DailyCell.swift
//  WeatherMVP
//
//  Created by Ivan Volokitin on 26.08.2020.
//  Copyright © 2020 Ivan Volokitin. All rights reserved.
//

import UIKit

class DailyCell: UITableViewCell {
    
    // MARK: - Properties
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        return label
    }()

    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .darkGray
        alpha = 0.85
        contentView.alpha = 0.2

        addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        let temperatureStackView = UIStackView(arrangedSubviews: [temperatureLabel, iconImageView])
        temperatureStackView.axis = .horizontal
        temperatureStackView.spacing = 4
        
        addSubview(temperatureStackView)
        temperatureStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureStackView.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            temperatureStackView.leadingAnchor.constraint(greaterThanOrEqualTo: dayLabel.trailingAnchor),
            temperatureStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            temperatureLabel.widthAnchor.constraint(equalToConstant: 50),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
