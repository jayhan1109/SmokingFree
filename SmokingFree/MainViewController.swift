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
        
        // Update app at midnight
        NotificationCenter.default.addObserver(self, selector:#selector(calendarDayDidChange), name:.NSCalendarDayChanged, object:nil)
        
        moneyLabel.text = formatToNumber(num: K.DB.integer(forKey: K.totalKey))
        
        let isDone: Bool? = K.DB.bool(forKey: K.isDoneKey)
        
        if isDone != nil{
            if isDone! {
                checkButton.isHidden = true
                checkLabel.isHidden = false
            }else{
                checkButton.isHidden = false
                checkLabel.isHidden = true
            }
        }else{
            checkButton.isHidden = false
            checkLabel.isHidden = true
        }
    }
    
    @IBAction func checkPressed(_ sender: UIButton) {
        let total: Int? = K.DB.integer(forKey: K.totalKey)

        if total != nil{
            K.DB.set(total! + 15, forKey: K.totalKey)
        }else{
            K.DB.set(15, forKey: K.totalKey)
        }
        
         // Remove Total
        // K.DB.removeObject(forKey: K.totalKey)
        
        moneyLabel.text = formatToNumber(num: K.DB.integer(forKey: K.totalKey))
        
        // Save into UserDefaults
        saveIntoDB()
        
        // Update Button and Label
        checkButton.isHidden = true
        checkLabel.isHidden = false
        
        K.DB.set(true, forKey: K.isDoneKey)
    }
    
    func saveIntoDB(){
        // Week
        let thisWeek:Int? = K.DB.integer(forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentWeek)")
        
        if thisWeek != nil{
            K.DB.set(thisWeek! + 1, forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentWeek)")
        }else{
            K.DB.set(1, forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentWeek)")
        }
        
        // Month
        let thisMonth:Int? = K.DB.integer(forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentMonth)")
        
        if thisMonth != nil{
            K.DB.set(thisMonth! + 1, forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentMonth)")
        }else{
            K.DB.set(1, forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentMonth)")
        }
        
        print("\(K.CurrentDate.currentMonth): \(thisMonth!+1)")
        print("\(K.CurrentDate.currentWeek): \(thisWeek!+1)")
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
}

