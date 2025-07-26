import Foundation

/// Тип магазина
enum ShopType: String, CaseIterable, Codable {
    case shop = "shop"
    case online = "online"
    case market = "market"
    
    var title: String {
        switch self {
        case .shop: return "SHOP"
        case .online: return "ONLINE"
        case .market: return "MARKET"
        }
    }
    
    var iconName: String {
        switch self {
        case .shop: return "shop2"
        case .online: return "online"
        case .market: return "market"
        }
    }
}

/// Модель записи точки продаж
struct ShopEntry: Codable, Identifiable {
    let id: UUID
    var name: String
    var eggsStock: Int      // Яйца в наличии
    var eggsSold: Int       // Яйца проданы
    var chickensStock: Int  // Цыплята в наличии
    var chickensSold: Int   // Цыплята проданы
    let type: ShopType
    let dateCreated: Date
    
    init(name: String, eggsStock: Int, eggsSold: Int, chickensStock: Int, chickensSold: Int, type: ShopType) {
        self.id = UUID()
        self.name = name
        self.eggsStock = eggsStock
        self.eggsSold = eggsSold
        self.chickensStock = chickensStock
        self.chickensSold = chickensSold
        self.type = type
        self.dateCreated = Date()
    }
    
    /// Инициализатор для обновления существующей записи (сохраняет ID и дату создания)
    init(updating original: ShopEntry, name: String, eggsStock: Int, eggsSold: Int, chickensStock: Int, chickensSold: Int) {
        self.id = original.id
        self.name = name
        self.eggsStock = eggsStock
        self.eggsSold = eggsSold
        self.chickensStock = chickensStock
        self.chickensSold = chickensSold
        self.type = original.type
        self.dateCreated = original.dateCreated
    }
    
    /// Общее количество доступных яиц (Stock - Sold)
    var availableEggs: Int {
        return max(0, eggsStock - eggsSold)
    }
    
    /// Общее количество доступных цыплят (Stock - Sold)
    var availableChickens: Int {
        return max(0, chickensStock - chickensSold)
    }
}

/// Агрегированная статистика по типу магазина
struct ShopTypeStats {
    let type: ShopType
    var totalAvailableEggs: Int
    var totalAvailableChickens: Int
    var entriesCount: Int
    
    init(type: ShopType) {
        self.type = type
        self.totalAvailableEggs = 0
        self.totalAvailableChickens = 0
        self.entriesCount = 0
    }
}
