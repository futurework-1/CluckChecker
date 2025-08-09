import Foundation

enum LocalPushError: Error, LocalizedError {
    case notAuthorized
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .notAuthorized: return "Notification authorization not granted."
        case .underlying(let err): return err.localizedDescription
        }
    }
}
