//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by user on 15.04.2020.
//  Copyright © 2020 ulkoart. All rights reserved.
//

import UIKit
import MapKit

class AddLocationVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocationCoordinate2D?
    var link: String?
    var locationtext: String?
    
    var student: Student! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.student
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location!
        mapView.addAnnotation(annotation)
        mapView.setCenter(location!, animated: true)
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        let studentLocation = StudentLocation(firstName: student.firstName, lastName: student.lastName, longitude: location!.longitude, latitude: location!.latitude, mapString: locationtext ?? "", mediaURL: link!, uniqueKey: student.key)
        
        UdacityClient.addLocation(studentLocation: studentLocation) { (result, error) in
            if result {
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
                
            else {
                let alert = UIAlertController(title: "Error!", message: "Error add location.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
        }
        
        
        
    }
}
