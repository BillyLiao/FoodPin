//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by 廖慶麟 on 2016/2/23.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var dialogView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        dialogView.transform = CGAffineTransformConcat(scale, translate)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.dialogView.transform = CGAffineTransformConcat(scale, translate)
            }, completion: nil)
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
