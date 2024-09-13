//
//  CurrentWeatherHeaderView.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 13/09/2024.
//

import UIKit
import WeatherData

class CurrentWeatherHeaderView: UITableViewHeaderFooterView {

    static let identifier = "CurrentWeatherHeaderView"

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: WeatherModel) {
        temperatureLabel.text = "\(model.temperature)°C"
        weatherDescriptionLabel.text = model.details.first?.description.capitalized

        if let url = URL(string: model.details.first?.iconUrl ?? "") {
            downloadImage(from: url) { [weak self] image in
                self?.weatherIcon.image = image
            }
        }
    }

    private func setupViews() {
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherDescriptionLabel)
        contentView.addSubview(weatherIcon)

        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            weatherDescriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 8),
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            weatherIcon.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 8),
            weatherIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherIcon.heightAnchor.constraint(equalToConstant: 80),
            weatherIcon.widthAnchor.constraint(equalToConstant: 80),
            weatherIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
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
