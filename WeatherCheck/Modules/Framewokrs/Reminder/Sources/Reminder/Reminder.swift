//
//  Reminder.swift
//
//
//  Created by Javier Manzo on 11/09/2024.
//

import Foundation
import EventKit

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
}
