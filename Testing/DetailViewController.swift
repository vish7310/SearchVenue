//
//  DetailViewController.swift
//  Testing
//
//  Created by Ravenous on 16/12/17.
//  Copyright © 2017 Ravenous. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    // MARK: - ====================  Passing Variable ====================
    var passModel = VenuesListModel()
    
    // MARK: - ====================  All IBOutlet  ====================
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPepoleThere: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        
        // Set Value 
        self.lblName.text = passModel.name
        if (passModel.contact.object(forKey: "formattedPhone") as? String != "") {
            self.lblPhoneNumber.text = passModel.contact.object(forKey: "formattedPhone") as? String
        }
        self.lblPepoleThere.text = String(describing: passModel.hereNow.object(forKey: "count")!)
        self.lblAddress.text = (passModel.location.object(forKey: "formattedAddress") as? NSArray)?.componentsJoined(by: "")
        
    }

    @IBAction func btnGoTOLocation(_ sender: UIButton) {
        openMapForPlace()
    }
    
     // MARK: - ====================  Open Map AND Go To Place  ====================
    func openMapForPlace() {

        
        let lat = ((passModel.location.object(forKey: "labeledLatLngs") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "lat") as! NSNumber
        let long = ((passModel.location.object(forKey: "labeledLatLngs") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "lng") as! NSNumber
        
        let latitude: CLLocationDegrees = Double(lat.stringValue as String)!
        let longitude: CLLocationDegrees = Double(long.stringValue as String)!
        
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = ""
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
 

}
