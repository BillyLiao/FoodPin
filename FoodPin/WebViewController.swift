//
//  WebViewController.swift
//  FoodPin
//
//  Created by 廖慶麟 on 2016/3/4.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView:UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = NSURL(string: "https://www.facebook.com/") {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
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
