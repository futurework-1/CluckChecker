import Foundation
import SwiftUI

/// ViewModel для управления состоянием Shops модуля
final class ShopsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Статистика по всем типам магазинов
    @Published var shopTypeStats: [ShopTypeStats] = []
    
    /// Все записи магазинов
    @Published var allEntries: [ShopEntry] = []
    
    /// Записи для выбранного типа магазина
    @Published var entriesForSelectedType: [ShopEntry] = []
    
    /// Выбранный тип магазина для детального просмотра
    @Published var selectedShopType: ShopType?
    
    /// Редактируемая запись
    @Published var editingEntry: ShopEntry?
    
    // MARK: - Private Properties
    
    private let dataService = UserDefaultsService.shared
    
    // MARK: - Public Methods
    
    /// Загружает все данные
    func loadAllData() {
        allEntries = dataService.getAllShopEntries()
        shopTypeStats = dataService.getAllShopTypeStats()
    }
    
    /// Загружает записи для конкретного типа магазина
    func loadEntries(for type: ShopType) {
        selectedShopType = type
        entriesForSelectedType = dataService.getShopEntries(for: type)
    }
    
    /// Добавляет новую запись
    func addEntry(_ entry: ShopEntry) {
        dataService.addShopEntry(entry)
        loadAllData()
        
        // Обновляем список для выбранного типа если он совпадает
        if let selectedType = selectedShopType, selectedType == entry.type {
            loadEntries(for: selectedType)
        }
    }
    
    /// Обновляет существующую запись
    func updateEntry(_ entry: ShopEntry) {
        dataService.updateShopEntry(entry)
        loadAllData()
        
        // Обновляем список для выбранного типа если он совпадает
        if let selectedType = selectedShopType, selectedType == entry.type {
            loadEntries(for: selectedType)
        }
    }
    
    /// Удаляет запись
    func deleteEntry(withId id: UUID) {
        dataService.removeShopEntry(withId: id)
        loadAllData()
        
        // Обновляем список для выбранного типа
        if let selectedType = selectedShopType {
            loadEntries(for: selectedType)
        }
    }
    
    /// Подготавливает данные для добавления новой записи
    func prepareForAddEntry() {
        editingEntry = nil
    }
    
    /// Подготавливает данные для редактирования записи
    func prepareForEditEntry(_ entry: ShopEntry) {
        editingEntry = entry
    }
    
    /// Очищает состояние редактирования
    func clearEditingState() {
        editingEntry = nil
    }
    
    /// Получает запись по ID
    func getEntry(withId id: UUID) -> ShopEntry? {
        return allEntries.first { $0.id == id }
    }
    
    // MARK: - Helper Methods
    
    /// Форматирует дату в строку
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    /// Получает статистику для конкретного типа
    func getStats(for type: ShopType) -> ShopTypeStats {
        return shopTypeStats.first { $0.type == type } ?? ShopTypeStats(type: type)
    }
}
