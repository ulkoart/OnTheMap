//
//  LocationTableVC.swift
//  OnTheMap
//
//  Created by user on 13.04.2020.
//  Copyright © 2020 ulkoart. All rights reserved.
//

import UIKit

class LocationTableVC: UITableViewController {
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locations: [Location]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.locations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        activityIndicator.isHidden = false
        refreshButton.isEnabled = false
        UdacityClient.studentLocations(completionHandler: self.handlerLoadLocationDataResponse(data:error:))
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        UdacityClient.logout(completionHandler: self.handlerLogoutResponse(result:error:))
    }
    
    
    func handlerLogoutResponse(result: Bool?, error: Error?) -> Void {
        DispatchQueue.main.async {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func handlerLoadLocationDataResponse(data: [Location], error: Error?) -> Void {
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.locations.removeAll()
        self.tableView.reloadData()
        appDelegate.locations.append(contentsOf: data)
        
        self.tableView.reloadData()
        activityIndicator.isHidden = true
        refreshButton.isEnabled = true
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")!
        let location = locations[indexPath.row]
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel?.text = location.mediaURL
        cell.imageView!.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        if let url = URL(string: location.mediaURL) {
            UIApplication.shared.open(url)
        }
        
    }
    
}
