//
//  DetailsViewController.swift
//  Assignment
//
//  Created by Kasim Ali on 01/03/2018.
//  Copyright © 2018 Kasim Ali. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class DetailsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var rdateLabel: UILabel!
    
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    var theRating: Rating?
    var search = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        rdateLabel.text = "Rating Date: " + (theRating?.RatingDate)!
        if search == 0 {
        addressLabel.text = (theRating?.AddressLine1)! + "\n" + (theRating?.AddressLine2)! + "\n" + (theRating?.AddressLine3)! + "\n" + (theRating?.PostCode)! + "\n" + "Distance in KM from current location: " + (theRating?.DistanceKM)!
        }
        else {
            addressLabel.text = (theRating?.AddressLine1)! + "\n" + (theRating?.AddressLine2)! + "\n" + (theRating?.AddressLine3)! + "\n" + (theRating?.PostCode)!
            directionsButton.isHidden = true
        }
        if theRating?.RatingValue == "5"{
            myImageView.image = UIImage (imageLiteralResourceName: "5.jpg")
        }
        else if theRating?.RatingValue == "4"{
            myImageView.image = UIImage (imageLiteralResourceName: "4.jpg")
        }
        else if theRating?.RatingValue == "3"{
            myImageView.image = UIImage (imageLiteralResourceName: "3.jpg")
        }
        else if theRating?.RatingValue == "2"{
            myImageView.image = UIImage (imageLiteralResourceName: "2.jpg")
        }
        else if theRating?.RatingValue == "1"{
            myImageView.image = UIImage (imageLiteralResourceName: "1.jpg")
        }
        else if theRating?.RatingValue == "0"{
           myImageView.image = UIImage (imageLiteralResourceName: "0.jpg")
        }
        else{
            myImageView.image = UIImage (imageLiteralResourceName: "e.jpg")
        }
        
        myMapView.delegate = self
        let latitude = (theRating?.Latitude as! NSString).doubleValue
        let longitude = (theRating?.Longitude as! NSString).doubleValue
        let span :MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region :MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        myMapView.setRegion(region, animated: true)
        
        let annotation = CustomPins()
        annotation.coordinate = location
        annotation.title = theRating?.BusinessName
        if theRating?.RatingValue == "5"{
            annotation.image = UIImage(named: "five")
        }
        else if theRating?.RatingValue == "4"{
            annotation.image = UIImage(named: "four")
        }
        else if theRating?.RatingValue == "3"{
            annotation.image = UIImage(named: "three")
        }
        else if theRating?.RatingValue == "2"{
            annotation.image = UIImage(named: "two")
        }
        else if theRating?.RatingValue == "1"{
            annotation.image = UIImage(named: "one")
        }
        else{
            annotation.image = UIImage(named: "na")
        }
        myMapView.addAnnotation(annotation)
        
    }
    
    @IBAction func directionsButton(_ sender: Any) {
        let latitude = (theRating?.Latitude as! NSString).doubleValue
        let longitude = (theRating?.Longitude as! NSString).doubleValue
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = theRating?.BusinessName
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {return nil}
        let annotationIdentifer = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifer)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifer)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let customPointAnnotation = annotation as! CustomPins
        annotationView!.image = customPointAnnotation.image
        return annotationView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
