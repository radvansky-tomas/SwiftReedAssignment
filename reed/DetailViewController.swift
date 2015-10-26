//
//  DetailViewController.swift
//  reed
//
//  Created by Tomas Radvansky on 26/10/2015.
//  Copyright © 2015 Radvansky.Tomas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem as? ImageObject {
            if let imgView = self.fullImageView {
                detail.getImage({ (image, error) -> Void in
                    imgView.image = image
                    if let actView = self.activityView {
                        actView.hidden = true
                        actView.stopAnimating()
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityView.hidden = false
        self.activityView.startAnimating()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

