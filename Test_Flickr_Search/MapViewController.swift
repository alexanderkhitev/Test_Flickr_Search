//
//  MapViewController.swift
//  Test_Flickr_Search
//
//  Created by Alexsander  on 3/30/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - var and let 
    var coordinate: CoordinateEntity!
    
    // MARK: - IBOutlet 
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        mapSetting()
        print("map view controller", coordinate.latitude, coordinate.longitude)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    private func mapSetting() {
        mapView.delegate = self
        mapView.mapType = .SatelliteFlyover
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        
        let locationCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let camera = MKMapCamera()
        camera.centerCoordinate = locationCoordinate
        
        mapView.setCamera(camera, animated: true)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
