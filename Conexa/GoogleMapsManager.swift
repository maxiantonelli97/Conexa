import GoogleMaps

final class GoogleMapsManager {
    static let shared = GoogleMapsManager()
    private(set) var isInitialized = false

    private init() {}

    func initialize(with apiKey: String) {
        guard !isInitialized else { return }
        GMSServices.provideAPIKey(apiKey)
        isInitialized = true
    }
}
