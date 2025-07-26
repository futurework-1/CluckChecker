import Foundation

/// Модель напоминания
struct Notification: Codable, Identifiable {
    let id: UUID
    var name: String
    var date: Date
    var time: Date
    let dateCreated: Date
    
    init(name: String, date: Date, time: Date) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.time = time
        self.dateCreated = Date()
    }
}
