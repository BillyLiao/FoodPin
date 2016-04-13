//
//  FeedTableViewCell.swift
//  FoodPin
//
//  Created by 廖慶麟 on 2016/3/5.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var restaurantImage:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
