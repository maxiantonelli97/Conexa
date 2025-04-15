import SwiftUI
import GoogleMaps
import Foundation

@main
struct ConexaApp: App {
    
    init() {
        DispatchQueue.global(qos: .background).async {
            guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
                  let data = try? Data(contentsOf: url),
                  let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
                  let key = plist["MAP_API_KEY"] as? String else {
                NSLog("MAP_API_KEY no encontrado en Secrets.plist")
                return
            }
            GoogleMapsManager.shared.initialize(with: key)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                           VStack {
                               NewsView()
                           }
                           .navigationBarTitle(NSLocalizedString("NewsTitle", comment: ""), displayMode: .inline)
                       }.tabItem {
                        Label(NSLocalizedString("NewsTitle", comment: ""), systemImage: "newspaper.fill")
                    }
                NavigationView {
                           VStack {
                               UsersView()
                           }
                           .navigationBarTitle(NSLocalizedString("UsersTitle", comment: ""), displayMode: .inline)
                       }.tabItem {
                           Label(NSLocalizedString("UsersTitle", comment: ""), systemImage: "person.fill")
                       }
            }
        }
    }
}
