//
//  CityTableViewCell.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import UIKit
import RemoteImage

class CityTableViewCell: UITableViewCell {

    static let identifier = "CityTableViewCell"

    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()

    let cityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(cityNameLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(cityImageView)

        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cityNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            cityImageView.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor, constant: -10),
            cityImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cityImageView.widthAnchor.constraint(equalToConstant: 40),
            cityImageView.heightAnchor.constraint(equalToConstant: 40),

            cityNameLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            cityNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),

            cityImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            cityImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with city: CityModel) {
        cityNameLabel.text = city.name
        temperatureLabel.text = "\(city.weather?.current.temperature ?? 0)°C"

        if let urlString = city.weather?.current.details.first?.iconUrl,
           let url = URL(string: urlString) {
            Task {
                await cityImageView.setImage(from: url)
            }
        } else {
            cityImageView.image = nil
        }
    }
}
