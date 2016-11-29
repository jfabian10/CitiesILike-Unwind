//
//  CityWebViewController.swift
//  CitiesILike
//
//  Created by CS3714 on 10/2/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class CityWebViewController: UIViewController, UIWebViewDelegate {
    
    /*
     dataObjectPassed is the data object passed to this view controller
     from the upstream view controller CityTableViewController
     
     dataObjectPassed[0] = selectedCityName
     dataObjectPassed[1] = selectedCountryName
     */
    var dataObjectPassed = [String]()
    
    // Instance variable holding the object reference of the UIWebView UI object created in the Interface Builder (IB), i.e., Storyboard
    @IBOutlet var webView: UIWebView!
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title of the view controller to the selected city name
        self.title = dataObjectPassed[1]
        
        // The URL cannot have spaces; therefore replace each space in the city name with underscore.
        // Example: The city name "Rio de Janeiro" needs to be converted to "Rio_de_Janeiro"
        let selectedCityNameWithNoSpaces = dataObjectPassed[0].replacingOccurrences(of: " ", with: "_", options: [], range: nil)
        
        let websiteURL = "http://en.wikipedia.org/wiki/" + selectedCityNameWithNoSpaces
        
        /*
         * Convert the URL entered by the user into an NSURL object and store its object
         * reference into the local variable url. An NSURL object represents a URL.
         */
        let url = URL(string: websiteURL)
        
        /*
         * Convert the NSURL object into an NSURLRequest object and store its object
         * reference into the local variable request. An NSURLRequest object represents
         * a URL load request in a manner independent of protocol and URL scheme.
         */
        let request = URLRequest(url: url!)
        
        // Ask the web view object to display the web page for the URL entered by the user.
        webView.loadRequest(request)
    }
    
    /*
     ----------------------------------
     MARK: - UIWebView Delegate Methods
     ----------------------------------
     */
    
    // These methods must be implemented whenever UIWebView is used.
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        // Starting to load the web page. Show the animated activity indicator in the status bar
        // to indicate to the user that the UIWebVIew object is busy loading the web page.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // Finished loading the web page. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        /*
         Ignore this error if the page is instantly redirected via javascript or in another way.
         NSURLErrorCancelled is returned when an asynchronous load is cancelled, which happens
         when the page is instantly redirected via javascript or in another way.
         */
        if (error as NSError).code == NSURLErrorCancelled  {
            return
        }
        
        // An error occurred during the web page load. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Create the error message in HTML as a character string and store it into the local constant errorString
        let errorString = "<html><font size=+2 color='red'><p>An error occurred: <br />Possible causes for this error:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>" + error.localizedDescription
        
        // Display the error message within the UIWebView object
        self.webView.loadHTMLString(errorString, baseURL: nil)
    }
    
}
