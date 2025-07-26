import Foundation
import SwiftUI

/// ViewModel для управления состоянием Menu экрана
final class MenuViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Выбранная дата
    @Published var selectedDate = Date()
    
    /// Данные для выбранной даты
    @Published var dateData = DateData()
    
    /// Флаг показа селектора даты
    @Published var isDatePickerVisible = false
    
    /// Редактируемое событие
    @Published var editingEvent: Event?
    
    /// Редактируемое напоминание
    @Published var editingNotification: Notification?
    
    // MARK: - Private Properties
    
    private let dataService = UserDefaultsService.shared
    
    // MARK: - Public Methods
    
    /// Загружает данные для выбранной даты
    func loadDataForDate() {
        dateData = dataService.loadDataForDate(selectedDate)
    }
    
    /// Устанавливает выбранную дату и загружает данные
    func setSelectedDate(_ date: Date) {
        selectedDate = date
        loadDataForDate()
    }
    
    /// Подготавливает данные для добавления события
    func prepareForAddEvent() {
        editingEvent = nil
    }
    
    /// Подготавливает данные для редактирования события
    func prepareForEditEvent(_ event: Event) {
        editingEvent = event
    }
    
    /// Подготавливает данные для добавления напоминания
    func prepareForAddNotification() {
        editingNotification = nil
    }
    
    /// Подготавливает данные для редактирования напоминания
    func prepareForEditNotification(_ notification: Notification) {
        editingNotification = notification
    }
    
    /// Очищает состояние редактирования
    func clearEditingState() {
        editingEvent = nil
        editingNotification = nil
    }
    
    // MARK: - Helper Methods
    
    /// Форматирует дату в строку
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    /// Форматирует время в строку
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
