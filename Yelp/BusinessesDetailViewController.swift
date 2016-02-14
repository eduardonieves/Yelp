//
//  BusinessesDetailViewController.swift
//  Yelp
//
//  Created by Eduardo Nieves on 2/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesDetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var reviewImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    var businesses: Business!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantLabel.text = businesses.name
        reviewImage.setImageWithURL(businesses.ratingImageURL!)
        reviewLabel.text = "\(businesses.reviewCount!)Reviews"
        categoriesLabel.text = businesses.categories
        imageView.setImageWithURL(businesses.imageURL!)
       let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        performSearch()
        goToLocation(centerLocation)
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func performSearch() {
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = businesses.address
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler {(response, error) in
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            }else if response!.mapItems.count == 0 {
                print("No matches found")
            }else {
                    for item in response!.mapItems {
                    
                    self.matchingItems.append(item as MKMapItem)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
