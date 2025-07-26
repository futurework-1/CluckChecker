import Foundation
import SwiftUI

/// Управляет маршрутами экранов приложения.
/// Отвечает за навигацию между основными экранами и вкладками.

final class AppRouter: ObservableObject {
    /// Текущий основной экран приложения
    @Published var currentMainScreen: AppMainScreen = .splash
    
    /// Стек экранов вкладки "shops"
    @Published var shopsRoute: [ShopsScreen] = []
    
    /// Стек экранов вкладки "articles"
    @Published var articlesRoute: [ArticlesScreen] = []
    
    /// Стек экранов вкладки "menu"
    @Published var menuRoute: [MenuScreen] = []
    
    /// Стек экранов вкладки "financial"
    @Published var financialRoute: [FinancialScreen] = []
    
    /// Стек экранов вкладки "settings"
    @Published var settingsRoute: [SettingsScreen] = []
    
    /// Флаг для переключения экрана
    @Published var showMainScreen: Bool = false
}

// MARK: - Основные экраны приложения

/// Основные экраны приложения.
/// Определяет глобальную навигацию между основными разделами.
enum AppMainScreen {
    case splash        // Экран загрузки приложения
    case tabbar        // Главный экран с табами
}

// MARK: - Экраны вкладки "shops"

/// Экраны вкладки "shops".
enum ShopsScreen: Hashable {
    case main
    case addEntry
    case typeDetail(ShopType)
    case entryDetail(UUID)
    case editEntry
}

// MARK: - Экраны вкладки "articles"

/// Экраны вкладки "articles".
enum ArticlesScreen: Hashable {
    case main
    case detail
}

// MARK: - Экраны вкладки "menu"

/// Экраны вкладки "menu".
enum MenuScreen: Hashable {
    case main
    case addEvent
    case editEvent
    case addNotification
    case editNotification
}

// MARK: - Экраны вкладки "financial"

/// Экраны вкладки "financial".
enum FinancialScreen {
    case main
    case first
    case second
}

// MARK: - Экраны вкладки "settings"

/// Экраны вкладки "settings".
enum SettingsScreen {
    case main
    case unit
    case curreency
}

// MARK: - Вкладки приложения с индексами

/// Вкладки приложения с индексами.
/// Определяет порядок и индексы вкладок в TabBar.
enum AppTabScreen {
    case shops
    case articles
    case menu
    case financial
    case settings
    
    /// Индекс для выбранной вкладки.
    var selectedTabScreenIndex: Int {
        switch self {
        case .shops:
            return 0
        case .articles:
            return 1
        case .menu:
            return 2
        case .financial:
            return 3
        case .settings:
            return 4
        }
    }
}
