import SwiftUI

struct ShopsMainView: View {
    /// Роутер для навигации
    @EnvironmentObject private var appRouter: AppRouter
    /// ViewModel для управления состоянием
    @StateObject private var viewModel = ShopsViewModel()
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        NavigationStack(path: $appRouter.shopsRoute) {
            ZStack(alignment: .center) {
                MainBGView()
                
                VStack(alignment: .center, spacing: 0) {
                
                    
                    // Список типов магазинов
                    VStack(spacing: 16) {
                        ForEach(ShopType.allCases, id: \.self) { shopType in
                            shopTypeCard(for: shopType)
                        }
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    // Кнопка добавления
                    Button(action: {
                        viewModel.prepareForAddEntry()
                        appRouter.shopsRoute.append(.addEntry)
                    }) {
                        Text("Add")
                            .font(.customFont(font: .semiBold, size: 25))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(RoundedRectangle(cornerRadius: 20).fill(.customYellow))
                    }
                }
                .foregroundStyle(.customYellow)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.horizontal, 32)
                .padding(.bottom, AppConfig.tabbarBottomPadding + AppConfig.tabbarHeight + 64)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Shops")
                        .foregroundStyle(.customYellow)
                        .font(.customFont(font: .semiBold, size: 20))
                }
            }
            .navigationDestination(for: ShopsScreen.self) { screen in
                switch screen {
                case .main:
                    ShopsMainView()
                case .addEntry:
                    AddShopEntryView(viewModel: viewModel)
                case .typeDetail(let shopType):
                    ShopTypeDetailView(viewModel: viewModel, shopType: shopType)
                case .entryDetail(let entryId):
                    ShopEntryDetailView(viewModel: viewModel, entryId: entryId)
                case .editEntry:
                    EditShopEntryView(viewModel: viewModel)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.loadAllData()
        }
        .onChange(of: appRouter.shopsRoute) { _ in
            // Обновляем данные при возврате с дочерних экранов
            Task {
                try? await Task.sleep(nanoseconds: 100_000_000)
                await MainActor.run {
                    viewModel.loadAllData()
                }
            }
        }
    }
    
    // MARK: - Shop Type Card
    
    private func shopTypeCard(for shopType: ShopType) -> some View {
        Button(action: {
            viewModel.loadEntries(for: shopType)
            appRouter.shopsRoute.append(.typeDetail(shopType))
        }) {
            HStack(alignment: .center, spacing: 16) {
                // Иконка типа магазина
                Image(shopType.iconName)
                    .resizable()
                    .frame(width: 48, height: 48)
                
                // Название типа
                Text(shopType.title)
                    .font(.customFont(font: .semiBold, size: 25))
                
                Spacer()
                
                // Статистика
                VStack(alignment: .trailing, spacing: 4) {
                    // Яйца
                    HStack(spacing: 8) {
                        Image("eggImage")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("\(viewModel.getStats(for: shopType).totalAvailableEggs)")
                            .font(.customFont(font: .semiBold, size: 16))
                    }
                    
                    // Цыплята
                    HStack(spacing: 8) {
                        Image("henImage")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("\(viewModel.getStats(for: shopType).totalAvailableChickens)")
                            .font(.customFont(font: .semiBold, size: 16))
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
        }
    }
}

#Preview {
    ShopsMainView()
        .environmentObject(AppRouter())
}
