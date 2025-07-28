import SwiftUI

struct EditEventView: View {
    
    @EnvironmentObject private var appRouter: AppRouter
    @ObservedObject var viewModel: MenuViewModel
    
    @State private var count: String = ""
    @State private var showDeleteAlert = false
    @FocusState private var isCountFieldFocused: Bool
    
    private let dataService = UserDefaultsService.shared
    
    var body: some View {
        ZStack(alignment: .center) {
            MainBGView()
            
            if let event = viewModel.editingEvent {
                VStack(alignment: .center, spacing: 24) {
                    // Поле редактирования количества
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            TextField("\(event.count)", text: $count)
                                .font(.customFont(font: .semiBold, size: 25))
                                .foregroundStyle(.customYellow)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.leading)
                                .focused($isCountFieldFocused)
                                .padding(.leading)
                            
                            Image(event.type.iconName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 48, height: 48)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    }
                    .padding(.top, 80)
                    
                    Spacer()
                    
                    // Кнопка редактирования
                    Button(action: {
                        editEvent()
                    }) {
                        Text("Edit")
                            .font(.customFont(font: .semiBold, size: 25))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(RoundedRectangle(cornerRadius: 20).fill(.customYellow))
                    }
                    .disabled(count.isEmpty)
                    .opacity(count.isEmpty ? 0.5 : 1.0)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, isCountFieldFocused ? 50 : (AppConfig.tabbarBottomPadding + AppConfig.tabbarHeight + 40))
            } else {
                Text("No event to edit")
                    .foregroundStyle(.customYellow)
                    .font(.customFont(font: .semiBold, size: 20))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .alert("Delete Event", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteEvent()
            }
        } message: {
            if let event = viewModel.editingEvent {
                Text("Are you sure you want to delete \(event.type.title) record with \(event.count) items?")
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
                if let event = viewModel.editingEvent {
                    Text(event.type.title)
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
                    isCountFieldFocused = false
                }
                .foregroundColor(.customYellow)
            }
        }
        .onTapGesture {
            // Скрываем клавиатуру при тапе на пустое место
            isCountFieldFocused = false
        }
        .onAppear {
            if let event = viewModel.editingEvent {
                count = "\(event.count)"
            }
        }
    }
    
    private func editEvent() {
        guard let event = viewModel.editingEvent,
              let countValue = Int(count), countValue > 0 else { return }
        
        let updatedEvent = Event(type: event.type, count: countValue)
        dataService.addEvent(updatedEvent, to: viewModel.selectedDate)
        
        // Очищаем редактируемое событие и возвращаемся назад
        viewModel.clearEditingState()
        appRouter.menuRoute.removeLast()
    }
    
    private func deleteEvent() {
        guard let event = viewModel.editingEvent else { return }
        
        // Удаляем событие
        dataService.removeEvent(withId: event.id, from: viewModel.selectedDate)
        
        // Очищаем редактируемое событие и возвращаемся назад
        viewModel.clearEditingState()
        appRouter.menuRoute.removeLast()
    }
}

#Preview {
    let viewModel = MenuViewModel()
    viewModel.editingEvent = Event(type: .eggs, count: 5)
    
    return NavigationView {
        EditEventView(viewModel: viewModel)
            .environmentObject(AppRouter())
    }
}
