//
//  AddTableViewController.swift
//  FoodPin
//
//  Created by 廖慶麟 on 2016/2/25.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import CloudKit

class AddTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var typeTextField:UITextField!
    @IBOutlet weak var locationTextField:UITextField!
    @IBOutlet weak var yesButton:UIButton!
    @IBOutlet weak var noButton:UIButton!
    var restaurant:Restaurant!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yesButton.addTarget(self, action: "yesButtonTapped", forControlEvents: .TouchUpInside)
        noButton.addTarget(self, action: "noButtonTapped", forControlEvents: .TouchUpInside)
        
        nameTextField.delegate = self;
        typeTextField.delegate = self;
        locationTextField.delegate = self;

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // when press return on keyboard, then dismiss it!
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // After user finishes picking pictures.

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image =
            info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func save(){
        let alert = UIAlertView()
        var emptyfield: String!
        
        if nameTextField.text == "" {
            emptyfield = "restaurant name"
        }
        else if typeTextField.text == "" {
            emptyfield = "restaurant type"
        }
        else if locationTextField.text == "" {
            emptyfield = "restaurant location"
        }

        
        if emptyfield == nil {
            var isVisited: Bool = true
            
            if noButton.backgroundColor == UIColor.redColor(){
                isVisited = false
            }
            // Save object to CoreData

            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                restaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: managedObjectContext) as! Restaurant
                restaurant.name = nameTextField.text
                restaurant.type = typeTextField.text
                restaurant.location = locationTextField.text
                restaurant.image = UIImagePNGRepresentation(imageView.image!)
                restaurant.isVisited = isVisited
                var e: NSError?
                do {
                    try managedObjectContext.save()
                } catch {
                    print("insert error: \(e!.localizedDescription)")
                }
                saveRecordToCloud(restaurant)
                performSegueWithIdentifier("unwindToHomeScreen", sender: self)
            }

        }else {
            alert.title = "Ooops"
            alert.message = "We can't proceed as you forget to fill in the \(emptyfield). All fields are mandatory."
            alert.addButtonWithTitle("OK")
            alert.show()
        }

    }
    
    func noButtonTapped(){
        noButton.backgroundColor = UIColor.redColor()
        yesButton.backgroundColor = UIColor.lightGrayColor()
    }
    
    func yesButtonTapped(){
        yesButton.backgroundColor = UIColor.redColor()
        noButton.backgroundColor = UIColor.lightGrayColor()
    }
    

    func saveRecordToCloud(restaurant:Restaurant!) -> Void {
        // Prepare the record to save
        var record = CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.name, forKey:"name")
        record.setValue(restaurant.type, forKey:"type")
        record.setValue(restaurant.location, forKey:"location")
        // Resize the image
        var originalImage = UIImage(data: restaurant.image)
        var scalingFactor = (originalImage!.size.width > 1024) ? 1024 / originalImage!.size.width : 1.0
        var scaledImage = UIImage(data: restaurant.image, scale: scalingFactor)
        // Write the image to local file for temporary use
        let imageFilePath = NSTemporaryDirectory() + restaurant.name
        UIImageJPEGRepresentation(scaledImage!, 0.8)?.writeToFile(imageFilePath, atomically: true)
        // Create image asset for upload
        let imageFileURL = NSURL(fileURLWithPath: imageFilePath)
        var imageAsset = CKAsset(fileURL: imageFileURL)
        record.setValue(imageAsset, forKey: "image")
        // Get the Public iCloud Database
        let cloudContainer = CKContainer.defaultContainer()
        let publicDatabase =
            CKContainer.defaultContainer().publicCloudDatabase
        // Save the record to iCloud
        publicDatabase.saveRecord(record, completionHandler: {
            (record:CKRecord?, error:NSError?) -> Void in
            // Remove temp file
            var err:NSError?
            do{
                try NSFileManager.defaultManager().removeItemAtPath(imageFilePath)
            } catch {
                print("Failed to save record to the cloud: \(err?.localizedDescription)")
            }

        })
    }
    // MARK: - Table view data source
    
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
