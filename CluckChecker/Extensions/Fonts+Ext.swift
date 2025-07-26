import SwiftUI

/// Перечисление доступных стилей шрифта Poppins
/// Используется для унификации названий шрифтов в приложении
enum PoppinsEnum: String {
    case regular = "Poppins-Regular"
    case thin = "Poppins-Thin"
    case extraLight = "Poppins-ExtraLight"
    case light = "Poppins-Light"
    case medium = "Poppins-Medium"
    case semiBold = "Poppins-SemiBold"
    case bold = "Poppins-Bold"
    case extraBold = "Poppins-ExtraBold"
    case black = "Poppins-Black"
}

extension Font {
    /// Создает кастомный шрифт Poppins с указанным стилем и размером
    /// - Parameters:
    ///   - font: Стиль шрифта из перечисления PoppinsFont
    ///   - size: Размер шрифта в пунктах
    /// - Returns: Настроенный шрифт SwiftUI
    static func customFont(font: PoppinsEnum, size: CGFloat) -> SwiftUI.Font {
        .custom(font.rawValue, size: size)
    }
}
