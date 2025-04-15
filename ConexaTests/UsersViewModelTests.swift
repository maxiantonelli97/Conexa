import XCTest
import Combine
@testable import Conexa

class UsersViewModelTests: XCTestCase {
    
    var viewModel: UsersViewModel!
    var mockDataAccess: MockUsersDataAccess!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockDataAccess = MockUsersDataAccess()
        viewModel = UsersViewModel(dataAccess: mockDataAccess)
    }

    override func tearDown() {
        viewModel = nil
        mockDataAccess = nil
        cancellables = nil
        super.tearDown()
    }

    // Test: Los usuarios se cargan correctamente
    func testGetUsers_whenDataIsLoadedSuccessfully() {
        // Configuramos el mock para no devolver error
        mockDataAccess.shouldReturnError = false
        mockDataAccess.shouldReturnEmptyUsers = false
        
        let expectation = XCTestExpectation(description: "Should load users and change state")
        
        // Subscríbete a los cambios de estado
        viewModel.$state
            .sink { state in
                if state == StatesEnum.success {
                    expectation.fulfill() // Si el estado es "success", cumplimos la expectativa
                }
            }
            .store(in: &cancellables)
        
        // Llamamos a la función que carga los usuarios
        viewModel.getUsers()
        
        // Esperamos hasta que la expectativa se cumpla (se actualice el estado)
        wait(for: [expectation], timeout: 2.0)
        
        // Verificamos el estado y los datos
        XCTAssertEqual(viewModel.state, StatesEnum.success)
        XCTAssertNotNil(viewModel.users)
        XCTAssertFalse(viewModel.users?.isEmpty ?? false)
    }

    // Test: Error al obtener los usuarios
    func testGetUsers_whenErrorOccurs() {
        mockDataAccess.shouldReturnError = true
        
        let expectation = XCTestExpectation(description: "Should handle error and update state")
        
        viewModel.$state
            .sink { state in
                if state == StatesEnum.error {
                    expectation.fulfill() // Si el estado es "error", cumplimos la expectativa
                }
            }
            .store(in: &cancellables)
        
        viewModel.getUsers()
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertEqual(viewModel.state, StatesEnum.error)
        XCTAssertNil(viewModel.users)
    }

    // Test: Servicio devuelve lista vacía de usuarios
    func testGetUsers_whenEmptyListIsReturned() {
        mockDataAccess.shouldReturnEmptyUsers = true
        
        let expectation = XCTestExpectation(description: "Should return empty users list and update state")
        
        viewModel.$state
            .sink { state in
                if state == StatesEnum.success {
                    expectation.fulfill() // Si el estado es "success", cumplimos la expectativa
                }
            }
            .store(in: &cancellables)
        
        viewModel.getUsers()
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertEqual(viewModel.state, StatesEnum.success)
        XCTAssertNotNil(viewModel.users)
        XCTAssertTrue(viewModel.users?.isEmpty ?? false)
    }
}
