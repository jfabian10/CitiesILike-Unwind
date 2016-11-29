//
//  CityTableViewController.swift
//  CitiesILike
//
//  Created by CS3714 on 10/2/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class CityTableViewController: UITableViewController {
    
    // Instance variable holding the object reference of the UITableView UI object created in the Interface Builder (IB), i.e., Storyboard
    @IBOutlet var countryCityTableView: UITableView!
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //---------- Create and Initialize the Arrays -----------------------
    
    var countryNames = [String]()
    
    // dataObjectToPass is the data object to pass to the downstream view controller
    var dataObjectToPass: [String] = ["", ""]
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Set up the Edit button on the left of the navigation bar to enable editing of the table view rows
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Set up the Add button on the right of the navigation bar to call the addCity method when tapped
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CityTableViewController.addCity(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        /*
         allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
         Therefore, typecast the AnyObject type keys to be of type String.
         The keys in the array are *unordered*; therefore, they need to be sorted.
         */
        countryNames = applicationDelegate.dict_Country_Cities.allKeys as! [String]
        
        // Sort the country names within itself in alphabetical order
        countryNames.sort { $0 < $1 }
    }
    
    /*
     -----------------------
     MARK: - Add City Method
     -----------------------
     */
    
    // The addCity method is invoked when the user taps the Add button created in viewDidLoad() above.
    func addCity(_ sender: AnyObject) {
        
        // Perform the segue named AddCity
        performSegue(withIdentifier: "AddCity", sender: self)
    }
    
    /*
     -----------------------------------------------------
     MARK: - AddCityViewControllerProtocol Protocol Method
     -----------------------------------------------------
     */
    @IBAction func unwindToCityTableViewController (segue : UIStoryboardSegue) {
        
        if segue.identifier == "AddCity-Save" {
            
            // Obtain the object reference of the source view controller
            let controller: AddCityViewController = segue.source as! AddCityViewController
            // Get the country name entered by the user on the AddCityViewController's UI
            let countryNameEntered: String = controller.countryNameTextField.text!
            
            // Get the city name entered by the user on the AddCityViewController's UI
            let cityNameEntered: String = controller.cityNameTextField.text!
            
            if countryNames.contains(countryNameEntered) {
                
                // Obtain the list of cities in the given country as AnyObject
                let cities: AnyObject? = applicationDelegate.dict_Country_Cities[countryNameEntered] as AnyObject
                
                // Typecast the AnyObject to Swift array of String objects
                var citiesForCountryNameEntered = cities! as! [String]
                
                /*
                 Note that city names must not be sorted. The order shows how favorite the city is.
                 The higher the order the more favorite the city is. The user specifies the ordering
                 in the Edit mode by moving a row from one location to another for the same country.
                 
                 Add the new city name to the end of the list.
                 */
                citiesForCountryNameEntered.append(cityNameEntered)
                
                // Update the new list of cities for the country in the NSMutableDictionary
                applicationDelegate.dict_Country_Cities.setValue(citiesForCountryNameEntered, forKey: countryNameEntered)
                
            } else {   // The entered country name does not exist in the current dictionary
                
                // Create an array containing cityNameEntered as the only city of the new country
                let citiesForCountryNameEntered: [String] = [cityNameEntered]
                
                // Update the new list of cities for the country in the NSMutableDictionary
                // Note that since the country name key does not exist, we use setObject instead of setValue
                applicationDelegate.dict_Country_Cities.setObject(citiesForCountryNameEntered, forKey: countryNameEntered as NSCopying)
            }
            
            countryNames = applicationDelegate.dict_Country_Cities.allKeys as! [String]
            
            // Sort the country names within itself in alphabetical order
            countryNames.sort { $0 < $1 }
            
            // Reload the rows and sections of the Table View countryCityTableView
            countryCityTableView.reloadData()
        }
        
    }
    
    /*
     --------------------------------------
     MARK: - Table View Data Source Methods
     --------------------------------------
     */
    
    // We are implementing a Grouped table view style as we selected in the storyboard file.
    
    //----------------------------------------
    // Return Number of Sections in Table View
    //----------------------------------------
    
    // Each table view section corresponds to a country
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return countryNames.count
    }
    
    //---------------------------------
    // Return Number of Rows in Section
    //---------------------------------
    
    // Number of rows in a given country (section) = Number of Cities in the given country (section)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Obtain the name of the given country
        let givenCountryName = countryNames[section]
        
        // Obtain the list of cities in the given country as AnyObject
        let cities: AnyObject? = applicationDelegate.dict_Country_Cities[givenCountryName] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        let citiesOfGivenCountry = cities! as! [String]
        
        return citiesOfGivenCountry.count
    }
    
    //-----------------------------
    // Set Title for Section Header
    //-----------------------------
    
    // Set the table view section header to be the country name
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        return countryNames[section]
    }
    
    //-----------------------------
    // Set Title for Section Footer
    //-----------------------------
    
    // Set the table view section footer to "My Favorite Cities in CountryName"
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String {
        
        return "My Favorite Cities in " + countryNames[section]
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableView", for: indexPath) as UITableViewCell
        
        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the name of the given country
        let givenCountryName = countryNames[sectionNumber]
        
        /*
         Note that city names must not be sorted. The order shows how favorite the city is.
         The higher the order the more favorite the city is. The user specifies the ordering
         in the Edit mode by moving a row from one location to another for the same country.
         */
        
        // Obtain the list of cities in the given country as AnyObject
        let cities: AnyObject? = applicationDelegate.dict_Country_Cities[givenCountryName] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        var citiesOfGivenCountry = cities! as! [String]
        
        // Set the cell title to be the city name
        cell.textLabel!.text = citiesOfGivenCountry[rowNumber]
        
        cell.imageView!.image = UIImage(named: "FavoriteIcon.png")
        
        return cell
    }
    
    //-------------------------------
    // Allow Editing of Rows (Cities)
    //-------------------------------
    
    // We allow each row (city) of the table view to be editable, i.e., deletable or movable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    //---------------------
    // Delete Button Tapped
    //---------------------
    
    // This is the method invoked when the user taps the Delete button in the Edit mode
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {   // Handle the Delete action
            
            // Obtain the name of the country of the city to be deleted
            let countryOfCityToDelete = countryNames[(indexPath as NSIndexPath).section]
            
            // Obtain the list of cities in the country as AnyObject
            let cities: AnyObject? = applicationDelegate.dict_Country_Cities[countryOfCityToDelete] as AnyObject
            
            // Typecast the AnyObject to Swift array of String objects
            var citiesOfTheCountry: Array<String> = cities! as! [String]
            
            // Delete the identified city at row
            citiesOfTheCountry.remove(at: (indexPath as NSIndexPath).row)
            
            if citiesOfTheCountry.count == 0 {
                // If no city remains in the array after deletion, then we need to also delete the country
                applicationDelegate.dict_Country_Cities.removeObject(forKey: countryOfCityToDelete)
                
                // Since the dictionary has been changed, obtain the country names again
                countryNames = applicationDelegate.dict_Country_Cities.allKeys as! [String]
                
                // Sort the country names within itself in alphabetical order
                countryNames.sort { $0 < $1 }
            }
            else {
                // At least one more city remains in the array; therefore, the country stays.
                
                // Update the new list of cities for the country in the NSMutableDictionary
                applicationDelegate.dict_Country_Cities.setValue(citiesOfTheCountry, forKey: countryOfCityToDelete)
            }
            
            // Reload the rows and sections of the Table View countryCityTableView
            countryCityTableView.reloadData()
        }
    }
    
    //---------------------------
    // Movement of City Attempted
    //---------------------------
    
    /*
     This method is invoked to carry out the row (city) movement after the method
     tableView: targetIndexPathForMoveFromRowAtIndexPath: toProposedIndexPath: approved the move.
     */
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        
        let countryName = countryNames[(fromIndexPath as NSIndexPath).section]
        
        // Obtain the list of cities in the country as AnyObject
        let cities: AnyObject? = applicationDelegate.dict_Country_Cities[countryName] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        var citiesOfTheCountry: Array<String> = cities! as! [String]
        
        // Row number to move FROM
        let rowNumberFrom   = (fromIndexPath as NSIndexPath).row
        
        // Row number to move TO
        let rowNumberTo     = (toIndexPath as NSIndexPath).row
        
        // City name to move
        let cityNameToMove  = citiesOfTheCountry[rowNumberFrom]
        
        if rowNumberFrom > rowNumberTo {
            // Movement is from lower part of the list to the upper part
            citiesOfTheCountry.insert(cityNameToMove, at: rowNumberTo)
            citiesOfTheCountry.remove(at: rowNumberFrom + 1)
            
        } else {
            // Movement is from upper part of the list to the lower part
            citiesOfTheCountry.insert(cityNameToMove, at: rowNumberTo + 1)
            citiesOfTheCountry.remove(at: rowNumberFrom)
        }
        
        // Update the new list of cities for the country in the NSMutableDictionary
        applicationDelegate.dict_Country_Cities.setValue(citiesOfTheCountry, forKey: countryName)
        
        // No need to reload the table view data since the view is updated automatically
    }
    
    //-----------------------------------------------------
    // Allow Movement of Rows (Cities) within their Country
    //-----------------------------------------------------
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    /*
     -----------------------------------
     MARK: - Table View Delegate Methods
     -----------------------------------
     */
    
    //--------------------------
    // Selection of a City (Row)
    //--------------------------
    
    // Tapping a row (city) displays a map of the city
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Obtain the name of the country of the selected city
        let selectedCountryName = countryNames[(indexPath as NSIndexPath).section]
        
        // Obtain the list of cities in the country as AnyObject
        let cities: AnyObject? = applicationDelegate.dict_Country_Cities[selectedCountryName] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        var citiesOfTheCountry = cities! as! [String]
        
        // Obtain the name of the selected city
        let selectedCityName = citiesOfTheCountry[(indexPath as NSIndexPath).row]
        
        // Prepare the data object to pass to the downstream view controller
        dataObjectToPass[0] = selectedCityName
        dataObjectToPass[1] = selectedCountryName
        
        // Perform the segue named CityMap
        performSegue(withIdentifier: "CityMap", sender: self)
    }
    
    //--------------------------------
    // Detail Disclosure Button Tapped
    //--------------------------------
    
    // This is the method invoked when the user taps the Detail Disclosure button (circle icon with i)
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        // Obtain the name of the country of the city whose Detail Disclosure button is tapped
        let selectedCountryName = countryNames[(indexPath as NSIndexPath).section]
        
        // Obtain the list of cities in the country as AnyObject
        let cities: AnyObject? = applicationDelegate.dict_Country_Cities[selectedCountryName] as AnyObject
        
        // Typecast the AnyObject to Swift array of String objects
        var citiesOfTheCountry = cities! as! [String]
        
        // Obtain the name of the city whose Detail Disclosure button is tapped
        let selectedCityName = citiesOfTheCountry[(indexPath as NSIndexPath).row]
        
        // Prepare the data object to pass to the downstream view controller
        dataObjectToPass[0] = selectedCityName
        dataObjectToPass[1] = selectedCountryName
        
        // Perform the segue named CityMap
        performSegue(withIdentifier: "CityWeb", sender: self)
    }
    
    //--------------------------
    // Movement of City Approval
    //--------------------------
    
    // This method is invoked when the user attempts to move a row (city)
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        let countryFrom = countryNames[(sourceIndexPath as NSIndexPath).section]
        let countryTo = countryNames[(proposedDestinationIndexPath as NSIndexPath).section]
        
        if countryFrom != countryTo {
            
            // The user attempts to move a city from one country to another, which is prohibited
            
            /*
             Create a UIAlertController object; dress it up with title, message, and preferred style;
             and store its object reference into local constant alertController
             */
            let alertController = UIAlertController(title: "Move Not Allowed!",
                                                    message: "Order cities according to your liking only within the same country!",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            present(alertController, animated: true, completion: nil)
            
            return sourceIndexPath  // The row (city) movement is denied
        }
        else {
            return proposedDestinationIndexPath  // The row (city) movement is approved
        }
        
    }
    
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "CityMap" {
            
            // Obtain the object reference of the destination view controller
            let cityMapViewController: CityMapViewController = segue.destination as! CityMapViewController
            
            //Pass the data object to the destination view controller object
            cityMapViewController.dataObjectPassed = dataObjectToPass
            
        } else if segue.identifier == "CityWeb" {
            
            // Obtain the object reference of the destination view controller
            let cityWebViewController: CityWebViewController = segue.destination as! CityWebViewController
            
            //Pass the data object to the destination view controller object
            cityWebViewController.dataObjectPassed = dataObjectToPass
        }
    }
    
}

