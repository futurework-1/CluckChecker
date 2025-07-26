import Foundation

final class ArticlesViewModel: ObservableObject {

    let articles = articleData.articles // Массив всех статей (статические данные)

    /// Индекс выбранной статьи (или nil, если не выбрана)
    @Published var selectedArticleIndex: Int? = nil

    /// Получить выбранную статью для ArticleDetailView
    var selectedArticle: Article? {
        guard let index = selectedArticleIndex, articles.indices.contains(index) else { return nil }
        return articles[index]
    }

    /// Обработать тап по статье
    func selectArticle(at index: Int) {
        guard articles.indices.contains(index) else { return }
        selectedArticleIndex = index
    }
}
