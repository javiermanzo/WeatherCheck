//
//  AddCityViewController.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import UIKit
import MapKit

class AddCityViewController: UIViewController {

    private let viewModel: AddCityViewModel
    private let mapView = MKMapView()
    private let bottomView = UIView()
    private let cityNameLabel = UILabel()
    private let addButton = UIButton(type: .system)
    private let centerIconImageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))

    init(delegate: AddCityDelegate?) {
        self.viewModel = AddCityViewModel(delegate: delegate)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupMapView()
        setupCenterIcon()
        setupBottomView()
        setupCityNameLabel()
        setupAddButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moveToCurrentLocation()
    }

    private func setupNavigationBar() {
        title = "Add a City"

        let locationButton = UIBarButtonItem(image: UIImage(systemName: "location.fill"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(moveToCurrentLocation))
        locationButton.isHidden = true
        navigationItem.rightBarButtonItem = locationButton

        Task {
            let locationEnabled = await viewModel.checkLocationEnabled()
            await MainActor.run {
                locationButton.isHidden = !locationEnabled
            }
        }

        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = closeButton
    }

    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func moveToCurrentLocation() {
        Task {
            guard let currentLocation = await viewModel.getCurrentLocation() else { return }

            let coordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            await MainActor.run {
                mapView.setRegion(region, animated: true)
            }
        }
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupCenterIcon() {
        centerIconImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerIconImageView)

        NSLayoutConstraint.activate([
            centerIconImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            centerIconImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            centerIconImageView.widthAnchor.constraint(equalToConstant: 40),
            centerIconImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupBottomView() {
        bottomView.backgroundColor = .systemGray6
        bottomView.layer.cornerRadius = 16
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)

        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func setupCityNameLabel() {
        cityNameLabel.textAlignment = .center
        cityNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(cityNameLabel)

        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            cityNameLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            cityNameLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10)
        ])
    }

    private func setupAddButton() {
        addButton.setTitle("Add City", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.addTarget(self, action: #selector(addCityTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            addButton.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 10),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func addCityTapped() {
        if viewModel.addCity() {
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - MKMapViewDelegate
extension AddCityViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerCoordinate = mapView.centerCoordinate
        updateCityNameForCoordinate(centerCoordinate)
    }

    private func updateCityNameForCoordinate(_ coordinate: CLLocationCoordinate2D) {
        Task {
            if let location = await viewModel.getLocationData(coordinate: coordinate) {

                var name: String = "Unknown location"

                if let cityName = location.name {
                    name = cityName
                }

                await MainActor.run {
                    cityNameLabel.text = name
                }
            }
        }
    }
}
