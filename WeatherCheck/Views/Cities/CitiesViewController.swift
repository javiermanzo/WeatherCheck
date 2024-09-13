//
//  CitiesViewController.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import UIKit
import LocationData
import WeatherData

class CitiesViewController: UIViewController {

    private let viewModel = CitiesViewModel()

    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
        updateCitiesWeather()
    }

    func setupViewModel() {
        viewModel.delegate = self
    }

    func setupViews() {
        setupTableView()
        setupPullToRefresh()
        setupNavigationBar()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupPullToRefresh() {
        refreshControl.addTarget(self, action: #selector(updateCitiesWeather), for: .valueChanged)
    }

    func setupNavigationBar() {
        title = "Weather Check"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add City", style: .plain, target: self, action: #selector(addCity))
    }

    @objc func addCity() {
        let addCityVC = AddCityViewController(delegate: viewModel)
        let navigationController = UINavigationController(rootViewController: addCityVC)
        navigationController.setStyle()
        self.present(navigationController, animated: true)
    }

    @objc func updateCitiesWeather() {
        viewModel.updateCitiesWeather()
        refreshControl.endRefreshing()
    }
}

// MARK: - UITableViewDataSource
extension CitiesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.currentCity != nil ? 1 : 0
        case 1:
            return viewModel.sortedCities.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }

        if indexPath.section == 0, let currentCity = viewModel.currentCity {
            cell.configure(with: currentCity)
        } else {
            let city = viewModel.sortedCities[indexPath.row]
            cell.configure(with: city)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && viewModel.currentCity != nil {
            return "Current City"
        } else if section == 1 {
            return "Cities"
        }
        return nil
    }
}

// MARK: - UITableViewDelegate
extension CitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let city: CityModel
        if indexPath.section == 0, let currentCity = viewModel.currentCity {
            city = currentCity
        } else {
            city = viewModel.sortedCities[indexPath.row]
        }

        let vc = WeatherViewController(city: city)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CitiesViewModelDelegate
extension CitiesViewController: CitiesViewModelDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}
