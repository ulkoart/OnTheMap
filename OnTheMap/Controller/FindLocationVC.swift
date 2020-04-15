//
//  FindLocationVC.swift
//  OnTheMap
//
//  Created by user on 15.04.2020.
//  Copyright © 2020 ulkoart. All rights reserved.
//

import UIKit
import MapKit

class FindLocationVC: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var location: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        linkTextField.delegate = self
        updateIndicator(true)
        
    }
    
    @IBAction func findLocationButtonPressed(_ sender: UIButton) {
        
        updateIndicator(false)
        
        if linkTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Link field is empty!", message: "Fill link field and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            updateIndicator(true)
            return
        }
        
        getCoordinate(addressString: locationTextField.text!, completionHandler: self.handlerGetCoordinate(coordinate:error:))
        
        
    }
    
    func updateIndicator(_ state: Bool) {
        findLocationButton.isHidden = !state
        activityIndicator.isHidden = state
    }
    
    func handlerGetCoordinate (coordinate:CLLocationCoordinate2D , error: NSError?) {
        
        if (error != nil) {
            updateIndicator(true)
            let alert = UIAlertController(title: "Sorry!", message: "We could not find such a place on the map.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            return
            
        }
        
        location = coordinate
        updateIndicator(true)
        performSegue(withIdentifier: "showAddLocation", sender: (Any).self)
    }
    
    
    func getCoordinate(addressString : String,
                       completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddLocation" {
            let vc = segue.destination as! AddLocationVC
            vc.location = location
            vc.link = linkTextField.text
            vc.locationtext = locationTextField.text
        }
    }
    
    
}


extension FindLocationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
