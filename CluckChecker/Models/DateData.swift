import Foundation

/// Модель данных для конкретной даты
struct DateData: Codable {
    var events: [Event]
    var notifications: [Notification]
    
    init() {
        self.events = []
        self.notifications = []
    }
}
