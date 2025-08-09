import SwiftUI
import UserNotifications

final class LocalPushService {
    
    static let shared = LocalPushService()
    
    private init() {}

    private let reminderIdentifier = "daily.cluck.reminder"
    
    @discardableResult
    func requestAuthorization(options: UNAuthorizationOptions = [.alert, .sound, .badge]) async throws -> Bool {
        let center = UNUserNotificationCenter.current()

        let granted: Bool = try await withCheckedThrowingContinuation { continuation in
            center.requestAuthorization(options: options) { granted, error in
                if let error = error {
                    continuation.resume(throwing: LocalPushError.underlying(error))
                } else {
                    continuation.resume(returning: granted)
                }
            }
        }
        return granted
    }

    func currentAuthorizationStatus() async -> UNAuthorizationStatus {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings.authorizationStatus)
            }
        }
    }

    func createDailyNoonReminder() async throws {
        let status = await currentAuthorizationStatus()
        guard status == .authorized || status == .provisional || status == .ephemeral else {
            throw LocalPushError.notAuthorized
        }
        
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])
        center.removeDeliveredNotifications(withIdentifiers: [reminderIdentifier])
        
        let content = UNMutableNotificationContent()
        content.title = "It's time to check your cluck!"
        content.body = "Open to check"
        content.sound = .default
        
        var components = DateComponents()
        components.calendar = Calendar.current
        components.timeZone = TimeZone.current
        components.hour = 12
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: reminderIdentifier,
            content: content,
            trigger: trigger
        )
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            center.add(request) { error in
                error.map { continuation.resume(throwing: LocalPushError.underlying($0)) }
                ?? continuation.resume()
            }
        }
    }

    func removeDailyNoonReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])
        center.removeDeliveredNotifications(withIdentifiers: [reminderIdentifier])
    }
}
