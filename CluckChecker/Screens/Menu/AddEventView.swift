import SwiftUI

struct AddEventView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @ObservedObject var viewModel: MenuViewModel
    
    @State private var selectedEventType: EventType = .eggs
    @State private var count: String = ""
    @FocusState private var isCountFieldFocused: Bool
    
    private let dataService = UserDefaultsService.shared
    
    var body: some View {
        ZStack(alignment: .center) {
            MainBGView()
            
            VStack(alignment: .center, spacing: 24) {
                // Переключатель типа события
                HStack(spacing: 20) {
                    ForEach(EventType.allCases, id: \.self) { eventType in
                        Button(action: {
                            selectedEventType = eventType
                        }) {
                            VStack(spacing: 4) {
                                Image(eventType.iconName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 32, height: 32)
                                
                                Text(eventType.title)
                                    .font(.customFont(font: .semiBold, size: 14))
                            }
                            .foregroundStyle(selectedEventType == eventType ? .customYellow : .customYellow.opacity(0.5))
                            .scaleEffect(selectedEventType == eventType ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: selectedEventType)
                        }
                    }
                }
                .padding(.top, 80)
                
                // Поле ввода количества
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        TextField("0", text: $count)
                            .font(.customFont(font: .semiBold, size: 25))
                            .foregroundStyle(.customYellow)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.leading)
                            .focused($isCountFieldFocused)
                            .padding(.leading)
                        
                        Image(selectedEventType.iconName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                }
                
                Spacer()
                
                // Кнопка сохранения
                Button(action: {
                    saveEvent()
                }) {
                    Text("Save")
                        .font(.customFont(font: .semiBold, size: 25))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.customYellow))
                }
                .padding(.bottom, 40)
                .disabled(count.isEmpty)
                .opacity(count.isEmpty ? 0.5 : 1.0)
            }
            .padding(.horizontal, 32)
            .padding(.top, 30)
            .padding(.bottom, isCountFieldFocused ? 50 : (AppConfig.tabbarBottomPadding + AppConfig.tabbarHeight + 40))
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    appRouter.menuRoute.removeLast()
                }) {
                    Image("backButtonImage")
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.customYellow)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(selectedEventType.title)
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
            }
            
            // Toolbar для клавиатуры
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done") {
                    isCountFieldFocused = false
                }
                .foregroundColor(.customYellow)
            }
        }
        .onTapGesture {
            // Скрываем клавиатуру при тапе на пустое место
            isCountFieldFocused = false
        }
    }
    
    private func saveEvent() {
        guard let countValue = Int(count), countValue > 0 else { return }
        
        let event = Event(type: selectedEventType, count: countValue)
        dataService.addEvent(event, to: viewModel.selectedDate)
        
        // Возвращаемся назад
        appRouter.menuRoute.removeLast()
    }
}

#Preview {
    NavigationView {
        AddEventView(viewModel: MenuViewModel())
            .environmentObject(AppRouter())
    }
}
