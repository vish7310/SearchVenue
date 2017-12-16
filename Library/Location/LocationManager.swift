//
//  LocationManager.swift
//  RavenousDemoIAP
//
//  Created by GuruUgam on 7/23/16.
//  Copyright © 2016 GuruUgam. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationManager: NSObject,CLLocationManagerDelegate {
    
    static var instance: LocationManager!
    var appDelegate : AppDelegate!
    var locationManager = CLLocationManager()
    var locationCordinate = CLLocationCoordinate2D()
    
    //GPS Location Address
    var strName = ""
    var strThoroughFare = ""
    var strLocality = ""
    var strAdministrativeArea = ""
    var strPostCode = ""
    var strCountry = ""
    var strCountryCode = ""
    var addressString : String = ""
    
    var locationDefined = false
    var locationDenied = false
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    
    class func sharedInstance() -> LocationManager {
        self.instance = (self.instance ?? LocationManager())
        return self.instance
    }
    
    override init() {
        
        super.init()
        
        self.locationDefined = false
        self.locationDenied = false
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.locationManager = CLLocationManager()
        self.locationCordinate = CLLocationCoordinate2D(latitude: self.currentLatitude, longitude: self.currentLongitude)
        self.locationManager.delegate = self
        //self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.distanceFilter = 100.0     //1000.0
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        if UIDevice.current.model == "iPhone Simulator" {
            self.currentLongitude = 72.523706479027808
            self.currentLatitude = 23.048439531352841
            self.locationManager.startMonitoringSignificantLocationChanges()
        }else{
            self.locationManager.startUpdatingLocation()
            self.locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func requestAlwaysAuthorization(){
        
        let status = CLLocationManager.authorizationStatus();
        
        if(status == CLAuthorizationStatus.authorizedAlways){
            //appDelegate.isGPSLocationActive = YES
            return
        }
        
        if (status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.denied) {
            
            appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let title = (status == CLAuthorizationStatus.denied) ? NSLocalizedString("Location_off", comment: "") : NSLocalizedString("Location_Enabled", comment: "")
            let alertController = UIAlertController(title: title,message: NSLocalizedString("Location_Settings", comment: "") ,preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default, handler: {(action) in
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL.fileURL(withPath: UIApplicationOpenSettingsURLString), options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(fileURLWithPath:UIApplicationOpenSettingsURLString) as URL)
                }
            }))
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancle", comment: ""), style: .cancel, handler: {(action) in
            }))
            appDelegate.window?.rootViewController!.present(alertController, animated: true, completion: nil)
        }
            // The user has not enabled any location services. Request background authorization.
        else if (status == CLAuthorizationStatus.notDetermined) {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if(status == CLAuthorizationStatus.denied) {
            self.requestAlwaysAuthorization()
        }else if(status == CLAuthorizationStatus.authorizedAlways){
            //appDelegate.isGPSLocationActive = YES;
        }else{
            self.requestAlwaysAuthorization()
        }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.locationDefined = true
        self.locationDenied = true
        self.currentLatitude = locations[0].coordinate.latitude
        self.currentLongitude = locations[0].coordinate.longitude
        
        self.appDelegate.Latitude = NSString(format: "%f", Double(round(1000*self.currentLatitude)/1000)) as String!
        self.appDelegate.Longitude = NSString(format: "%f", Double(round(1000*self.currentLongitude)/1000)) as String!
        
        
        self.locationCordinate = CLLocationCoordinate2D(latitude: self.currentLatitude, longitude: self.currentLongitude)
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.currentLatitude, longitude: self.currentLongitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
            var placemark:CLPlacemark!
            
            if error == nil && placemarks!.count > 0 {
                placemark = placemarks![0] as CLPlacemark
                
                var address : String = ""
                
                if placemark.locality != nil {
                    address = address + placemark.locality! + ", "
                }
                if placemark.thoroughfare != nil {
                    address = address + placemark.thoroughfare! + ", "
                }
                if placemark.subThoroughfare != nil {
                    address = address + placemark.subThoroughfare! + ", "
                }
                if placemark.subAdministrativeArea != nil {
                    address = address + placemark.subAdministrativeArea! + ", "
                }
                if placemark.postalCode != nil {
                    address = address + placemark.postalCode! + " "
                }
                if placemark.country != nil {
                    address = address + placemark.country!
                }

                self.addressString = (address as NSCopying) as! String
                self.appDelegate.address = (address as NSCopying) as! String
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Addnotification), object: address)
            }else{
                
            }
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Addnotification), object: "No Address Found")
    }
}
