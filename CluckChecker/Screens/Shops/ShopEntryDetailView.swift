import SwiftUI

struct ShopEntryDetailView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @ObservedObject var viewModel: ShopsViewModel
    let entryId: UUID
    
    @State private var showDeleteAlert = false
    
    private var entry: ShopEntry? {
        viewModel.getEntry(withId: entryId)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            MainBGView()
            
            if let entry = entry {
                VStack(alignment: .center, spacing: 24) {
                    // Иконка типа магазина
                    VStack(spacing: 16) {
                        Image(entry.type.iconName)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                        
                        Text(entry.type.title)
                            .font(.customFont(font: .semiBold, size: 24))
                            .foregroundStyle(.customYellow)
                    }
                    .padding(.top, 80)
                    
                    Spacer()
                    
                    // Детальная информация
                    VStack(spacing: 20) {
                        // Eggs информация
                        detailCard(
                            title: "Eggs",
                            stockCount: entry.eggsStock,
                            soldCount: entry.eggsSold,
                            iconName: "eggImage"
                        )
                        
                        // Chickens информация
                        detailCard(
                            title: "Chickens",
                            stockCount: entry.chickensStock,
                            soldCount: entry.chickensSold,
                            iconName: "henImage"
                        )
                    }
                    
                    Spacer()
                    
                    // Кнопка редактирования
                    Button(action: {
                        viewModel.prepareForEditEntry(entry)
                        appRouter.shopsRoute.append(.editEntry)
                    }) {
                        Text("Edit")
                            .font(.customFont(font: .semiBold, size: 25))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(RoundedRectangle(cornerRadius: 20).fill(.customYellow))
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 32)
                .padding(.bottom, AppConfig.tabbarBottomPadding + AppConfig.tabbarHeight + 40)
            } else {
                Text("Entry not found")
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .alert("Delete Entry", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteEntry()
            }
        } message: {
            if let entry = entry {
                Text("Are you sure you want to delete '\(entry.name)'?")
            }
        }
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
                if let entry = entry {
                    Text(entry.name)
                        .foregroundStyle(.customYellow)
                        .font(.customFont(font: .semiBold, size: 20))
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showDeleteAlert = true
                }) {
                    Image(systemName: "trash.fill")
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.red)
                }
            }
        }
    }
    
    // MARK: - Detail Card
    
    private func detailCard(title: String, stockCount: Int, soldCount: Int, iconName: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.customFont(font: .semiBold, size: 18))
                .foregroundStyle(.customYellow)
            
            HStack(spacing: 16) {
                // Stock
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Number stock")
                            .font(.customFont(font: .semiBold, size: 12))
                            .opacity(0.7)
                        
                        Text("\(stockCount)")
                            .font(.customFont(font: .semiBold, size: 24))
                    }
                    
                   Spacer()
                    VStack(alignment: .center, spacing: 4) {
                        Spacer()
                        
                        Image(iconName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                    }
                    
                }
                
                // Sold
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Number sold")
                            .font(.customFont(font: .semiBold, size: 12))
                            .opacity(0.7)
                        
                        Text("\(soldCount)")
                            .font(.customFont(font: .semiBold, size: 24))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Spacer()
                        
                        Image(iconName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        .frame(height: 80)
        .foregroundStyle(.customYellow)
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
    }
    
    private func deleteEntry() {
        viewModel.deleteEntry(withId: entryId)
        appRouter.shopsRoute.removeLast()
    }
}

#Preview {
    let viewModel = ShopsViewModel()
    let testEntry = ShopEntry(
        name: "Central Market",
        eggsStock: 34,
        eggsSold: 10,
        chickensStock: 20,
        chickensSold: 5,
        type: .shop
    )
    viewModel.allEntries = [testEntry]
    
    return NavigationView {
        ShopEntryDetailView(viewModel: viewModel, entryId: testEntry.id)
            .environmentObject(AppRouter())
    }
}
