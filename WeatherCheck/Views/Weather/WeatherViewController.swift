//
//  WeatherViewController.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import WeatherData
import UIKit

class WeatherViewController: UIViewController {

    let viewModel: WeatherViewModel
    let tableView = UITableView()

    init(city: CityModel) {
        self.viewModel = WeatherViewModel(city: city)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.delegate = self

        tableView.register(DailyWeatherTableViewCell.self, forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        tableView.register(CurrentWeatherHeaderView.self, forHeaderFooterViewReuseIdentifier: CurrentWeatherHeaderView.identifier)
    }

    func setupViews() {
        view.backgroundColor = .systemBackground
        title = viewModel.city.name

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.city.weather?.daily?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherTableViewCell.identifier, for: indexPath) as? DailyWeatherTableViewCell,
              let dailyWeather = viewModel.city.weather?.daily?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: dailyWeather)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CurrentWeatherHeaderView.identifier) as? CurrentWeatherHeaderView,
              let currentWeather = viewModel.city.weather?.current else {
            return nil
        }
        header.configure(with: currentWeather)
        return header
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

