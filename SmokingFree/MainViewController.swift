//
//  ViewController.swift
//  SmokingFree
//
//  Created by Jeongho Han on 2021-06-04.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if K.DB.integer(forKey: K.targetDay) != K.CurrentDate.today {
            calendarDayDidChange()
        }

        moneyLabel.text = formatToNumber(num: K.DB.integer(forKey: K.totalKey))


        let isDone = K.DB.bool(forKey: K.isDoneKey)

        if isDone {
            checkButton.isHidden = true
            checkLabel.isHidden = false
        }
        else{
            checkButton.isHidden = false
            checkLabel.isHidden = true
        }
        
    }
    
    @IBAction func checkPressed(_ sender: UIButton) {
        let total = K.DB.integer(forKey: K.totalKey)
        
        
        K.DB.set(total + 15, forKey: K.totalKey)
        
        moneyLabel.text = formatToNumber(num: K.DB.integer(forKey: K.totalKey))
        
        // Save into UserDefaults
        saveIntoDB()
        
        // Update Button and Label
        checkButton.isHidden = true
        checkLabel.isHidden = false
        
        K.DB.set(true, forKey: K.isDoneKey)
        
        K.DB.set(K.CurrentDate.today, forKey: K.targetDay)
    }
    
    func saveIntoDB(){
        
        // Week
        let thisWeek = K.DB.integer(forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentWeek)")
        
        K.DB.set(thisWeek + 1, forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentWeek)")
        
        // Month
        let thisMonth = K.DB.integer(forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentMonth)")
        
        K.DB.set(thisMonth + 1, forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentMonth)")
    }
    
    func formatToNumber(num: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:num)) ?? "0"
        
        return "$ \(formattedNumber)"
    }
    
    @objc func calendarDayDidChange()
    {
        K.DB.set(false, forKey: K.isDoneKey)
        checkButton.isHidden = false
        checkLabel.isHidden = true
    }
    
    func removeAllUserDefaults(){
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

