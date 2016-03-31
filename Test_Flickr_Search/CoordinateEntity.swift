//
//  Coordinate.swift
//  Test_Flickr_Search
//
//  Created by Alexsander  on 3/31/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import Foundation
import CoreLocation

public class CoordinateEntity {
    public var latitude: Double!
    public var longitude: Double!
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}