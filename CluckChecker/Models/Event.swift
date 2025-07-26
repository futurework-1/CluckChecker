import Foundation

/// Тип события в приложении
enum EventType: String, CaseIterable, Codable {
    case eggs = "eggs"
    case hens = "hens"
    
    var title: String {
        switch self {
        case .eggs: return "Eggs"
        case .hens: return "Hens"
        }
    }
    
    var iconName: String {
        switch self {
        case .eggs: return "eggImage"
        case .hens: return "henImage"
        }
    }
}

/// Модель события (яйца или куры)
struct Event: Codable, Identifiable {
    let id: UUID
    let type: EventType
    var count: Int
    let dateCreated: Date
    
    init(type: EventType, count: Int) {
        self.id = UUID()
        self.type = type
        self.count = count
        self.dateCreated = Date()
    }
}
