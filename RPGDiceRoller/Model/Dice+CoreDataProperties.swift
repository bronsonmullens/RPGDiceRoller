//
//  Dice+CoreDataProperties.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/16/21.
//
//

import Foundation
import CoreData


extension Dice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dice> {
        return NSFetchRequest<Dice>(entityName: "Dice")
    }

    @NSManaged public var order: Int64
    @NSManaged public var name: String?
    @NSManaged public var sides: Int64

}

extension Dice : Identifiable {

}
