import SwiftUI

struct ArticlesMainView: View {
    /// Роутер для навигации
    @EnvironmentObject private var appRouter: AppRouter
    
    @StateObject var viewModel = ArticlesViewModel()
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        NavigationStack(path: $appRouter.articlesRoute) {
            ZStack(alignment: .center) {
                MainBGView()
                
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    // Первый блок
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Spring Care")
                            .font(.customFont(font: .semiBold, size: 12))
                            .opacity(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Increase protein in the diet to help hens recover after winter. Clean the coop thoroughly, check for parasites, and start introducing fresh greens")
                            .font(.customFont(font: .semiBold, size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                    .padding(.bottom, 24)
                    
                    // Статьи
                    ForEach(Array(viewModel.articles.enumerated()), id: \ .element.title) { index, article in
                        HStack(alignment: .center, spacing: 0) {
                            Text(article.title)
                                .font(.customFont(font: .semiBold, size: 15))
                            
                            Spacer()
                            
                            Image(.forward)
                                .padding(.leading, 20)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(.customBraun))
                        .padding(.bottom, 14)
                        .onTapGesture {
                            print("Selected article: \(article.title)")
                            viewModel.selectArticle(at: index)
                            appRouter.articlesRoute.append(.detail)
                        }
                    }
                    
                    Spacer()
                }
                .foregroundStyle(.customYellow)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.horizontal, 14)
                .padding(.bottom, AppConfig.tabbarBottomPadding + AppConfig.tabbarHeight + 20)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Articles and advice")
                            .foregroundStyle(.customYellow)
                            .font(.customFont(font: .semiBold, size: 20))
                    }
                }
                .navigationDestination(for: ArticlesScreen.self) { screen in
                    switch screen {
                    case .main:
                        ArticlesMainView()
                    case .detail:
                        ArticleDetailView()
                            .environmentObject(viewModel)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ArticlesMainView()
        .environmentObject(AppRouter())
        .environmentObject(ArticlesViewModel())
}



