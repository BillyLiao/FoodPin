//
//  PageViewController.swift
//  FoodPin
//
//  Created by 廖慶麟 on 2016/3/4.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageHeadings = ["Personalize", "Locate", "Discover"]
    var pageImages = ["Royal Oak", "Cafe Lore", "Cafe Deadend"]
    var pageSubHeadings = ["Pin your favorite restaurants and create your own food guide",
        "Search and locate your favorite restaurant on Maps",
        "Find restaurants pinned by your friends and other fodies around the world"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the data source to itself
        dataSource = self
        // Create the first walkthrough screen
        if let startingViewController = self.viewControllerAtIndex(0) {
            setViewControllers([startingViewController],
                direction: .Forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        index++
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        index--
        return self.viewControllerAtIndex(index)
        
    }
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController? {
        if index == NSNotFound || index < 0 || index >= self.pageHeadings.count {
            return nil
        }
        // establish a new controller and pass the right data
        if let PageContentViewController =
            storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as? PageContentViewController {
                PageContentViewController.imageFile = pageImages[index]
                PageContentViewController.heading = pageHeadings[index]
                PageContentViewController.subHeading = pageSubHeadings[index]
                PageContentViewController.index = index
                return PageContentViewController
        }
        return nil
    }
    
    func forward(index: Int) {
        if let nextViewController = self.viewControllerAtIndex(index + 1) {
            setViewControllers([nextViewController], direction: .Forward, animated: true, completion: nil)
        }
    }
    /* default page control
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageHeadings.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let pageContentViewController =
            storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as? PageContentViewController {
                return pageContentViewController.index
        }
        return 0
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

