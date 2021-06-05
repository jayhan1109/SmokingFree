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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moneyLabel.text = formatToNumber(num: UserDefaults.standard.integer(forKey: K.totalKey))
    }
    @IBAction func checkPressed(_ sender: UIButton) {
        let total: Int? = UserDefaults.standard.integer(forKey: K.totalKey)
        
        if total != nil{
            UserDefaults.standard.set(total! + 15, forKey: K.totalKey)
        }else{
            UserDefaults.standard.set(15, forKey: K.totalKey)
        }
        
        // Remove Total
        // UserDefaults.standard.removeObject(forKey: K.totalKey)
        
        moneyLabel.text = formatToNumber(num: UserDefaults.standard.integer(forKey: K.totalKey))
        
        
    }
    
    func formatToNumber(num: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:num)) ?? "0"
        
        return "$ \(formattedNumber)"
    }
}

