import Foundation

struct Financial: Codable, Identifiable {
    let id: UUID
    let sum: Int
    let date: Date
    
    init(sum: Int, date: Date) {
        self.id = UUID()
        self.sum = sum
        self.date = date
    }
}


