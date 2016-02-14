//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating ,FiltersViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var filteredBusiness:[Business]!
    var searchBarController: UISearchController!
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        self.searchBarController = UISearchController(searchResultsController: nil)
        self.searchBarController.searchResultsUpdater = self
        
        self.searchBarController.dimsBackgroundDuringPresentation = false
        self.searchBarController.searchBar.sizeToFit()
        
        navigationItem.titleView = searchBarController.searchBar
        searchBarController.hidesNavigationBarDuringPresentation = false

        

        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusiness = self.businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
    }

    func updateSearchResultsForSearchController(searchController: UISearchController){
        if let searchText = searchController.searchBar.text {
            filteredBusiness = searchText.isEmpty ? businesses: self.businesses.filter({(dataString: Business) -> Bool in
                let name = dataString.name! as String
                
                return name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            })
            
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if businesses != nil {
            return filteredBusiness.count
        } else {
            return 0
        }
    }
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    let cell =  tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
    
    cell.business = filteredBusiness[indexPath.row]
    return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "BussinesSegue"{
        
        let selectedCell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(selectedCell)
        let selectedBusiness = filteredBusiness![indexPath!.row]
        let bussinessesDetailViewController = segue.destinationViewController as! BusinessesDetailViewController
        bussinessesDetailViewController.businesses = selectedBusiness
        }
        else if segue.identifier == "FilterSegue" {
       let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
        }
    }
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) {
            (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusiness = self.businesses
            self.tableView.reloadData()
            }
    }
}
