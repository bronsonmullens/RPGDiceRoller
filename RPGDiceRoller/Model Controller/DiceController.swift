//
//  DiceController.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/16/21.
//

import UIKit
import CoreData

protocol DiceControllerDelegate {
    func diceWereDeleted()
}

class DiceController {
    
    // MARK: - Properties
    
    static let shared = DiceController()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var diceBag: [Dice] = []
    var delegate: DiceControllerDelegate?
    
    // MARK: - Dice Methods
    
    func roll(sides: Int, amount: Int) -> [Int] {
        var result = [0,0]
        var count = amount
        while count >= 1 {
            let roll = Int.random(in: 1...sides)
            result[0] += roll
            count -= 1
        }
        
        return result
    }
    
    func rollWithAdvantage(sides: Int, amount: Int) -> [Int] {
        var result1 = 0
        var result2 = 0
        var results = [0,0]
        var count = amount
        
        while count >= 1 {
            let roll = Int.random(in: 1...sides)
            result1 += roll
            count -= 1
        }
        
        count = amount
        
        while count >= 1 {
            let roll = Int.random(in: 1...sides)
            result2 += roll
            count -= 1
        }
        
        if result1 > result2 {
            results[0] = result1
            results[1] = result2
        } else {
            results[0] = result2
            results[1] = result1
        }
        return results
    }
    
    func rollWithDisadvantage(sides: Int, amount: Int) -> [Int] {
        var result1 = 0
        var result2 = 0
        var results = [0,0]
        var count = amount
        
        while count >= 1 {
            let roll = Int.random(in: 1...sides)
            result1 += roll
            count -= 1
        }
        
        count = amount
        
        while count >= 1 {
            let roll = Int.random(in: 1...sides)
            result2 += roll
            count -= 1
        }
        
        if result1 < result2 {
            results[1] = result1
            results[0] = result2
        } else {
            results[1] = result2
            results[0] = result1
        }
        return results
    }
    
    // MARK: - CRUD Methods
    
    func getAllDice() {
        do {
            let dice = try context.fetch(Dice.fetchRequest()) as! [Dice]
            diceBag = dice
        } catch {
            NSLog("Error: Could not load dice: \(error.localizedDescription)")
        }
    }
    
    func createDice(name: String, sides: Int) -> Bool {
        for dice in diceBag {
            if dice.sides == sides {
                return false
            }
        }
        
        let newDice = Dice(context: context)
        newDice.name = name
        newDice.sides = Int64(sides)
        
        do {
            try context.save()
            getAllDice()
        } catch {
            NSLog("Error occured when attempt to save dice: \(error.localizedDescription)")
        }
        return true
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
            delegate?.diceWereDeleted()
        } catch {
            NSLog("Error occured when deleting all saved dice. \(error.localizedDescription)")
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            NSLog("Error occured when attempt to save dice: \(error.localizedDescription)")
        }
    }
    
}
