//
//  ViewController.swift
//  ConvertIt
//
//  Created by James Cassidy on 2/24/19.
//  Copyright © 2019 James Cassidy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    @IBOutlet weak var signSegment: UISegmentedControl!
    
    var formulaArray = ["kilometers to miles", "miles to kilometers", "feet to meters", "meters to feet", "yards to meters", "meters to yards", "inches to cm", "cm to inches", "Fahrenheit to Celsius", "Celsius to Fahrenheit", "quarts to liters", "liters to quarts"]
    
    var fromUnits = ""
    var toUnits = ""
    var conversionString = ""
    
    //MARK:- Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaPicker.delegate = self
        formulaPicker.dataSource = self
        conversionString = formulaArray[formulaPicker.selectedRow(inComponent: 0)]
        userInput.becomeFirstResponder()
        signSegment.isHidden = true
    }
    
    func calculateConversion() {
        
        guard let inputValue = Double(userInput.text!) else {
            if userInput.text != "" {
            showAlert(title: "Cannot Convert Value", message: "\"\(userInput.text!)\" is not a valid number")
            }
            return
        }
        var outputValue = 0.0
        switch conversionString {
        case "miles to kilometers" :
            outputValue = inputValue / 0.62137
        case "kilometers to miles" :
            outputValue = inputValue * 0.62137
        case "feet to meters" :
            outputValue = inputValue / 3.2808
        case "meters to feet" :
            outputValue = inputValue * 3.2808
        case "yards to meters" :
            outputValue = inputValue / 1.0936
        case "meters to yards" :
            outputValue = inputValue * 1.0936
        case "inches to cm" :
            outputValue = inputValue / 0.3937
        case "cm to inches" :
            outputValue = inputValue * 0.3937
        case "fahrenheit to celsius" :
            outputValue =
            (inputValue - 32) / (5/9)
        case "celsius to fahrenheit" :
            outputValue =
            (inputValue * (9/5)) + (32)
        case "quarts to liters" :
            outputValue = inputValue / 1.05669
        case "liters to quarts" :
            outputValue = inputValue * 1.05669
        default :
            showAlert(title: "Unexpected Error", message: "Contact Developer and share \"\(conversionString)\"")
        }
        
        let formatString = (decimalSegment.selectedSegmentIndex < decimalSegment.numberOfSegments -  1 ? "%.\(decimalSegment.selectedSegmentIndex + 1)f" : "%f")
        let outputString = String(format: formatString, outputValue)
        resultsLabel.text = "\(inputValue) \(fromUnits) = \(outputString) \(toUnits)"
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK:- IBAction
    
    @IBAction func userInputChanged(_ sender: UITextField) {
        resultsLabel.text = ""
        if userInput.text?.first == "-" {
            signSegment.selectedSegmentIndex = 1
        } else {
            signSegment.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func signSelected(_ sender: UISegmentedControl) {
        if signSegment.selectedSegmentIndex == 0 {
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
        } else {
            userInput.text = "- \(userInput.text!)"
        }
        if userInput.text != "-" {
        calculateConversion()
        }
    }
    
    @IBAction func decimalSelected(_ sender: UISegmentedControl) {
        calculateConversion()
    }
    
    @IBAction func convertButtonPressed(_ sender: UIButton) {
        calculateConversion()
    }
}

//MARK:- Picker

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulaArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formulaArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        conversionString = formulaArray[row]
        
        if conversionString.lowercased().contains("celsius") {
            signSegment.isHidden = false
        } else {
            signSegment.isHidden = true
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
        }
        
        let unitsArray = formulaArray[row].components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        resultsLabel.text = toUnits
        calculateConversion()
        
    }
    
}
