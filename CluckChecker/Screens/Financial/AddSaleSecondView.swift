import SwiftUI

struct AddSaleSecondView: View {
    /// Роутер для навигации
    @EnvironmentObject private var appRouter: AppRouter
    
    @EnvironmentObject private var viewModel: FinancialViewModel
    
    @State private var price: String = ""
    @FocusState private var isPriceFieldFocused: Bool
    
    @State private var sold: String = ""
    @FocusState private var isSoldFieldFocused: Bool
    
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        ZStack(alignment: .center) {
            MainBGView()
            
            VStack(alignment: .center, spacing: 16) {
                
                // Price
                HStack(alignment: .center, spacing: 4) {
                    ZStack(alignment: .leading) {
                        if price.isEmpty && !isPriceFieldFocused {
                            Text("Price")
                                .foregroundStyle(.customYellow.opacity(0.5))
                                .font(.customFont(font: .semiBold, size: 20))
                        }
                        TextField("", text: $price)
                            .keyboardType(.numberPad)
                            .font(.customFont(font: .semiBold, size: 20))
                            .foregroundStyle(.customYellow)
                            .focused($isPriceFieldFocused)
                    }
                    
                    Text("$")
                    
                    Spacer()
                }
                .foregroundStyle(.customYellow)
                .font(.customFont(font: .semiBold, size: 20))
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                
                
                // Sold
                HStack(alignment: .center, spacing: 0) {
                    ZStack(alignment: .leading) {
                        if sold.isEmpty && !isSoldFieldFocused {
                            Text("Sold")
                                .foregroundStyle(.customYellow.opacity(0.5))
                                .font(.customFont(font: .semiBold, size: 20))
                        }
                        TextField("", text: $sold)
                            .keyboardType(.decimalPad)
                            .font(.customFont(font: .semiBold, size: 20))
                            .foregroundStyle(.customYellow)
                            .focused($isSoldFieldFocused)
                    }
                                        
                    Spacer()
                }
                .foregroundStyle(.customYellow)
                .font(.customFont(font: .semiBold, size: 20))
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                
                
                // Date
                HStack(alignment: .center, spacing: 4) {
                    Text(currentDateString)
                    
                    Spacer()
                }
                .foregroundStyle(.customYellow)
                .font(.customFont(font: .semiBold, size: 20))
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                
                Spacer()
                
                // Save
                Button {
                    if let priceInt = Int(price), let soldInt = Int(sold) {
                        viewModel.addFinancial(price: priceInt, sold: soldInt)
                        appRouter.financialRoute.removeAll()
                    }
                } label: {
                    Text("Save")
                        .foregroundStyle(.customTabbar.opacity((price.isEmpty || sold.isEmpty) ? 0.5 : 1.0))
                        .font(.customFont(font: .semiBold, size: 25))
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.customYellow.opacity((price.isEmpty || sold.isEmpty) ? 0.5 : 1.0)))
                }
                .disabled(price.isEmpty || sold.isEmpty)
                
                
            }
            .padding(.horizontal, 32)
            .padding(.top, 80)
            .padding(.bottom, 200)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .toolbar {
                // Заголовок
                ToolbarItem(placement: .principal) {
                    Text("Add sale")
                        .foregroundStyle(.customYellow)
                        .font(.customFont(font: .semiBold, size: 20))
                }
                
                // Кнопка назад
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        appRouter.financialRoute.removeLast()
                    } label: {
                        Image(.backButton)
                    }
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
        .navigationBarBackButtonHidden()
        .onDisappear {
            appRouter.financialRoute.removeAll()
        }
    }
    
    private func dismissKeyboard() {
        isPriceFieldFocused = false
        isSoldFieldFocused = false
    }
    
}

#Preview {
    NavigationStack {
        AddSaleSecondView()
            .environmentObject(AppRouter())
    }
}
