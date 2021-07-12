//
//  ViewController.swift
//  SmokingFree
//
//  Created by Jeongho Han on 2021-06-04.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkLabel: UILabel!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    // Configure UI when load the view
    func configureUI(){
        
        // Check if the date is changed
        if K.DB.integer(forKey: K.targetDay) != K.CurrentDate.today {
            calendarDayDidChange()
        }

        moneyLabel.text = formatToNumber(num: K.DB.integer(forKey: K.totalKey))


        let isDone = K.DB.bool(forKey: K.isDoneKey)

        // If the user already clicked the check button today, it doesnt appear on the app until the midnight
        if isDone {
            checkButton.isHidden = true
            checkLabel.isHidden = false
        }
        else{
            checkButton.isHidden = false
            checkLabel.isHidden = true
        }
    }
    
    // Increase week and month data by 1 when user clicks the button
    private func saveIntoDB(){
        
        // Increase current week data by 1
        let thisWeek = K.DB.integer(forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentWeek)")
        
        K.DB.set(thisWeek + 1, forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentWeek)")
        
        // Increase current month data by 1
        let thisMonth = K.DB.integer(forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentMonth)")
        
        K.DB.set(thisMonth + 1, forKey: "\(K.CurrentDate.currentYear)/\(K.CurrentDate.currentMonth)")
    }
    
    // Format the number to show the total saved money
    private func formatToNumber(num: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:num)) ?? "0"
        
        return "$ \(formattedNumber)"
    }
    
    
    // Reset button UI when the date is changed
    private func calendarDayDidChange()
    {
        K.DB.set(false, forKey: K.isDoneKey)
        checkButton.isHidden = false
        checkLabel.isHidden = true
    }
    
    // Remove all UserDefault data
//    private func removeAllUserDefaults(){
//        let defaults = UserDefaults.standard
//        let dictionary = defaults.dictionaryRepresentation()
//        dictionary.keys.forEach { key in
//            defaults.removeObject(forKey: key)
//        }
//    }
    
    // MARK: - IBAction
    
    @IBAction func checkPressed(_ sender: UIButton) {
        let total = K.DB.integer(forKey: K.totalKey)
        
        // Increase the total money
        K.DB.set(total + 15, forKey: K.totalKey)
        
        moneyLabel.text = formatToNumber(num: K.DB.integer(forKey: K.totalKey))
        
        // Save into UserDefaults
        saveIntoDB()
        
        // Update Button and Label
        checkButton.isHidden = true
        checkLabel.isHidden = false
        
        // set isDone to true, so the save button doesn't appear on the app
        K.DB.set(true, forKey: K.isDoneKey)
        
        // Set today as the target day, so the app can check if the date is changed
        K.DB.set(K.CurrentDate.today, forKey: K.targetDay)
    }
}

