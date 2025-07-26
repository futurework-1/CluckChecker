import Foundation
import Combine

class FinancialViewModel: ObservableObject {
    @Published private(set) var financials: [Financial] = []
    private let userDefaultsService = UserDefaultsService.shared
    
    init() {
        loadFinancials()
    }
    
    /// Добавляет новую финансовую запись
    func addFinancial(price: Int, sold: Int) {
        let sum = price * sold
        let entry = Financial(sum: sum, date: Date())
        userDefaultsService.addFinancialEntry(entry)
        loadFinancials()
    }
    
    /// Загружает все финансовые записи
    func loadFinancials() {
        financials = userDefaultsService.getAllFinancialEntries()
    }
}
