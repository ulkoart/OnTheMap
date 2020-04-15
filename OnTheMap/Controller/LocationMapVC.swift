//
//  MapVC.swift
//  OnTheMap
//
//  Created by user on 13.04.2020.
//  Copyright © 2020 ulkoart. All rights reserved.
//

import UIKit
import MapKit

class LocationMapVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        loadLocationData()
        
    }
    
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        loadLocationData()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        UdacityClient.logout(completionHandler: self.handlerLogoutResponse(result:error:))
    }
    

    
    func handlerLogoutResponse(result: Bool?, error: Error?) -> Void {
        DispatchQueue.main.async {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func addAnnotationsOnMap(_ locations: [Location]) {
        for location in locations {
            
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        
    }
    
    func handlerLoadLocationDataResponse(data: [Location], error: Error?) -> Void {
        
        activityIndicator.isHidden = true
        refreshButton.isEnabled = true
        
        if (error != nil) {
            showLoginFailure(message: error?.localizedDescription ?? "")
            return
        }
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.locations.removeAll()
        appDelegate.locations.append(contentsOf: data)
        addAnnotationsOnMap(appDelegate.locations)
        self.mapView.addAnnotations(annotations)
        
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func loadLocationData() {
        activityIndicator.isHidden = false
        refreshButton.isEnabled = false
        UdacityClient.studentLocations(completionHandler: self.handlerLoadLocationDataResponse(data:error:))
        
    }
}

extension LocationMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
}
