//
//  GeolocationViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 3.01.26.
//

import UIKit
import MapKit

class GeolocationViewController: UIViewController {
    
    let geoView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let locationManager = CLLocationManager()
    
    var path: MKOverlay?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupSubviews()
        setupConstraints()
        
    }
    
    
    
    func setupMap() {
        geoView.delegate = self
        geoView.mapType = .hybrid
        geoView.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
        
        let anatation = MKPointAnnotation()
        anatation.coordinate = CLLocationCoordinate2D(latitude: 53.9, longitude: 27.5667)
        anatation.title = "Minsk"
        geoView.addAnnotation(anatation)
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        geoView.addGestureRecognizer(tapGesture)
    }
    
    func setupSubviews() {
        view.addSubview(geoView)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            geoView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            geoView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            geoView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            geoView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    @objc private func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: geoView)
        let coordinateDestination = geoView.convert(point, toCoordinateFrom: geoView)
        
        let userLocation = geoView.userLocation.coordinate
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinateDestination))
        
        let direction = MKDirections(request: request)
        direction.calculate { response, error in
            if let error {
                print("error response: \(error)")
                return
            }
            if let route = response!.routes.first {
                if let overlay = self.path {
                    self.geoView.removeOverlay(overlay)
                    self.path = route.polyline
                } else {
                    self.path = route.polyline
                }
                self.geoView.addOverlay(self.path!)
                
            }
        }
    }
}

extension GeolocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        geoView.setRegion(MKCoordinateRegion(center: locations.first!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
    }
}

extension GeolocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let render = MKPolylineRenderer(polyline: polyline)
            
            render.strokeColor = .black
            render.lineWidth = 4
            return render
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
