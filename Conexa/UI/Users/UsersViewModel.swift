import Foundation
import Combine

class UsersViewModel: ObservableObject {
    
    @Published var users: [UsersModel]? = nil

    @Published var state = StatesEnum.loading

    let dataAccess: UsersDataAccessInterface
        
    init(dataAccess: UsersDataAccessInterface) {
        self.dataAccess = dataAccess
    }
    
    var cancellables = Set<AnyCancellable>()
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func getUsers() {
        state = StatesEnum.loading
            dataAccess.getUsers()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    switch value {
                    case .failure:
                        self?.state = StatesEnum.error
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] (mensaje: String, modelo: [UsersModel]?) in
                    guard let modelo = modelo else {return}
                    self?.users = modelo
                    self?.state = StatesEnum.success
                }
                .store(in: &cancellables)
    }
}
