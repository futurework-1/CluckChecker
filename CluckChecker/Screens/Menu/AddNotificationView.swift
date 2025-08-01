import SwiftUI

struct AddNotificationView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @ObservedObject var viewModel: MenuViewModel
    
    @State private var name: String = ""
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @FocusState private var isNameFieldFocused: Bool
    
    private let dataService = UserDefaultsService.shared
    
    var body: some View {
        ZStack(alignment: .center) {
            MainBGView()
            
            VStack(alignment: .center, spacing: 24) {
                // Поле названия
                VStack(alignment: .leading, spacing: 0) {
                    TextField("Название напоминания", text: $name)
                        .font(.customFont(font: .semiBold, size: 20))
                        .foregroundStyle(.customYellow)
                        .multilineTextAlignment(.leading)
                        .focused($isNameFieldFocused)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                }
                .padding(.top, 80)
                
                // Поле даты
                VStack(alignment: .leading, spacing: 0) {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .colorScheme(.dark)
                        .font(.customFont(font: .semiBold, size: 20))
                        .foregroundStyle(.customYellow)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                }
                
                // Поле времени
                VStack(alignment: .leading, spacing: 0) {
                    DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                        .colorScheme(.dark)
                        .font(.customFont(font: .semiBold, size: 20))
                        .foregroundStyle(.customYellow)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                }
                
                Spacer()
                
                // Кнопка сохранения
                Button(action: {
                    saveNotification()
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
            .padding(.top, 20)
            .padding(.horizontal, 32)
            .padding(.bottom, isNameFieldFocused ? 90 : (AppConfig.tabbarBottomPadding + AppConfig.tabbarHeight + 80))
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
                Text("New Notification")
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
            }
            
            // Toolbar для клавиатуры
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done") {
                    isNameFieldFocused = false
                }
                .foregroundColor(.customYellow)
            }
        }
        .onTapGesture {
            // Скрываем клавиатуру при тапе на пустое место
            isNameFieldFocused = false
        }
        .onAppear {
            // Устанавливаем выбранную дату из ViewModel
            selectedDate = viewModel.selectedDate
        }
    }
    
    private func saveNotification() {
        guard !name.isEmpty else { return }
        
        let notification = Notification(name: name, date: selectedDate, time: selectedTime)
        dataService.addNotification(notification, to: viewModel.selectedDate)
        
        // Возвращаемся назад
        appRouter.menuRoute.removeLast()
    }
}

#Preview {
    NavigationView {
        AddNotificationView(viewModel: MenuViewModel())
            .environmentObject(AppRouter())
    }
}
