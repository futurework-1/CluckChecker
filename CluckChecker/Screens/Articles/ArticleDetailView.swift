import SwiftUI

struct ArticleDetailView: View {
    /// Роутер для навигации
    @EnvironmentObject private var appRouter: AppRouter
    
    @EnvironmentObject var viewModel: ArticlesViewModel
    
    var body: some View {
        
        ZStack(alignment: .center) {
            MainBGView()
            
            if let article = viewModel.selectedArticle {
                
                
                ScrollView {
                    Image(article.image)
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 20)
                    
                    HStack(alignment: .center, spacing: 0) {
                        Text(article.title)
                            .font(.customFont(font: .semiBold, size: 20))
                            .padding(.bottom, 20)
                        
                        Spacer()
                    }
                    
                    Text(article.text)
                        .font(.customFont(font: .semiBold, size: 18))
                        .opacity(0.5)
                }
                .navigationBarBackButtonHidden()
                .padding(.horizontal)
                .padding(.top, 88)
                .padding(.bottom, AppConfig.tabbarBottomPadding + AppConfig.tabbarHeight + 40)
                .foregroundStyle(.customYellow)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            appRouter.articlesRoute.removeAll()
                        } label: {
                            Image(.backButton)
                        }
                    }
                }
                .onDisappear {
                    appRouter.articlesRoute.removeAll()
                }
            }
        }
    }
}


#Preview {
    ArticleDetailView()
        .environmentObject(AppRouter())
        .environmentObject(ArticlesViewModel())
}
