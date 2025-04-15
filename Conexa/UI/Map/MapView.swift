import SwiftUI
import GoogleMaps
import CoreLocation

struct MapView: View {
    
    var user: UsersModel

    init(user: UsersModel) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            if GoogleMapsManager.shared.isInitialized,
               let lat = stringToDoubleWithFourDecimalPlaces(user.address.geo.lat),
               let lng = stringToDoubleWithFourDecimalPlaces(user.address.geo.lng) {

                GoogleMapView(latitude: lat, longitude: lng)
                    .padding()

            } else {
                Label("No se pudo cargar el mapa", systemImage: "exclamationmark.triangle")
            }
        }
        .navigationBarTitle(user.name, displayMode: .inline)
    }
}

func stringToDoubleWithFourDecimalPlaces(_ string: String) -> Double? {
    if let number = Double(string) {
        return round(number * 10000) / 10000
    }
    return nil
}

struct GoogleMapView: UIViewRepresentable {
    var latitude: Double
    var longitude: Double
    var locationManager = CLLocationManager()
    var marker: GMSMarker?

    class Coordinator: NSObject, GMSMapViewDelegate, CLLocationManagerDelegate {
        var parent: GoogleMapView

        init(parent: GoogleMapView) {
            self.parent = parent
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }
            parent.updateMapLocation(location)
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error while getting location: \(error.localizedDescription)")
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 1)
        let mapView = GMSMapView(frame: .zero, camera: camera)

        mapView.delegate = context.coordinator

                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.title = NSLocalizedString("UserLocation", comment: "")
                marker.map = mapView
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
    }

    func updateMapLocation(_ location: CLLocation) {
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.animate(to: camera)
    }
}
