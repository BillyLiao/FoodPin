//
//  Restaurant.swift
//  FoodPin
//
//  Created by 廖慶麟 on 2016/2/20.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import Foundation
import CoreData

class Restaurant:NSManagedObject {
    
    @NSManaged var name:String!
    @NSManaged var type:String!
    @NSManaged var location:String!
    @NSManaged var image:NSData!
    @NSManaged var isVisited:NSNumber!
    
}