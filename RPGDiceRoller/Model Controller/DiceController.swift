//
//  DiceController.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/16/21.
//

import UIKit

class DiceController {
    
    // MARK: - Properties
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var diceBag: [Dice] = []
    
    // MARK: - Methods
    
    func getAllItems() {
        do {
            let dice = try context.fetch(Dice.fetchRequest()) as! [Dice]
            diceBag = dice
        } catch {
            NSLog("Error: Could not load dice: \(error.localizedDescription)")
        }
    }
    
    func createItem(name: String, sides: Int) {
        let newDice = Dice(context: context)
        newDice.name = name
        newDice.sides = Int16(sides)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            NSLog("Error: Could not save dice: \(error.localizedDescription)")
        }
    }
    
    func deleteItem(dice: Dice) {
        context.delete(dice)
        
        do {
            try context.save()
        } catch {
            NSLog("Error: Could not save dice: \(error.localizedDescription)")
        }
    }
    
}
