//
//  AddCityViewController.swift
//  CitiesILike
//
//  Created by CS3714 on 10/2/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

/*
 --------------------------------
 MARK: - Add City View Controller
 --------------------------------
 */
class AddCityViewController: UIViewController {
    
    // Instance variable holding the object reference of the UITextField UI object created in the Interface Builder (IB), i.e., Storyboard
    @IBOutlet var countryNameTextField: UITextField!
    
    // Instance variable holding the object reference of the UITextField UI object created in the Interface Builder (IB), i.e., Storyboard
    @IBOutlet var cityNameTextField: UITextField!
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /*
     ---------------------------------
     MARK: - Keyboard Handling Methods
     ---------------------------------
     */
    
    // This method is invoked when the user taps the Done key on the keyboard
    @IBAction func keyboardDone(_ sender: UITextField) {
        
        // Once the text field is no longer the first responder, the keyboard is removed
        sender.resignFirstResponder()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /*
         "A UITouch object represents the presence or movement of a finger on the screen for a particular event." [Apple]
         We store the UITouch object's unique ID into the local variable touch.
         */
        if let touch = touches.first {
            /*
             When the user taps within a text field, that text field becomes the first responder.
             When a text field becomes the first responder, the system automatically displays the keyboard.
             */
            
            // If countryNameTextField is first responder and the user did not touch the countryNameTextField
            if countryNameTextField.isFirstResponder && (touch.view != countryNameTextField) {
                
                // Make countryNameTextField to be no longer the first responder.
                countryNameTextField.resignFirstResponder()
            }
            
            // If cityNameTextField is first responder and the user did not touch the cityNameTextField
            if cityNameTextField.isFirstResponder && (touch.view != cityNameTextField) {
                
                // Make cityNameTextField to be no longer the first responder.
                cityNameTextField.resignFirstResponder()
            }
        }
        super.touchesBegan(touches, with:event)
    }
    
    
}
