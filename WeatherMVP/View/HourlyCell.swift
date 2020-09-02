//
//  HourlyCell.swift
//  WeatherMVP
//
//  Created by Ivan Volokitin on 24.08.2020.
//  Copyright © 2020 Ivan Volokitin. All rights reserved.
//

import UIKit

class HourlyCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    lazy var cellView: UIView = {
        let view = UIView()
        // view.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.85)
        view.backgroundColor = .darkGray
        view.alpha = 0.85
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "smoke.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        // imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // lazy var dynamicHeightAnchor: CGFloat = 100
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        // alpha = 0.85
        // contentView.alpha = 0.2
        
        layer.cornerRadius = 10
        addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor),
            // cellView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let cellStackView = UIStackView(arrangedSubviews: [iconImageView, temperatureLabel, hourLabel])
        cellStackView.axis = .vertical
        cellStackView.spacing = 0
        // cellStackView.backgroundColor = .systemBlue
        
        cellView.addSubview(cellStackView)
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // iconImageView.heightAnchor.constraint(equalToConstant: 30),
            cellStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            cellStackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8),
            cellStackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -8),
            cellStackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -8)
        ])
    }
}
