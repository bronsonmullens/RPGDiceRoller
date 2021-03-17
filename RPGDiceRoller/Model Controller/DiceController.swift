//
//  DiceController.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/16/21.
//

import UIKit
import CoreData

class DiceController {
    
    // MARK: - Properties
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var diceBag: [Dice] = []
    
    // MARK: - Methods
    
    func getAllDice() {
        do {
            let dice = try context.fetch(Dice.fetchRequest()) as! [Dice]
            diceBag = dice
        } catch {
            NSLog("Error: Could not load dice: \(error.localizedDescription)")
        }
    }
    
    func createDice(name: String, sides: Int) {
        let newDice = Dice(context: context)
        newDice.name = name
        newDice.sides = Int16(sides)
        
        do {
            try context.save()
            getAllDice()
        } catch {
            NSLog("Error occured when attempt to save dice: \(error.localizedDescription)")
        }
    }
    
    func deleteDice(dice: Dice) {
        context.delete(dice)
        
        do {
            try context.save()
        } catch {
            NSLog("Error occured when attempt to save dice: \(error.localizedDescription)")
        }
    }
    
    func deleteAllDice() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Dice")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
        try context.execute(request)
        try context.save()
        getAllDice()
        } catch {
            NSLog("Error occured when deleting all saved dice. \(error.localizedDescription)")
        }
    }
    
}
