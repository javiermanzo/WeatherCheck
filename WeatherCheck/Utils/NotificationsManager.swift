//
//  NotificationsManager.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 12/09/2024.
//

import Foundation
import BackgroundTasks
import Reminder

class NotificationsManager {

    static let shared = NotificationsManager()

    static let taskIdentifier: String = "com.javiermanzo.WeatherCheckFetch"

    private init() { }

    func checkNotificationPermission(requestIfPending: Bool = false) async -> Bool {
        let response = await Reminder.checkNotificationsAuthorizationStatus(requestIfPending: requestIfPending)

        switch response {
        case .success(let status):
            if status == .authorized {
                return true
            }
            return false
        default:
            return false
        }
    }

    func scheduleAppRefresh() async {
        if await checkNotificationPermission() {
            let request = BGAppRefreshTaskRequest(identifier: Self.taskIdentifier)
            request.earliestBeginDate = Date(timeIntervalSinceNow: 21600) // Every 6 hours

            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Error scheduling the background refresh task: \(error)")
            }
        }
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        let operationQueue = OperationQueue()
        let operation = WeatherUpdateOperation()

        task.expirationHandler = {
            operation.cancel()
        }

        operation.completionBlock = {
            task.setTaskCompleted(success: !operation.isCancelled)
        }

        operationQueue.addOperation(operation)

        Task {
            await scheduleAppRefresh()
        }
    }

    func compareWeatherValues() {
        Task {
            guard await checkNotificationPermission() else { return }

            let repository = WeatherRepository()
            let savedCities = repository.fetchSavedCities()

            for city in savedCities {
                requestAndCheck(city: city)
            }
        }
    }

    private func requestAndCheck(city: CityModel) {
        Task {
            guard let savedWeather = city.weather else { return }
            let repository = WeatherRepository()

            let response = await repository.requestWeather(latitude: city.latitude, longitude: city.longitude)

            switch response {
            case .success(let result):
                let difference = abs(savedWeather.current.temperature - result.current.temperature)

                if difference > 5 {
                    await MainActor.run {
                        Reminder.scheduleLocalNotification(title: "Weather Change Detected", body: "The weather has changed significantly in \(city.name). Check the app for more details!")
                    }
                }
            default:
                break
            }
        }
    }
}

class WeatherUpdateOperation: Operation {
    override func main() {
        if isCancelled {
            return
        }

        NotificationsManager.shared.compareWeatherValues()
    }
}
