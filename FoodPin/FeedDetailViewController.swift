//
//  FeedDetailViewController.swift
//  FoodPin
//
//  Created by 廖慶麟 on 2016/3/5.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var name:String!
    var type:String!
    var location:String!
    var image:NSData!
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var restaurantImageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        restaurantImageView.image = UIImage(data: image)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        // self-sizing cell, need to set cell line = 0
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedDetailTableViewCell
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = location
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        return cell
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
