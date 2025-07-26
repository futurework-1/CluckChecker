import SwiftUI

/// Централизованная конфигурация приложения
///
/// Этот файл содержит все константы и настройки, которые используются
/// в приложении. Изменение значений здесь автоматически применяется
/// ко всем частям приложения.

struct AppConfig {
    /// Высота таббара
    static let tabbarHeight: CGFloat = 72
    /// Отступ таббара снизу
    static let tabbarBottomPadding: CGFloat = 26
    /// Отступ таббара по бокам
    static let tabbarHorizontalPadding: CGFloat = 44
}
