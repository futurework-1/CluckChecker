//
//  CurrencyView.swift
//  CluckChecker
//
//  Created by Адам Табиев on 25.07.2025.
//

import SwiftUI

struct CurrencyView: View {
    @EnvironmentObject private var appRouter: AppRouter
    
    @State private var selectedType: SaleType? = .USD
    
    enum SaleType {
        case USD
        case EUR
        case UAH
        case RUB
    }
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        ZStack(alignment: .center) {
            MainBGView()
            
            VStack(alignment: .center, spacing: 16) {
                
                Text("$ (USD)")
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedType == .USD ? Color.customYellow : Color.clear, lineWidth: 4)
                    )
                    .onTapGesture {
                        selectedType = .USD
                    }
                
                Text("€ (EUR)")
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedType == .EUR ? Color.customYellow : Color.clear, lineWidth: 4)
                    )
                    .onTapGesture {
                        selectedType = .EUR
                    }
                
                Text("₴ (UAH)")
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedType == .UAH ? Color.customYellow : Color.clear, lineWidth: 4)
                    )
                    .onTapGesture {
                        selectedType = .UAH
                    }
                
                Text("₽ (RUB)")
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedType == .RUB ? Color.customYellow : Color.clear, lineWidth: 4)
                    )
                    .onTapGesture {
                        selectedType = .RUB
                    }
                
                Spacer()
                
            }
            .padding(.horizontal, 24)
            .padding(.top, 80)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .toolbar {
                // Заголовок
                ToolbarItem(placement: .principal) {
                    Text("Currency")
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
        CurrencyView()
            .environmentObject(AppRouter())
    }
}
