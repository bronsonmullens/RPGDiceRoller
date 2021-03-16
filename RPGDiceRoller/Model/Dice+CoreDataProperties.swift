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

    @NSManaged public var name: String?
    @NSManaged public var value: Int16

}

extension Dice : Identifiable {

}
