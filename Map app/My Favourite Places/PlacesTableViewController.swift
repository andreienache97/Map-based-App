//
//  PlacesTableViewController.swift
//  My Favourite Places
//
//  Created by Andrei Enache on 15/11/2018.
//  Copyright © 2018 Andrei Enache. All rights reserved.
//

import UIKit
import CoreData

var places = [Dictionary<String, String>()]
var mapPlaces = [Place]()


class PlacesTableViewController: UITableViewController  {

    @IBAction func myLocation(_ sender: Any) {
        performSegue(withIdentifier: "to Map", sender: -1)
    }
    
    @IBAction func addPlace(_ sender: Any) {
      performSegue(withIdentifier: "to Map", sender: -2)
    }
    @IBOutlet var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        fetchData()
        initPlaces()
        table.reloadData()
        
    }
    
    func initPlaces(){
        if places.count == 1 && places[0].count == 0 {
            places.remove(at: 0)
        }
        for eachPlace in mapPlaces{
            places.append(["name":eachPlace.name!, "lat": eachPlace.lat!, "lon":eachPlace.long!])
        }
    }

    func fetchData(){
        
        
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        
        do{
            mapPlaces = try PersistenceService.context.fetch(fetchRequest) // save all the info
            
        }catch {print("Could not fetch the data")}
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
              table.reloadData()
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest = segue.destination as! ViewController // get the destination of the segue
        
        guest.currentPlace = sender as! Int // set the values in the next screen
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        if places[indexPath.row]["name"] != nil {
        }
        cell.textLabel?.text = places[indexPath.row]["name"]
        
        return cell
        
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "to Map", sender: indexPath.row)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     
    
        guard editingStyle == .delete else { return }
      
 
            PersistenceService.context.delete(mapPlaces[indexPath.row])
            PersistenceService.saveContext()
            table.reloadData()
    
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}
