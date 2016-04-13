//
//  AboutViewController.swift
//  FoodPin
//
//  Created by 廖慶麟 on 2016/3/4.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmail (sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            var composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(["billyliao@n-marketing.net"])
            composer.navigationBar.tintColor = UIColor.whiteColor()
            presentViewController(composer, animated: true, completion:  {
                UIApplication.sharedApplication().setStatusBarStyle( .LightContent, animated: false)
                })
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
            case MFMailComposeResultCancelled: print("Mail cancelled")
            case MFMailComposeResultSaved: print("Mail saved")
            case MFMailComposeResultSent: print("Mail sent")
            case MFMailComposeResultFailed: print("Failed to send mail: \(error?.localizedDescription)")
            default:
            break
        }
        // dismiss mail interface
        dismissViewControllerAnimated(true, completion: nil)
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
