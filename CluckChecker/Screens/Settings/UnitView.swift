import SwiftUI

struct UnitView: View {
    
    @EnvironmentObject private var appRouter: AppRouter
    
    @State private var selectedType: SaleType? = .pieces
    
    enum SaleType {
        case pieces
        case dozens
    }
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        ZStack(alignment: .center) {
            MainBGView()
            
            VStack(alignment: .center, spacing: 16) {
                
                Text("Currency")
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedType == .pieces ? Color.customYellow : Color.clear, lineWidth: 4)
                    )
                    .onTapGesture {
                        selectedType = .pieces
                    }
                
                Text("Dozens")
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedType == .dozens ? Color.customYellow : Color.clear, lineWidth: 4)
                    )
                    .onTapGesture {
                        selectedType = .dozens
                    }
                
                Spacer()
                
            }
            .padding(.horizontal, 24)
            .padding(.top, 120)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .toolbar {
                // Заголовок
                ToolbarItem(placement: .principal) {
                    Text("Unit of measure")
                        .foregroundStyle(.customYellow)
                        .font(.customFont(font: .semiBold, size: 20))
                }
                
                // Кнопка назад
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        appRouter.settingsRoute.removeLast()
                    } label: {
                        Image(.backButton)
                    }
                }
                
            }
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            appRouter.settingsRoute.removeAll()
        }
    }
}

#Preview {
    NavigationStack {
        UnitView()
            .environmentObject(AppRouter())
    }
}
