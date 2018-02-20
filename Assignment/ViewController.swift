//
//  ViewController.swift
//  Assignment
//
//  Created by Kasim Ali on 20/02/2018.
//  Copyright © 2018 Kasim Ali. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    let locationManager = CLLocationManager()
    var allTheRating = [Rating]()
    let annotation = CustomPins()
    
    @IBOutlet weak var locationDetailsLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView.delegate = self
        myTableView.dataSource = self
        myTableView.delegate = self

        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 1
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = locations[0].coordinate.latitude
        let longitude = locations[0].coordinate.longitude
        
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(latitude)&long=\(longitude)")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { print ("error with data"); return}
            do{
                self.allTheRating = try JSONDecoder().decode([Rating].self, from: data);
                
                DispatchQueue.main.async {
                    self.myMapView.removeAnnotation(self.annotation)
                    self.annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                    self.annotation.title = ("I'm here!")
                    self.annotation.image = UIImage(named: "person")
                    self.myMapView.addAnnotation(self.annotation)
                    self.myTableView.reloadData();
                    let span :MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
                    let location :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    let region :MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                    self.myMapView.setRegion(region, animated: true)
                    
                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(self.locationManager.location!, completionHandler: { (placemarks, error) in
                        if error == nil {
                            let firstLocation = placemarks?[0]
                            if let locality = firstLocation?.locality{
                                if let subLocality = firstLocation?.subLocality{
                                    self.locationDetailsLabel.text = "\(locality) \n \(subLocality)"
                                }
                            } else {
                                self.locationDetailsLabel.text = "location details not available!"
                            }
                        }
                        else {
                            if let error = error {
                                print("error with reverse geo-coding \n \(error)")
                            }
                        }
                    })
                    
                    for a in self.allTheRating{
                        let annotation1 = CustomPins()
                        annotation1.coordinate = CLLocationCoordinate2DMake(Double(a.Latitude)!, Double(a.Longitude)!)
                        annotation1.title = a.BusinessName
                        annotation1.subtitle = a.AddressLine1 + "\n" + a.AddressLine2! + "\n" + a.AddressLine3!
                        if a.RatingValue == "5"{
                            annotation1.image = UIImage(named: "five")
                        }
                        else if a.RatingValue == "4"{
                            annotation1.image = UIImage(named: "four")
                        }
                        else if a.RatingValue == "3"{
                            annotation1.image = UIImage(named: "three")
                        }
                        else if a.RatingValue == "2"{
                            annotation1.image = UIImage(named: "two")
                        }
                        else if a.RatingValue == "1"{
                            annotation1.image = UIImage(named: "one")
                        }
                        else{
                            annotation1.image = UIImage(named: "na")
                        }
                        self.myMapView.addAnnotation(annotation1)
                    }
                }
            } catch let err{
                print("Error:" , err)
            }

        }.resume()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTheRating.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! RatingTableViewCell
        
        cell.ratingLabel.text = allTheRating[indexPath.row].BusinessName
        cell.ratingImage.image = getImage4Rating(ratingValue: allTheRating[indexPath.row].RatingValue)
        return cell
    }
    
    func getImage4Rating(ratingValue: String) -> UIImage{
        let image: UIImage
        
        switch(ratingValue) {
        case "0":
            image = UIImage(named: "0")!
        case "1":
            image = UIImage(named: "1")!
        case "2":
            image = UIImage(named: "2")!
        case "3":
            image = UIImage(named: "3")!
        case "4":
            image = UIImage(named: "4")!
        case "5":
            image = UIImage(named: "5")!
        default:
            image = UIImage(named: "e")!
        }
        
        return image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell{
            let i = myTableView.indexPath(for: cell)!.row
            if segue.identifier == "details" {
                let dvc = segue.destination as! DetailsViewController
                dvc.theRating = self.allTheRating[i]
            }
        }
    }
}

