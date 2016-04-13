//
//  FeedTableViewController.swift
//  FoodPin
//
//  Created by 廖慶麟 on 2016/3/5.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import CloudKit

class FeedTableViewController: UITableViewController {

    var cloudRestaurants:[CKRecord] = []
    var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    var imageCache:NSCache = NSCache()
    var tempRestaurant:Restaurant!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getRecordsFromCloud()
        self.tableView.rowHeight = 65

        
        spinner.activityIndicatorViewStyle = .Gray
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        self.parentViewController?.view.addSubview(spinner)
        spinner.startAnimating()
        
        // RefreshControl
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: "getRecordsFromCloud", forControlEvents: UIControlEvents.ValueChanged)
        
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
        // #warning Incomplete implementation, return the number of rows
        return cloudRestaurants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedTableViewCell
        if cloudRestaurants.isEmpty {
            return cell
        }
        
        // Configure the cell...
        let cloudRestaurant = cloudRestaurants[indexPath.row]
        cell.nameLabel.text = cloudRestaurant.objectForKey("name") as? String
        // Default image setting
        cell.restaurantImage?.image = UIImage(named: "camera")
        // Check if the image is in the Cache
        if let imageFileURL =
            imageCache.objectForKey(cloudRestaurant.recordID) as? NSURL {
                print("Get image from cache")
                cell.restaurantImage.image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
        } else {
            // Backend download image from iCloud
            let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [cloudRestaurant.recordID])
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .VeryHigh
            fetchRecordsImageOperation.perRecordCompletionBlock = { (record: CKRecord?, recordID:CKRecordID?,
                error: NSError?) -> Void in
                if (error != nil) {
                    print("Failed to get restaurant image: \(error!.localizedDescription)")
                } else {
                    if let restaurantRecord = record {
                        dispatch_async(dispatch_get_main_queue(), {
                            let imageAsset = restaurantRecord.objectForKey("image") as! CKAsset
                            self.imageCache.setObject(imageAsset.fileURL, forKey: cloudRestaurant.recordID)
                            cell.restaurantImage?.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
                        })
                    }
                }
    
            }
        
            publicDatabase.addOperation(fetchRecordsImageOperation)
        }
        return cell
    }

    func getRecordsFromCloud(){
        // Initailize an empty restaurants array
        cloudRestaurants = []
        // Fetch data using Convenience API
        let cloudContainer = CKContainer.defaultContainer()
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        // Start to query
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        // work by query
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name","type","location"]
        queryOperation.queuePriority = .VeryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
            if let restaurantRecord = record {
                self.cloudRestaurants.append(restaurantRecord)
            }
            
        }
        queryOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error:NSError?) -> Void in
            if self.spinner.isAnimating() {
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.stopAnimating()
                })
            }
            // Hide refresh control
            self.refreshControl?.endRefreshing()
            
            if (error != nil) {
                print("Failed to get data from iCloud - \(error!.localizedDescription)")
            } else {
                print("Successfully retrieve the data from iCloud")
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
            }
        }
        
        // Perform query
        publicDatabase.addOperation(queryOperation)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "showFeedDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! FeedDetailViewController
                destinationController.name = cloudRestaurants[indexPath.row].objectForKey("name") as! String
                destinationController.type = cloudRestaurants[indexPath.row].objectForKey("type") as! String
                destinationController.location = cloudRestaurants[indexPath.row].objectForKey("location") as! String
                // Check if the image is in the Cache
                if let imageFileURL =
                    imageCache.objectForKey(cloudRestaurants[indexPath.row].recordID) as? NSURL {
                        print("Get image from cache")
                        destinationController.image = NSData(contentsOfURL: imageFileURL)!
                } else {
                    // Backend download image from iCloud
                    let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
                    let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [cloudRestaurants[indexPath.row].recordID])
                    fetchRecordsImageOperation.desiredKeys = ["image"]
                    fetchRecordsImageOperation.queuePriority = .VeryHigh
                    fetchRecordsImageOperation.perRecordCompletionBlock = { (record: CKRecord?, recordID:CKRecordID?,
                        error: NSError?) -> Void in
                        if (error != nil) {
                            print("Failed to get restaurant image: \(error!.localizedDescription)")
                        } else {
                            if let restaurantRecord = record {
                                dispatch_async(dispatch_get_main_queue(), {
                                    let imageAsset = restaurantRecord.objectForKey("image") as! CKAsset
                                    destinationController.image = NSData(contentsOfURL: imageAsset.fileURL)!
                                })
                            }
                        }
                        
                    }
                    
                    publicDatabase.addOperation(fetchRecordsImageOperation)
                }
                    
            }
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
