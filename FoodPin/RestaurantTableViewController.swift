//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by 廖慶麟 on 2016/2/16.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {

    var restaurants:[Restaurant] = []
    var searchResults:[Restaurant] = []
    var fetchResultController:NSFetchedResultsController!
    var searchController:UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        // clear backbarbutton title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        // load data from CoreData
        var fetchRequest = NSFetchRequest(entityName: "Restaurant")
        let sortDescriptor = NSSortDescriptor(key: "name",ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            fetchResultController = NSFetchedResultsController(
                fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            var e:NSError?
            do{
                var result = try fetchResultController.performFetch()
                restaurants = fetchResultController.fetchedObjects as! [Restaurant]
                print(restaurants)
            }catch{
                print(e?.localizedDescription)
            }

        }
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        


        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        print(hasViewedWalkthrough)
        if hasViewedWalkthrough == false {
            if let pageViewController =
                storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController {
                    self.presentViewController(pageViewController, animated: true, completion: nil)
            }
        }
        

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if searchController.active {
            return searchResults.count
        }else {
            return self.restaurants.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomTableViewCell
        
        // Configure the cell...
        let restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        
        
        cell.nameLabel.text = restaurant.name
        cell.thumbnailImageView.image = UIImage(data: restaurant.image)
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.width / 2
        cell.thumbnailImageView.clipsToBounds = true
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        cell.iconImageView.hidden = !restaurant.isVisited.boolValue
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title:"Share", handler:{ (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
            let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: nil)
            let facebookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default, handler: nil)
            let emailAction = UIAlertAction(title: "Email", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(facebookAction)
            shareMenu.addAction(emailAction)
            shareMenu.addAction(cancelAction)
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
            }
        )
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Delete the row from the data source
             if let managedObjectContext = (
                UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
                    let restaurantToDelete = self.fetchResultController.objectAtIndexPath(indexPath)as!Restaurant
                    managedObjectContext.deleteObject(restaurantToDelete)
                    var e: NSError?
                    do {
                        try managedObjectContext.save()
                    }catch{
                        print(e?.localizedDescription)
                    }
                    
                }
            })
    
        shareAction.backgroundColor = UIColor(red: 255/255, green: 166/255, blue: 51/255, alpha: 1)
        deleteAction.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        return [deleteAction, shareAction]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! DetailViewController
                destinationController.restaurant = (searchController.active) ? searchResults[indexPath.row] : restaurants[indexPath.row]
                print(restaurants[indexPath.row])
            }
        }
    }
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue){
        
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            default:
                tableView.reloadData()
        }
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    // search filter
    func filterContentForSearchText(searchText: String){
        searchResults = restaurants.filter({ (restaurant: Restaurant) -> Bool in
            let nameMatch = restaurant.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let locationMatch = restaurant.location.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            return  nameMatch != nil || locationMatch != nil
        })
    }
    
    // update search result for search controller
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filterContentForSearchText(searchText!)
        tableView.reloadData()
    }
    
    // when search controller is active, cell can't be edited.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active {
            return false
        } else {
            return true
        }
    }
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
