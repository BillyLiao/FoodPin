//
//  ReferViewController.swift
//  FoodPin
//
//  Created by 廖慶麟 on 2016/2/24.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class ReferViewController: UIViewController {
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var SMSBtn: UIButton!
    @IBOutlet weak var referView1: UIView!
    @IBOutlet weak var referView2: UIView!
    @IBOutlet weak var referView3: UIView!
    @IBOutlet weak var referView4: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        twitterBtn.hidden = true
        emailBtn.hidden = true
        referView2.transform = CGAffineTransformMakeTranslation(0, 500)
        referView1.transform = CGAffineTransformMakeTranslation(0, 500)
        referView3.transform = CGAffineTransformMakeTranslation(0, -500)
        referView4.transform = CGAffineTransformMakeTranslation(0, -500)
        
        
        

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        twitterBtn.hidden = false
        emailBtn.hidden = false
        referView1.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        referView4.backgroundColor = UIColor(red: 85/255, green: 182/255, blue: 238/255, alpha: 1)
        referView3.backgroundColor = UIColor(red: 65/255, green: 152/255, blue: 208/255, alpha: 1)
        referView2.backgroundColor = UIColor(red :89/255, green: 109/255, blue: 172/255, alpha: 1)
        
        UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.referView1.transform = CGAffineTransformMakeTranslation(0, 0)
            self.referView3.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: nil)
        UIView.animateWithDuration(0.7, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.referView2.transform = CGAffineTransformMakeTranslation(0, 0)
            self.referView4.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close(){
        
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
