//
//  ImageEntity+CoreDataProperties.swift
//  Test_Flickr_Search
//
//  Created by Alexsander  on 3/31/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ImageEntity {

    @NSManaged var imageData: NSData?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var index: NSNumber?

}
