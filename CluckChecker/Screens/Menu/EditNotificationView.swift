import SwiftUI

struct EditNotificationView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @ObservedObject var viewModel: MenuViewModel
    
    @State private var name: String = ""
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var showDeleteAlert = false
    @FocusState private var isNameFieldFocused: Bool
    
    private let dataService = UserDefaultsService.shared
    
    var body: some View {
        ZStack(alignment: .center) {
            MainBGView()
            
            if let notification = viewModel.editingNotification {
                VStack(alignment: .center, spacing: 24) {
                    // Поле названия
                    VStack(alignment: .leading, spacing: 0) {
                        TextField(notification.name, text: $name)
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
                    
                    // Кнопка редактирования
                    Button(action: {
                        editNotification()
                    }) {
                        Text("Edit")
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
                .padding(.bottom, isNameFieldFocused ? 50 : (AppConfig.tabbarBottomPadding + AppConfig.tabbarHeight + 40))
            } else {
                Text("No notification to edit")
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .alert("Delete Notification", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteNotification()
            }
        } message: {
            if let notification = viewModel.editingNotification {
                Text("Are you sure you want to delete notification '\(notification.name)'?")
            }
        }
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
                if let notification = viewModel.editingNotification {
                    Text(notification.name)
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
            if let notification = viewModel.editingNotification {
                name = notification.name
                selectedDate = notification.date
                selectedTime = notification.time
            }
        }
    }
    
    private func editNotification() {
        guard let originalNotification = viewModel.editingNotification,
              !name.isEmpty else { return }
        
        // Удаляем старое напоминание
        dataService.removeNotification(withId: originalNotification.id, from: viewModel.selectedDate)
        
        // Создаем новое напоминание с обновленными данными
        let updatedNotification = Notification(name: name, date: selectedDate, time: selectedTime)
        dataService.addNotification(updatedNotification, to: viewModel.selectedDate)
        
        // Очищаем редактируемое напоминание и возвращаемся назад
        viewModel.clearEditingState()
        appRouter.menuRoute.removeLast()
    }
    
    private func deleteNotification() {
        guard let notification = viewModel.editingNotification else { return }
        
        // Удаляем напоминание
        dataService.removeNotification(withId: notification.id, from: viewModel.selectedDate)
        
        // Очищаем редактируемое напоминание и возвращаемся назад
        viewModel.clearEditingState()
        appRouter.menuRoute.removeLast()
    }
}

#Preview {
    let viewModel = MenuViewModel()
    viewModel.editingNotification = Notification(name: "Test notification", date: Date(), time: Date())
    
    return NavigationView {
        EditNotificationView(viewModel: viewModel)
            .environmentObject(AppRouter())
    }
}
