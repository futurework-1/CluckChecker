import Foundation

// MARK: - UserDefaults Service

/// Сервис для работы с UserDefaults
final class UserDefaultsService {
    static let shared = UserDefaultsService()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Private Keys
    private enum Keys {
        static let menuData = "menu_data"
        static let shopsData = "shops_data"
        static let financialData = "financial_data"
    }
    
    // MARK: - Public Methods
    
    /// Сохраняет данные для конкретной даты
    func saveDataForDate(_ date: Date, data: DateData) {
        let dateKey = dateToString(date)
        var allData = loadAllData()
        allData[dateKey] = data
        saveAllData(allData)
        
    }
    
    /// Загружает данные для конкретной даты
    func loadDataForDate(_ date: Date) -> DateData {
        let dateKey = dateToString(date)
        let allData = loadAllData()
        return allData[dateKey] ?? DateData()
    }
    
    /// Добавляет событие к дате
    func addEvent(_ event: Event, to date: Date) {
        var dateData = loadDataForDate(date)
        
        // Проверяем, есть ли уже событие этого типа
        if let existingIndex = dateData.events.firstIndex(where: { $0.type == event.type }) {
            dateData.events[existingIndex].count = event.count
        } else {
            dateData.events.append(event)
        }
        
        saveDataForDate(date, data: dateData)
    }
    
    /// Добавляет напоминание к дате
    func addNotification(_ notification: Notification, to date: Date) {
        var dateData = loadDataForDate(date)
        dateData.notifications.append(notification)
        saveDataForDate(date, data: dateData)
    }
    
    /// Удаляет событие
    func removeEvent(withId id: UUID, from date: Date) {
        var dateData = loadDataForDate(date)
        dateData.events.removeAll { $0.id == id }
        saveDataForDate(date, data: dateData)
    }
    
    /// Удаляет напоминание
    func removeNotification(withId id: UUID, from date: Date) {
        var dateData = loadDataForDate(date)
        dateData.notifications.removeAll { $0.id == id }
        saveDataForDate(date, data: dateData)
    }
    
    /// Получает событие определенного типа для даты
    func getEvent(type: EventType, for date: Date) -> Event? {
        let dateData = loadDataForDate(date)
        return dateData.events.first { $0.type == type }
    }
    
    // MARK: - Private Methods
    
    private func loadAllData() -> [String: DateData] {
        guard let data = userDefaults.data(forKey: Keys.menuData),
              let decoded = try? JSONDecoder().decode([String: DateData].self, from: data) else {
            return [:]
        }
        return decoded
    }
    
    private func saveAllData(_ data: [String: DateData]) {
        if let encoded = try? JSONEncoder().encode(data) {
            userDefaults.set(encoded, forKey: Keys.menuData)
        }
    }
    
    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Shops Data Management

extension UserDefaultsService {
    
    /// Сохраняет все записи магазинов
    private func saveAllShops(_ shops: [ShopEntry]) {
        if let data = try? JSONEncoder().encode(shops) {
            userDefaults.set(data, forKey: Keys.shopsData)
        }
    }
    
    /// Загружает все записи магазинов
    private func loadAllShops() -> [ShopEntry] {
        guard let data = userDefaults.data(forKey: Keys.shopsData),
              let shops = try? JSONDecoder().decode([ShopEntry].self, from: data) else {
            return []
        }
        return shops
    }
    
    /// Добавляет новую запись магазина
    func addShopEntry(_ entry: ShopEntry) {
        var shops = loadAllShops()
        shops.append(entry)
        saveAllShops(shops)
    }
    
    /// Обновляет существующую запись магазина
    func updateShopEntry(_ entry: ShopEntry) {
        var shops = loadAllShops()
        if let index = shops.firstIndex(where: { $0.id == entry.id }) {
            shops[index] = entry
            saveAllShops(shops)
        }
    }
    
    /// Удаляет запись магазина
    func removeShopEntry(withId id: UUID) {
        var shops = loadAllShops()
        shops.removeAll { $0.id == id }
        saveAllShops(shops)
    }
    
    /// Загружает все записи магазинов
    func getAllShopEntries() -> [ShopEntry] {
        return loadAllShops()
    }
    
    /// Загружает записи магазинов по типу
    func getShopEntries(for type: ShopType) -> [ShopEntry] {
        return loadAllShops().filter { $0.type == type }
    }
    
    /// Получает статистику по типу магазина
    func getShopTypeStats(for type: ShopType) -> ShopTypeStats {
        let entries = getShopEntries(for: type)
        var stats = ShopTypeStats(type: type)
        
        for entry in entries {
            stats.totalAvailableEggs += entry.availableEggs
            stats.totalAvailableChickens += entry.availableChickens
        }
        
        stats.entriesCount = entries.count
        return stats
    }
    
    /// Получает статистику по всем типам магазинов
    func getAllShopTypeStats() -> [ShopTypeStats] {
        return ShopType.allCases.map { getShopTypeStats(for: $0) }
    }
    
    /// Получает запись магазина по ID
    func getShopEntry(withId id: UUID) -> ShopEntry? {
        return loadAllShops().first { $0.id == id }
    }
}

// MARK: - Financial Data Management

extension UserDefaultsService {
    /// Сохраняет все финансовые записи
    private func saveAllFinancial(_ financials: [Financial]) {
        if let data = try? JSONEncoder().encode(financials) {
            userDefaults.set(data, forKey: Keys.financialData)
        }
    }

    /// Загружает все финансовые записи
    private func loadAllFinancial() -> [Financial] {
        guard let data = userDefaults.data(forKey: Keys.financialData),
              let financials = try? JSONDecoder().decode([Financial].self, from: data) else {
            return []
        }
        return financials
    }

    /// Добавляет новую финансовую запись
    func addFinancialEntry(_ entry: Financial) {
        var financials = loadAllFinancial()
        financials.append(entry)
        saveAllFinancial(financials)
    }

    /// Загружает все финансовые записи
    func getAllFinancialEntries() -> [Financial] {
        return loadAllFinancial()
    }
}
