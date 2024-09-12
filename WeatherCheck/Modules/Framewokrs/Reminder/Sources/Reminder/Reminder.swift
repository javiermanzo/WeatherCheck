//
//  Reminder.swift
//
//
//  Created by Javier Manzo on 11/09/2024.
//

import Foundation
import EventKit
import UserNotifications

public final class Reminder {

    public static func checkCalendarAuthorizationStatus(requestIfPending: Bool = true) async -> Result<EKAuthorizationStatus, Error> {
        let status = EKEventStore.authorizationStatus(for: .event)

        if requestIfPending, status == .notDetermined {
            return await withCheckedContinuation { continuation in
                EKEventStore().requestAccess(to: .event) { _, error in
                    if let error = error {
                        continuation.resume(returning: .failure(error))
                    } else {
                        continuation.resume(returning: .success(EKEventStore.authorizationStatus(for: .event)))
                    }
                }
            }
        }

        return .success(status)
    }

    public static func createCalendarEvent(eventTitle: String, hour: Int, minute: Int, durationInMinutes: Double, daily: Bool) throws {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.title = eventTitle

        let calendar = Calendar.current
        var startDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        startDateComponents.hour = hour
        startDateComponents.minute = minute

        if let startDate = calendar.date(from: startDateComponents) {
            event.startDate = startDate
            event.endDate = startDate.addingTimeInterval(60 * durationInMinutes)
        }

        if daily {
            let recurrenceRule = EKRecurrenceRule(
                recurrenceWith: .daily,
                interval: 1,
                end: nil
            )
            event.addRecurrenceRule(recurrenceRule)
        }

        event.calendar = eventStore.defaultCalendarForNewEvents

        try eventStore.save(event, span: .futureEvents)
    }

    public static func checkNotificationsAuthorizationStatus(requestIfPending: Bool = true) async -> Result<UNAuthorizationStatus, Error> {
        let currentSettings = await UNUserNotificationCenter.current().notificationSettings()
        
        if requestIfPending,
            currentSettings.authorizationStatus == .notDetermined {
            return await withCheckedContinuation { continuation in
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if let error = error {
                        continuation.resume(returning: .failure(error))
                    } else {
                        let status: UNAuthorizationStatus = granted ? .authorized : .denied
                        continuation.resume(returning: .success(status))
                    }
                }
            }
        }

        return .success(currentSettings.authorizationStatus)
    }

    public static func scheduleLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling the notification: \(error)")
            }
        }
    }
}
