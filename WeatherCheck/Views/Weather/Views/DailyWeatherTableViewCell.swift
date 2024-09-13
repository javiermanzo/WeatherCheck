//
//  DailyWeatherTableViewCell.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 13/09/2024.
//

import UIKit
import WeatherData

class DailyWeatherTableViewCell: UITableViewCell {

    static let identifier = "DailyWeatherCell"

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: WeatherDailyModel) {
        let date = Date(timeIntervalSince1970: TimeInterval(model.date))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        dayLabel.text = formatter.string(from: date)

        temperatureLabel.text = "Min: \(model.temperature.min)°C, Max: \(model.temperature.max)°C"

        // Descargar la imagen desde la URL
        if let url = URL(string: model.details.first?.iconUrl ?? "") {
            downloadImage(from: url) { [weak self] image in
                self?.weatherIcon.image = image
            }
        }
    }

    private func setupViews() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherIcon)

        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            weatherIcon.widthAnchor.constraint(equalToConstant: 40),
            weatherIcon.heightAnchor.constraint(equalToConstant: 40),
            weatherIcon.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor, constant: -8),
            weatherIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }.resume()
    }
}
