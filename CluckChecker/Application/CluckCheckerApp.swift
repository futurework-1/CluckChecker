import SwiftUI

@main
struct CluckCheckerApp: App {
    
    /// Роутер для навигации
    @StateObject private var appRouter = AppRouter()
    
    /// Сервис управления таббаром
    @StateObject private var tabbarService = TabbarService()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appRouter)
                .environmentObject(tabbarService)
                .dynamicTypeSize(.large)
                .preferredColorScheme(.dark)
                .background(.black)
        }
    }
}
