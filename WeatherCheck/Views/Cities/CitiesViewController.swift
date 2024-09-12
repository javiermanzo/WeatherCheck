//
//  CitiesViewController.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import UIKit
import LocationData

class CitiesViewController: UIViewController {

    let tableView = UITableView()
    let viewModel = CitiesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadCitiesData()
    }

    func setupViewModel() {
        viewModel.delegate = self
    }

    func setupViews() {
        setupTableView()
        setupNavigationBar()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupNavigationBar() {
        title = "Weather Check"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add City", style: .plain, target: self, action: #selector(addCity))
    }

    @objc func addCity() {
        // Handle adding city
        print("Add city tapped")
    }

    func loadCitiesData() {
        viewModel.getCurrentCity()
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
            cell.configure(with: currentCity, temperature: "22°C", image: UIImage(systemName: "sun.max"))
        } else {
            let city = viewModel.sortedCities[indexPath.row]
            cell.configure(with: city, temperature: "25°C", image: UIImage(systemName: "sun.max"))
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
        if indexPath.section == 0, let currentCity = viewModel.currentCity {
            print("Selected current city: \(currentCity.name)")

        } else {
            let city = viewModel.sortedCities[indexPath.row]
            print("Selected city: \(city.name)")

        }
    }
}

// MARK: - CitiesViewModelDelegate
extension CitiesViewController: CitiesViewModelDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}
