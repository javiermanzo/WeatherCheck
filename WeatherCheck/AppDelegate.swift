//
//  AppDelegate.swift
//  WeatherCheck
//
//  Created by Javier Manzo on 11/09/2024.
//

import UIKit
import WeatherData
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        WeatherData.setUpApiKey(Environment.apiKey)
        registerBackgroundFetch()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("\(Date()) perfom bg fetch")
        completionHandler(.newData)
    }

    func registerBackgroundFetch() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: NotificationsManager.taskIdentifier, using: nil) { task in
            if let task = task as? BGAppRefreshTask {
                NotificationsManager.shared.handleAppRefresh(task: task)
            }
        }
    }
}

