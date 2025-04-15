import Foundation
import Combine

protocol NewsDataAccessInterface {
    func getNews() -> AnyPublisher<(mensaje: String, modelo: [NewsModel]?), Error>
}

class NewsDataAccess: NewsDataAccessInterface {
    func getNews() -> AnyPublisher<(mensaje: String, modelo: [NewsModel]?), Error> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> (mensaje: String, modelo: [NewsModel]?) in
                let posts = try JSONDecoder().decode([NewsModel].self, from: result.data)
                return (mensaje: "SuccessGetNews", modelo: posts)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class MockNewsDataAccess: NewsDataAccessInterface {
    var shouldReturnError = false
    var shouldReturnEmptyNews = false

    func getNews() -> AnyPublisher<(mensaje: String, modelo: [NewsModel]?), Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        } else if shouldReturnEmptyNews {
            return Just(("Success", []))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            let news = [NewsModel(id: 1, title: "Sample News", body: "This is a sample news item.")]
            return Just(("Success", news))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
