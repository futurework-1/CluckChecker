import SwiftUI

struct AddSaleFirstView: View {
    /// Роутер для навигации
    @EnvironmentObject private var appRouter: AppRouter
    
    @State private var selectedType: SaleType? = nil
    
    enum SaleType {
        case egg, hen
    }
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        ZStack(alignment: .center) {
            MainBGView()
            
            VStack(alignment: .center, spacing: 0) {
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Egg sale")
                        .foregroundStyle(.customYellow)
                        .font(.customFont(font: .semiBold, size: 20))
                    Spacer()
                    Image(.egg)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedType == .egg ? Color.customYellow : Color.clear, lineWidth: 4)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedType = .egg
                }
                .padding(.bottom, 22)
                
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Selling chickens")
                        .foregroundStyle(.customYellow)
                        .font(.customFont(font: .semiBold, size: 20))
                    Spacer()
                    Image(.hen)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedType == .hen ? Color.customYellow : Color.clear, lineWidth: 4)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedType = .hen
                }
                
                Spacer()
                                
                Button {
                    appRouter.financialRoute.append(.second)
                } label: {
                    Text("Next")
                        .foregroundStyle(.customTabbar)
                        .font(.customFont(font: .semiBold, size: 25))
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 20).fill((Color.customYellow.opacity(selectedType == nil ? 0.5 : 1.0))))
                }
                .disabled(selectedType == nil)
                
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
                
            }
        }
        .navigationBarBackButtonHidden()
    }
    
}

#Preview {
    AddSaleFirstView()
        .environmentObject(AppRouter())
}
