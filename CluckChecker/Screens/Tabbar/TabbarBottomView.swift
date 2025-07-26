import SwiftUI

/// Модель элемента таббара
struct TabbarItem {
    let icon: String
}

struct TabbarBottomView: View {
    
    @Binding var selectedTab: AppTabScreen
    
    /// Элементы таббара с иконками и заголовками
    private let tabbarItems: [TabbarItem] = [
        TabbarItem(icon: "shop"),
        TabbarItem(icon: "article"),
        TabbarItem(icon: "menu"),
        TabbarItem(icon: "financial"),
        TabbarItem(icon: "settings")
    ]
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            
            ForEach(tabbarItems.indices, id: \.self) { index in
                HStack(alignment: .center, spacing: 0) {
                    Spacer(minLength: 0)
                    
                    Image(selectedTab.selectedTabScreenIndex == index ? "\(tabbarItems[index].icon)Painted"  : tabbarItems[index].icon)
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .center)
                        .scaledToFit()
                    
                    Spacer(minLength: 0)
                    
                }
                .onTapGesture {
                    switch index {
                    case 1: selectedTab = .articles
                    case 2: selectedTab = .menu
                    case 3: selectedTab = .financial
                    case 4: selectedTab = .settings
                    default: selectedTab = .shops
                    }
                }
            }
            
            Spacer()
            
        }
        .frame(height: AppConfig.tabbarHeight)
        .frame(maxWidth: .infinity)
        .background(Color.customTabbar)
    }
}

#Preview {
    TabbarMainView()
        .environmentObject(AppRouter())
        .environmentObject(TabbarService())
}
