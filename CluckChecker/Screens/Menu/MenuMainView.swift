import SwiftUI

struct MenuMainView: View {
    
    /// Роутер для навигации
    @EnvironmentObject private var appRouter: AppRouter
    
    /// ViewModel для управления состоянием
    @StateObject private var viewModel = MenuViewModel()
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        NavigationStack(path: $appRouter.menuRoute) {
            ZStack(alignment: .center) {
                MainBGView()
                
                VStack(alignment: .center, spacing: 0) {
                    
                    // Селектор даты
                    datePickerView
                        .padding(.top, 80)
                    
                    // Основной контент
                    if viewModel.dateData.events.isEmpty {
                        emptyContentView
                            .padding(.top)
                    } else {
                        dataContentView
                            .padding(.top)
                    }
                    
                    RoundedRectangle(cornerRadius: 50)
                        .frame(height: 1)
                        .padding(.vertical)
                    
                    // Секция уведомлений
                    notificationsSection
                    
                    Spacer(minLength: 0)
                }
                .foregroundStyle(.customYellow)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.horizontal, 32)
                .padding(.bottom, AppConfig.tabbarBottomPadding + AppConfig.tabbarHeight + 32)
                
                // Календарь поверх всего контента
                if viewModel.isDatePickerVisible {
                    // Полупрозрачный фон
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.isDatePickerVisible = false
                        }
                        .zIndex(999)
                    
                    VStack {
                        Spacer()
                            .frame(height: 144) // Отступ сверху под кнопку даты
                        
                        DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .colorScheme(.dark)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                            .padding(.horizontal, 16)
                            .transition(.scale.combined(with: .opacity))
                        
                        Spacer()
                    }
                    .zIndex(1000) // Поверх всех элементов
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Menu")
                        .foregroundStyle(.customYellow)
                        .font(.customFont(font: .semiBold, size: 20))
                }
            }
            .navigationDestination(for: MenuScreen.self) { screen in
                switch screen {
                case .main:
                    MenuMainView()
                case .addEvent:
                    AddEventView(viewModel: viewModel)
                case .editEvent:
                    EditEventView(viewModel: viewModel)
                case .addNotification:
                    AddNotificationView(viewModel: viewModel)
                case .editNotification:
                    EditNotificationView(viewModel: viewModel)
                }
            }
        }
        .onAppear {
            viewModel.loadDataForDate()
        }
        .onChange(of: viewModel.selectedDate) { _ in
            viewModel.loadDataForDate()
        }
        .onChange(of: appRouter.menuRoute) { _ in
            // Обновляем данные при возврате с дочерних экранов с небольшой задержкой
            Task {
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 секунда
                await MainActor.run {
                    viewModel.loadDataForDate()
                }
            }
        }
    }
    
    // MARK: - Date Picker View
    
    private var datePickerView: some View {
        Button(action: {
            viewModel.isDatePickerVisible.toggle()
        }) {
            HStack {
                Text(viewModel.formatDate(viewModel.selectedDate))
                    .font(.customFont(font: .semiBold, size: 15))
                
                Spacer()
                
                Image("triangleImage")
                    .rotationEffect(.degrees(viewModel.isDatePickerVisible ? 180 : 0))
                    .animation(.easeInOut(duration: 0.3), value: viewModel.isDatePickerVisible)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
        }
    }
    
    // MARK: - Content Views
    
    private var emptyContentView: some View {
        VStack(spacing: 8) {
            Image("crossImage")
                .resizable()
                .frame(width: 80, height: 80)
            
            Text("There's nothing here yet...")
                .font(.customFont(font: .semiBold, size: 16))
            
            Text("Press plus to add data")
                .font(.customFont(font: .semiBold, size: 12))
                .opacity(0.5)
            
            Button(action: {
                viewModel.prepareForAddEvent()
                appRouter.menuRoute.append(.addEvent)
            }) {
                Image("plusImage")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.bordered)
        }
    }
    
    private var dataContentView: some View {
        VStack(spacing: 18) {
            // Показываем все существующие события
            ForEach(EventType.allCases, id: \.self) { eventType in
                if let event = viewModel.dateData.events.first(where: { $0.type == eventType }) {
                    eventCardView(event: event)
                }
            }
            
            // Показываем кнопку плюс если не все типы событий добавлены
            if viewModel.dateData.events.count < EventType.allCases.count {
                Button(action: {
                    viewModel.prepareForAddEvent()
                    appRouter.menuRoute.append(.addEvent)
                }) {
                    HStack(spacing: 16) {
                        Image("plusImage")
                            .resizable()
                            .frame(width: 32, height: 32)
                        
                        Text("Add more data")
                            .font(.customFont(font: .semiBold, size: 18))
                        
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun.opacity(0.7)))
                }
            }
        }
    }
    
    private func eventCardView(event: Event) -> some View {
        Button(action: {
            viewModel.prepareForEditEvent(event)
            appRouter.menuRoute.append(.editEvent)
        }) {
            HStack(alignment: .center, spacing: 8) {
                Image(event.type.iconName)
                    .resizable()
                    .frame(width: 40, height: 40)
                
                Text(event.type.title)
                    .font(.customFont(font: .semiBold, size: 25))
                
                Spacer()
                
                Text("\(event.count)")
                    .font(.customFont(font: .bold, size: 25))
                
                Image("pencilImage")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
        }
    }
    
    // MARK: - Notifications Section
    
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Notifications")
                    .font(.customFont(font: .semiBold, size: 20))
                
                Spacer()
                
                Button(action: {
                    viewModel.prepareForAddNotification()
                    appRouter.menuRoute.append(.addNotification)
                }) {
                    Image("plusImage")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.bordered)
            }
            
            if viewModel.dateData.notifications.isEmpty {
                VStack(spacing: 8) {
                    Image("crossImage")
                        .resizable()
                        .frame(width: 80, height: 80)
                    
                    Text("There's nothing here yet...")
                        .font(.customFont(font: .semiBold, size: 16))
                    
                    Text("Click plus to add notifications")
                        .font(.customFont(font: .semiBold, size: 12))
                        .opacity(0.5)
                }
                .frame(maxWidth: .infinity)
            } else {
                // Прокручиваемый список напоминаний
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.dateData.notifications) { notification in
                            notificationCardView(notification: notification)
                        }
                    }
                }
            }
        }
    }
    
    private func notificationCardView(notification: Notification) -> some View {
        Button(action: {
            viewModel.prepareForEditNotification(notification)
            appRouter.menuRoute.append(.editNotification)
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.name)
                        .font(.customFont(font: .semiBold, size: 15))
                    
                    Text(viewModel.formatTime(notification.time))
                        .font(.customFont(font: .semiBold, size: 15))
                        .opacity(0.7)
                }
                
                Spacer()
                
                Button(action: {
                    // some action
                }) {
                    Image("ellipseImage")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
        }
    }
}

#Preview {
    MenuMainView()
        .environmentObject(AppRouter())
}
