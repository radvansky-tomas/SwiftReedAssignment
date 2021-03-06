//
//  MasterViewController.swift
//  reed
//
//  Created by Tomas Radvansky on 26/10/2015.
//  Copyright © 2015 Radvansky.Tomas. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var objects = Array<ImageObject>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadTableData:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadTableData(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableData(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: "http://93.175.16.231/web/wwdc/items.json")!)
        let urlSession = NSURLSession.sharedSession()
        let dataTask = urlSession.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if (error == nil) {
                if let unwrappedData:NSData = data
                {
                    do
                    {
                        let unparsedArray = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions(rawValue: 0))
                        let imageResponse:ImagesResponse = ImagesResponse(fromJson: unparsedArray as! NSMutableArray)
                        self.objects = imageResponse.imagesArray
                    }
                    catch
                    {
                        print("Parsing error")
                    }
                }
                else
                {
                    print("No Data")
                }
            } else {
                print(error)
            }
            // call the completion function (on the main thread)
            dispatch_async(dispatch_get_main_queue()) {
                //Reload Data
                self.tableView.reloadData()
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath)
        
        let object = objects[indexPath.row]
        let titleLabel:UILabel = cell.viewWithTag(102) as! UILabel
        let subtitleLabel:UILabel = cell.viewWithTag(103) as! UILabel
        let imageView:UIImageView = cell.viewWithTag(100) as! UIImageView
        let progressView:UIActivityIndicatorView = cell.viewWithTag(101) as! UIActivityIndicatorView
        progressView.hidden = false
        progressView.startAnimating()
        titleLabel.text = object.imageName
        subtitleLabel.text = object.imageDescription
        object.getImage({ (image, error) -> Void in
            imageView.image = image
            progressView.hidden = true
            progressView.stopAnimating()
        })
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
}

