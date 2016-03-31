//
//  PhotoEntity+CoreDataProperties.swift
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

extension PhotoEntity {

    @NSManaged var remoteID: String?
    @NSManaged var owner: String?
    @NSManaged var secret: String?
    @NSManaged var server: String?
    @NSManaged var farm: NSNumber?
    @NSManaged var title: String?
    @NSManaged var ispublic: NSNumber?
    @NSManaged var isfriend: NSNumber?
    @NSManaged var isfamily: NSNumber?

}
