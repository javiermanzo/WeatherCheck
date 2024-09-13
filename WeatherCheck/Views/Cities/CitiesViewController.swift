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

    private var emptyStateView: EmptyStateView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupViews()

        viewModel.fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCitiesWeather()
    }

    func setupViewModel() {
        viewModel.delegate = self
    }

    func setupViews() {
        view.backgroundColor = .systemBackground
        setupTableView()
        setupEmptyState()
        setupPullToRefresh()
        setupNavigationBar()
        updateEmptyState()
    }

    func setupEmptyState() {
        emptyStateView = EmptyStateView(
            title: "You have to add a city",
            buttonTitle: "Add",
            target: self,
            action: #selector(addCity)
        )
        guard let emptyStateView = emptyStateView else { return }
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        emptyStateView.isHidden = true
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

    func updateEmptyState() {
        if viewModel.currentCity == nil && viewModel.sortedCities.isEmpty {
            tableView.isHidden = true
            emptyStateView?.isHidden = false
        } else {
            tableView.isHidden = false
            emptyStateView?.isHidden = true
        }
    }
}

// MARK: - UITableViewDataSource
extension CitiesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }

        switch indexPath.section {
        case Section.currentCity:
            if let currentCity = viewModel.currentCity {
                cell.configure(with: currentCity)
            }
        case Section.cities:
            let city = viewModel.sortedCities[indexPath.row]
            cell.configure(with: city)
        default:
            return UITableViewCell()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && viewModel.currentCity != nil {
            return "Current City"
        } else if section == 1 && !viewModel.sortedCities.isEmpty {
            return "Cities"
        }
        return nil
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == Section.cities
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == Section.cities {
                tableView.beginUpdates()
                let city = viewModel.sortedCities[indexPath.row]

                tableView.deleteRows(at: [indexPath], with: .automatic)

                viewModel.removeCity(city)

                tableView.endUpdates()
            }
        }
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
        updateEmptyState()
    }
}
