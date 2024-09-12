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
            request.earliestBeginDate = Date(timeIntervalSinceNow: 3600) // Each hour

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
            if await checkNotificationPermission() {

                // TODO: Handle weather check
                if true {
                    await MainActor.run {
                        Reminder.scheduleLocalNotification(title: "Weather Change Detected", body: "The weather has changed significantly. Check the app for more details!")
                    }
                }
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
