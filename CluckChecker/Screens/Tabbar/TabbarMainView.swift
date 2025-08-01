import SwiftUI

struct TabbarMainView: View {
    /// Настройка таббара
    @EnvironmentObject private var tabbarService: TabbarService
    /// Текущая выбранная вкладка
    @State private var selectedTab: AppTabScreen = .menu
    
    var body: some View {
        ZStack(alignment: .center) {
            Group {
                switch selectedTab {
                case .shops:
                    ShopsMainView()
                case .articles:
                    ArticlesMainView()
                case .menu:
                    MenuMainView()
                case .financial:
                    FinancialMainView()
                case .settings:
                    SettingsMainView()
                }
            }
            
            // Таббар поверх контента
            if tabbarService.isTabbarVisible {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    TabbarBottomView(selectedTab: $selectedTab)
                }
                .padding(.bottom, AppConfig.adaptiveTabbarBottomPadding)
                //.padding(.bottom, AppConfig.tabbarBottomPadding)
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    TabbarMainView()
        .environmentObject(AppRouter())
        .environmentObject(TabbarService())
}
