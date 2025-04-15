import Foundation
import Combine

protocol UsersDataAccessInterface {
    func getUsers() -> AnyPublisher<(mensaje: String, modelo: [UsersModel]?), Error>
}

class UsersDataAccess: UsersDataAccessInterface {
    public func getUsers() -> AnyPublisher<(mensaje: String, modelo: [UsersModel]?), Error> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> (mensaje: String, modelo: [UsersModel]?) in
                let posts = try JSONDecoder().decode([UsersModel].self, from: result.data)
                return (mensaje: "SuccessGetUsers", modelo: posts)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class MockUsersDataAccess: UsersDataAccessInterface {
    
    var shouldReturnError = false
    var shouldReturnEmptyUsers = false
    
    func getUsers() -> AnyPublisher<(mensaje: String, modelo: [UsersModel]?), Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        } else if shouldReturnEmptyUsers {
            return Just(("Success", []))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            let users = [UsersModel(
                id: 0, name: "John Doe",
                username: "johndoe",
                address: AddressModel(geo: GeoModel(lat: "0", lng: "0")))]
            return Just(("Success", users))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
