import SwiftUI
import WebKit

enum WebViewType {
    case privacyPolicy
    case aboutDeveloper
    
    var title: String {
        switch self {
            case .privacyPolicy: return "Privacy Policy"
            case .aboutDeveloper: return "About the Developer"
        }
    }
    
    var urlString: String {
        switch self {
            case .privacyPolicy:
                "https://sites.google.com/view/cluck-checker/privacy-policy"
            case .aboutDeveloper:
                "https://sites.google.com/view/cluck-checker/home"
        }
    }
}

struct WebViewScreen: View {
    let url: URL
    let type: WebViewType

    var body: some View {
        WebView(url: url)
            .navigationTitle(type.title)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct SettingsMainView: View {
    
    @AppStorage("isNotificationEnable") var isNotificationEnable: Bool = true
    
    /// Роутер для навигации
    @EnvironmentObject private var appRouter: AppRouter
    /// Настройка таббара
    @EnvironmentObject private var tabbarService: TabbarService
    
    @State private var toggl = true
    @State private var isShowPushAlert = false
    
    /// Переменные для WebView
    @State private var showWebView = false
    @State private var webViewType: WebViewType = .aboutDeveloper
    
    private let aboutDeveloperURL = URL(string: "https://google.com")
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        NavigationStack(path: $appRouter.settingsRoute) {
            ZStack(alignment: .center) {
                MainBGView()
                
                VStack(alignment: .center, spacing: 16) {
                    
                    // Unit of measure
                    HStack(alignment: .center, spacing: 0) {
                        Text("Unit of measure")
                            .foregroundStyle(.customYellow)
                            .font(.customFont(font: .semiBold, size: 20))
                        Spacer()
                        Image(.forward)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    .onTapGesture {
                        appRouter.settingsRoute.append(.unit)
                    }
                    
                    
                    // Currency
                    HStack(alignment: .center, spacing: 0) {
                        Text("Currency")
                            .foregroundStyle(.customYellow)
                            .font(.customFont(font: .semiBold, size: 20))
                        Spacer()
                        Image(.forward)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    .onTapGesture {
                        appRouter.settingsRoute.append(.curreency)
                    }
                    
                    
                    // Notification
                    HStack(alignment: .center, spacing: 0) {
                        Text("Notification")
                            .foregroundStyle(.customYellow)
                            .font(.customFont(font: .semiBold, size: 20))
                        Spacer()
                        Toggle(isOn: $toggl) {
                            
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .customYellow))
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    
                    
                    // Privacy Policy
                    HStack(alignment: .center, spacing: 0) {
                        Text("Privacy Policy")
                            .foregroundStyle(.customYellow)
                            .font(.customFont(font: .semiBold, size: 20))
                        Spacer()
                        Image(.forward)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    .onTapGesture {
                        webViewType = .privacyPolicy
                        showWebView = true
                    }
                    
                    
                    // About the Developer
                    HStack(alignment: .center, spacing: 0) {
                        Text("About the Developer")
                            .foregroundStyle(.customYellow)
                            .font(.customFont(font: .semiBold, size: 20))
                        Spacer()
                        Image(.forward)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    .onTapGesture {
                        webViewType = .aboutDeveloper
                        showWebView = true
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 100)
                
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .navigationDestination(for: SettingsScreen.self) { screen in
                    switch screen {
                    case .main:
                        SettingsMainView()
                    case .unit:
                        UnitView()
                    case .curreency:
                        CurrencyView()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: $showWebView) {
                    if let url = URL(string: webViewType.urlString) {
                        WebViewScreen(url: url, type: webViewType)
                            .onAppear { tabbarService.isTabbarVisible = false }
                            .onDisappear { tabbarService.isTabbarVisible = true }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Settings")
                            .foregroundStyle(.customYellow)
                            .font(.customFont(font: .semiBold, size: 20))
                    }
                }
            }
            .alert(LocalPushError.notAuthorized.errorDescription ?? "", isPresented: $isShowPushAlert) {
                Button("Yes") {
                    openAppSettings()
                }
                
                Button("No") {}
            } message: {
                Text("Open settings?")
            }
            .onAppear {
                Task {
                    let result = try? await LocalPushService.shared.requestAuthorization()
                    toggl = (result ?? false) == true && isNotificationEnable
                }
            }
            .onChange(of: toggl) { isOn in
                if isOn {
                    Task {
                        let status = await LocalPushService.shared.currentAuthorizationStatus()
                        
                        switch status {
                            case .authorized:
                                isNotificationEnable = true
                                try? await LocalPushService.shared.createDailyNoonReminder()
                            default:
                                isShowPushAlert.toggle()
                                toggl = false
                        }
                    }
                } else {
                    isNotificationEnable = false
                    LocalPushService.shared.removeDailyNoonReminder()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsMainView()
            .environmentObject(AppRouter())
            .environmentObject(TabbarService())
    }
}
