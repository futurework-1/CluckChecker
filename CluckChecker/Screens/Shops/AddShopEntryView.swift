import SwiftUI

struct AddShopEntryView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @ObservedObject var viewModel: ShopsViewModel
    
    @State private var name: String = ""
    @State private var eggsStock: String = ""
    @State private var eggsSold: String = ""
    @State private var chickensStock: String = ""
    @State private var chickensSold: String = ""
    @State private var selectedType: ShopType = .shop
    @FocusState private var isNameFieldFocused: Bool
    @FocusState private var isEggsStockFocused: Bool
    @FocusState private var isEggsSoldFocused: Bool
    @FocusState private var isChickensStockFocused: Bool
    @FocusState private var isChickensSoldFocused: Bool
    
    private let dataService = UserDefaultsService.shared
    
    var body: some View {
        ZStack(alignment: .center) {
            MainBGView()
            
            ScrollView {
                
                VStack(alignment: .center, spacing: 16) {
                    // Поле названия
                    VStack(alignment: .leading, spacing: 0) {
                        TextField("", text: $name)
                            .font(.customFont(font: .semiBold, size: 20))
                            .foregroundStyle(.customYellow)
                            .multilineTextAlignment(.leading)
                            .focused($isNameFieldFocused)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                            .overlay(
                                // Кастомный placeholder
                                HStack {
                                    if name.isEmpty {
                                        Text("Name")
                                            .font(.customFont(font: .semiBold, size: 20))
                                            .foregroundStyle(.customYellow.opacity(0.5))
                                        Spacer()
                                    }
                                }
                                .padding(.leading, 16)
                                .allowsHitTesting(false)
                            )
                    }
                    .padding(.top, 80)
                    
                    // Секция Eggs
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Eggs")
                            .font(.customFont(font: .semiBold, size: 16))
                            .foregroundStyle(.customYellow)
                        
                        HStack(spacing: 12) {
                            // Stock
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    TextField("", text: $eggsStock)
                                        .font(.customFont(font: .semiBold, size: 18))
                                        .foregroundStyle(.customYellow)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .focused($isEggsStockFocused)
                                    
                                    Image("eggImage")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                                .overlay(
                                    // Кастомный placeholder для Stock
                                    HStack {
                                        if eggsStock.isEmpty {
                                            Text("Stock")
                                                .font(.customFont(font: .semiBold, size: 18))
                                                .foregroundStyle(.customYellow.opacity(0.5))
                                            Spacer()
                                        }
                                    }
                                    .padding(.leading, 16)
                                    .allowsHitTesting(false)
                                )
                            }
                            
                            // Sold
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    TextField("", text: $eggsSold)
                                        .font(.customFont(font: .semiBold, size: 18))
                                        .foregroundStyle(.customYellow)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .focused($isEggsSoldFocused)
                                    
                                    Image("eggImage")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                                .overlay(
                                    // Кастомный placeholder для Sold
                                    HStack {
                                        if eggsSold.isEmpty {
                                            Text("Sold")
                                                .font(.customFont(font: .semiBold, size: 18))
                                                .foregroundStyle(.customYellow.opacity(0.5))
                                            Spacer()
                                        }
                                    }
                                    .padding(.leading, 16)
                                    .allowsHitTesting(false)
                                )
                            }
                        }
                    }
                    
                    // Секция Chickens
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Chickens")
                            .font(.customFont(font: .semiBold, size: 16))
                            .foregroundStyle(.customYellow)
                        
                        HStack(spacing: 12) {
                            // Stock
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    TextField("", text: $chickensStock)
                                        .font(.customFont(font: .semiBold, size: 18))
                                        .foregroundStyle(.customYellow)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .focused($isChickensStockFocused)
                                    
                                    Image("henImage")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                                .overlay(
                                    // Кастомный placeholder для Stock
                                    HStack {
                                        if chickensStock.isEmpty {
                                            Text("Stock")
                                                .font(.customFont(font: .semiBold, size: 18))
                                                .foregroundStyle(.customYellow.opacity(0.5))
                                            Spacer()
                                        }
                                    }
                                    .padding(.leading, 16)
                                    .allowsHitTesting(false)
                                )
                            }
                            
                            // Sold
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    TextField("", text: $chickensSold)
                                        .font(.customFont(font: .semiBold, size: 18))
                                        .foregroundStyle(.customYellow)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .focused($isChickensSoldFocused)
                                    
                                    Image("henImage")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                                .overlay(
                                    // Кастомный placeholder для Sold
                                    HStack {
                                        if chickensSold.isEmpty {
                                            Text("Sold")
                                                .font(.customFont(font: .semiBold, size: 18))
                                                .foregroundStyle(.customYellow.opacity(0.5))
                                            Spacer()
                                        }
                                    }
                                    .padding(.leading, 16)
                                    .allowsHitTesting(false)
                                )
                            }
                        }
                    }
                    
                    // Секция Type
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Type")
                            .font(.customFont(font: .semiBold, size: 16))
                            .foregroundStyle(.customYellow)
                        
                        HStack(spacing: 12) {
                            ForEach(ShopType.allCases, id: \.self) { type in
                                Button(action: {
                                    selectedType = type
                                }) {
                                    VStack(spacing: 8) {
                                        Image(type.iconName)
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        
                                        Text(type.title)
                                            .font(.customFont(font: .semiBold, size: 12))
                                    }
                                    .foregroundStyle(.customYellow)
                                    .opacity(selectedType == type ? 1.0 : 0.5)
                                    .scaleEffect(selectedType == type ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedType)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Кнопка сохранения
                    Button(action: {
                        saveEntry()
                    }) {
                        Text("Save")
                            .font(.customFont(font: .semiBold, size: 25))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(RoundedRectangle(cornerRadius: 20).fill(.customYellow))
                    }
                    .disabled(name.isEmpty)
                    .opacity(name.isEmpty ? 0.5 : 1.0)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, getFocusedPadding())
            }
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
                Text("Add a point")
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
            }
            
            // Toolbar для клавиатуры
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done") {
                    dismissKeyboard()
                }
                .foregroundColor(.customYellow)
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
    
    private func getFocusedPadding() -> CGFloat {
        if isNameFieldFocused || isEggsStockFocused || isEggsSoldFocused ||
           isChickensStockFocused || isChickensSoldFocused {
            return 50
        }
        return AppConfig.tabbarBottomPadding + AppConfig.tabbarHeight + 40
    }
    
    private func dismissKeyboard() {
        isNameFieldFocused = false
        isEggsStockFocused = false
        isEggsSoldFocused = false
        isChickensStockFocused = false
        isChickensSoldFocused = false
    }
    
    private func saveEntry() {
        guard !name.isEmpty else { return }
        
        let entry = ShopEntry(
            name: name,
            eggsStock: Int(eggsStock) ?? 0,
            eggsSold: Int(eggsSold) ?? 0,
            chickensStock: Int(chickensStock) ?? 0,
            chickensSold: Int(chickensSold) ?? 0,
            type: selectedType
        )
        
        viewModel.addEntry(entry)
        appRouter.shopsRoute.removeLast()
    }
}

#Preview {
    NavigationView {
        AddShopEntryView(viewModel: ShopsViewModel())
            .environmentObject(AppRouter())
    }
}
