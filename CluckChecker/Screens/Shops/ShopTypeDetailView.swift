import SwiftUI

struct ShopTypeDetailView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @ObservedObject var viewModel: ShopsViewModel
    let shopType: ShopType
    
    var body: some View {
        ZStack(alignment: .center) {
            MainBGView()
            
            VStack(alignment: .center, spacing: 0) {
                // Иконка типа магазина
                VStack(spacing: 16) {
                    Image(shopType.iconName)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    
                    Text(shopType.title)
                        .font(.customFont(font: .semiBold, size: 24))
                        .foregroundStyle(.customYellow)
                }
                .padding(.top, 80)
                
                Spacer()
                
                // Список записей
                if viewModel.entriesForSelectedType.isEmpty {
                    // Пустое состояние
                    VStack(spacing: 12) {
                        Image("crossImage")
                            .resizable()
                            .frame(width: 60, height: 60)
                        
                        Text("No entries yet")
                            .font(.customFont(font: .semiBold, size: 18))
                        
                        Text("Add your first point of sale")
                            .font(.customFont(font: .semiBold, size: 14))
                            .opacity(0.7)
                    }
                    .foregroundStyle(.customYellow)
                } else {
                    // Список записей
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.entriesForSelectedType) { entry in
                                entryCard(entry: entry)
                            }
                        }
                        .padding(.horizontal, 32)
                    }
                }
                
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
                .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, AppConfig.tabbarBottomPadding + AppConfig.tabbarHeight + 40)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    appRouter.shopsRoute.removeLast()
                }) {
                    Image("backButtonImage")
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.customYellow)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(shopType.title)
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
            }
        }
        .onAppear {
            viewModel.loadEntries(for: shopType)
        }
    }
    
    // MARK: - Entry Card
    
    private func entryCard(entry: ShopEntry) -> some View {
        Button(action: {
            appRouter.shopsRoute.append(.entryDetail(entry.id))
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Название и дата
                HStack {
                    Text(entry.name)
                        .font(.customFont(font: .semiBold, size: 18))
                    
                    Spacer()
                    
                    Text(viewModel.formatDate(entry.dateCreated))
                        .font(.customFont(font: .semiBold, size: 14))
                        .opacity(0.7)
                }
                
                // Статистика
                HStack {
                    // Яйца
                    HStack(spacing: 8) {
                        Image("eggImage")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("\(entry.availableEggs)")
                            .font(.customFont(font: .semiBold, size: 16))
                    }
                    
                    Spacer()
                    
                    // Цыплята
                    HStack(spacing: 8) {
                        Image("henImage")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("\(entry.availableChickens)")
                            .font(.customFont(font: .semiBold, size: 16))
                    }
                }
            }
            .foregroundStyle(.customYellow)
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
        }
    }
}

#Preview {
    NavigationView {
        ShopTypeDetailView(viewModel: ShopsViewModel(), shopType: .shop)
            .environmentObject(AppRouter())
    }
}
