//
//  SearchViewController.swift
//  Assignment
//
//  Created by Kasim Ali on 02/03/2018.
//  Copyright © 2018 Kasim Ali. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  

    @IBOutlet weak var searchChoice: UISegmentedControl!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    var allTheRating = [Rating]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let index = searchChoice.selectedSegmentIndex
        let text = searchText.text
        if index == 0 {
            let escaped = text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            //Postcode
            let postcodeURL = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_postcode&postcode=\(escaped!)")
            URLSession.shared.dataTask(with: postcodeURL!) { (data, response, error) in
                guard let data = data else { print ("error with data"); return}
                do{
                    self.allTheRating = try JSONDecoder().decode([Rating].self, from: data);

                    DispatchQueue.main.async {
                        self.searchTableView.reloadData();
                    }
                } catch let err{
                    print("Error:" , err)
                }
            }.resume()
        }
        else {
            let escaped = text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            //Business Name
            let businessNameURL = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_name&name=\(escaped!)")
            URLSession.shared.dataTask(with: businessNameURL!) { (data, response, error) in
                guard let data = data else { print ("error with data"); return}
                do{
                    self.allTheRating = try JSONDecoder().decode([Rating].self, from: data);

                    DispatchQueue.main.async {
                        self.searchTableView.reloadData();
                    }
                } catch let err{
                    print("Error:" , err)
                }
                }.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTheRating.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = allTheRating[indexPath.row].BusinessName
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell{
            
            let i = searchTableView.indexPath(for: cell)!.row
            print (i)
            if segue.identifier == "searchdetails" {
                let dvc = segue.destination as! DetailsViewController
                dvc.theRating = self.allTheRating[i]
                dvc.search = 1
            }
        }
    }
}
