import SwiftUI

struct FinancialMainView: View {
    /// Роутер для навигации
    @EnvironmentObject private var appRouter: AppRouter
    
    @StateObject private var viewModel = FinancialViewModel()

    
    private var totalSum: Int {
        viewModel.financials.reduce(0) { $0 + $1.sum }
    }
    
    private var totalSumString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: totalSum)) ?? "0"
    }
    
    
    private var todaySum: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return viewModel.financials.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }.reduce(0) { $0 + $1.sum }
    }
    
    private var todaySumString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: todaySum)) ?? "0"
    }
    
    private var weekSum: Int {
        let calendar = Calendar.current
        let today = Date()
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else { return 0 }
        return viewModel.financials.filter { entry in
            weekInterval.contains(entry.date)
        }.reduce(0) { $0 + $1.sum }
    }
    private var weekSumString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: weekSum)) ?? "0"
    }

    private var monthSum: Int {
        let calendar = Calendar.current
        let today = Date()
        guard let monthInterval = calendar.dateInterval(of: .month, for: today) else { return 0 }
        return viewModel.financials.filter { entry in
            monthInterval.contains(entry.date)
        }.reduce(0) { $0 + $1.sum }
    }
    private var monthSumString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: monthSum)) ?? "0"
    }
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        NavigationStack(path: $appRouter.financialRoute) {
            ZStack(alignment: .center) {
                MainBGView()
                
                VStack(alignment: .center, spacing: 20) {
                    
                    // Верхний блок
                    VStack(alignment: .center, spacing: 12) {
                        Text("Total Earnings")
                            .opacity(0.5)
                            .font(.customFont(font: .bold, size: 20))
                        
                        HStack(alignment: .center, spacing: 2) {
                            Text("$")
                            
                            // Total sum
                            Text(totalSumString)
                            
                            Text(".00")
                        }
                        .font(.customFont(font: .bold, size: 30))
                    }
                    .foregroundStyle(.customYellow)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    
                    
                    // Нижний болк
                    VStack(alignment: .leading, spacing: 0) {
                        Text("🕒 Today")
                            .foregroundStyle(.customYellow)
                            .font(.customFont(font: .bold, size: 14))
                            .padding(.top, 16)
                            .padding(.bottom, 4)
                        
                        HStack(alignment: .center, spacing: 4) {
                            // тут надо подставить сумму за сегодня
                            Text(todaySumString)
                                .foregroundStyle(.customYellow)
                                .font(.customFont(font: .bold, size: 25))
                            
                            Text("$")
                                .foregroundStyle(.customYellow)
                                .font(.customFont(font: .bold, size: 25))
                        }
                        .padding(.bottom, 14)
                        
                        Rectangle()
                            .foregroundStyle(.customYellow)
                            .opacity(0.3)
                            .frame(maxWidth: .infinity, maxHeight: 1, alignment: .center)
                            
                        Text("📅 This Week")
                            .foregroundStyle(.customYellow)
                            .font(.customFont(font: .bold, size: 14))
                            .padding(.top, 16)
                            .padding(.bottom, 4)
                        
                        HStack(alignment: .center, spacing: 4) {
                            Text(weekSumString) // тут надо подставить сумму за эту неделю
                                .foregroundStyle(.customYellow)
                                .font(.customFont(font: .bold, size: 25))
                            
                            Text("$")
                                .foregroundStyle(.customYellow)
                                .font(.customFont(font: .bold, size: 25))
                        }
                        .padding(.bottom, 14)
                        
                        Rectangle()
                            .foregroundStyle(.customYellow)
                            .opacity(0.3)
                            .frame(maxWidth: .infinity, maxHeight: 1, alignment: .center)
                        
                        Text("🗓️ This Month")
                            .foregroundStyle(.customYellow)
                            .font(.customFont(font: .bold, size: 14))
                            .padding(.top, 16)
                            .padding(.bottom, 4)
                        
                        HStack(alignment: .center, spacing: 4) {
                            Text(monthSumString) // тут надо подставить сумму за этот месяц
                                .foregroundStyle(.customYellow)
                                .font(.customFont(font: .bold, size: 25))
                            
                            Text("$")
                                .foregroundStyle(.customYellow)
                                .font(.customFont(font: .bold, size: 25))
                        }
                        .padding(.bottom, 16)
                        
                    }
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    
                    Button {
                        appRouter.financialRoute.append(.first)
                    } label: {
                        Image("plusImage")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    .buttonStyle(.bordered)
                    
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 32)
                .padding(.top, 80)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .navigationDestination(for: FinancialScreen.self) { screen in
                    switch screen {
                    case .main:
                        FinancialMainView()
                    case .first:
                        AddSaleFirstView()
                            .environmentObject(viewModel)
                    case .second:
                        AddSaleSecondView()
                            .environmentObject(viewModel)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Financial Tracking")
                            .foregroundStyle(.customYellow)
                            .font(.customFont(font: .semiBold, size: 20))
                    }
                }
                
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    FinancialMainView()
        .environmentObject(AppRouter())
}
