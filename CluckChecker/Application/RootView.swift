import SwiftUI

struct RootView: View {
    
    /// Роутер для навигации
    @EnvironmentObject private var appRouter: AppRouter
    
    /// Настройка таббара
    @EnvironmentObject private var tabbarService: TabbarService
    
    var body: some View {
        if appRouter.showMainScreen {
            TabbarMainView()
        } else {
            SplashMainView()
        }
        
//        Group {
//            switch appRouter.currentMainScreen {
//            case .splash:
//                SplashMainView()
//            case .tabbar:
//                TabbarMainView()
//            }
//        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppRouter())
        .environmentObject(TabbarService())
}
