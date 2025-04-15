import XCTest
import Combine
@testable import Conexa

class NewsViewModelTests: XCTestCase {

    var viewModel: NewsViewModel!
    var mockDataAccess: MockNewsDataAccess!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockDataAccess = MockNewsDataAccess()
        viewModel = NewsViewModel(dataAccess: mockDataAccess)
    }

    override func tearDown() {
        viewModel = nil
        mockDataAccess = nil
        cancellables = nil
        super.tearDown()
    }

    // Test: Las noticias se cargan correctamente
    func testGetNews_whenDataIsLoadedSuccessfully() {
        // Configuramos el mock para no devolver error
        mockDataAccess.shouldReturnError = false
        mockDataAccess.shouldReturnEmptyNews = false
        
        let expectation = XCTestExpectation(description: "Should load news and change state")
        
        // Subscríbete a los cambios de estado
        viewModel.$state
            .sink { state in
                if state == StatesEnum.success {
                    expectation.fulfill() // Si el estado es "success", cumplimos la expectativa
                }
            }
            .store(in: &cancellables)
        
        // Llamamos a la función que carga las noticias
        viewModel.getNews()
        
        // Esperamos hasta que la expectativa se cumpla (se actualice el estado)
        wait(for: [expectation], timeout: 2.0)
        
        // Verificamos el estado y los datos
        XCTAssertEqual(viewModel.state, StatesEnum.success)
        XCTAssertNotNil(viewModel.news)
        XCTAssertFalse(viewModel.news?.isEmpty ?? false)
    }

    // Test: Error al obtener las noticias
    func testGetNews_whenErrorOccurs() {
        mockDataAccess.shouldReturnError = true
        
        let expectation = XCTestExpectation(description: "Should handle error and update state")
        
        viewModel.$state
            .sink { state in
                if state == StatesEnum.error {
                    expectation.fulfill() // Si el estado es "error", cumplimos la expectativa
                }
            }
            .store(in: &cancellables)
        
        viewModel.getNews()
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertEqual(viewModel.state, StatesEnum.error)
        XCTAssertNil(viewModel.news)
    }

    // Test: El servicio devuelve una lista vacía de noticias
    func testGetNews_whenEmptyListIsReturned() {
        mockDataAccess.shouldReturnEmptyNews = true
        
        let expectation = XCTestExpectation(description: "Should return empty news list and update state")
        
        viewModel.$state
            .sink { state in
                if state == StatesEnum.success {
                    expectation.fulfill() // Si el estado es "success", cumplimos la expectativa
                }
            }
            .store(in: &cancellables)
        
        viewModel.getNews()
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertEqual(viewModel.state, StatesEnum.success)
        XCTAssertNotNil(viewModel.news)
        XCTAssertTrue(viewModel.news?.isEmpty ?? false)
    }
}
