import Foundation
import Combine

class NewsViewModel: ObservableObject {

    @Published var news: [NewsModel]? = nil

    @Published var state = StatesEnum.loading

    let dataAccess: NewsDataAccessInterface
    
    var cancellables = Set<AnyCancellable>()
    
    init(dataAccess: NewsDataAccessInterface) {
            self.dataAccess = dataAccess
        }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func getNews() {
        state = StatesEnum.loading
            dataAccess.getNews()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    switch value {
                    case .failure:
                        self?.state = StatesEnum.error
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] (mensaje: String, modelo: [NewsModel]?) in
                    guard let modelo = modelo else {return}
                    self?.news = modelo
                    self?.state = StatesEnum.success
                }
                .store(in: &cancellables)
    }
}
