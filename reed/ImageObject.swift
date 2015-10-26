//
//  ImageObject.swift
//  reed
//
//  Created by Tomas Radvansky on 26/10/2015.
//  Copyright © 2015 Radvansky.Tomas. All rights reserved.
//

import UIKit

//"image" : "wwdc5.png",
//"name" : "WWDC'05",
//"description" : "Image for WWDC 2005"

class ImageObject: NSObject {
    var imageUrl:NSURL?
    var imageName:String?
    var imageDescription:String?
    var imageObject:UIImage?
    
    func getImage(completionBlock:((image:UIImage?, error:NSError?) -> Void)!)
    {
        if self.imageObject != nil
        {
            if completionBlock != nil {
                completionBlock!(image:self.imageObject, error:nil)
            }
        }
        else
        {
            //Load image
            if let url:NSURL = self.imageUrl
            {
                self.getDataFromUrl(url, completion: { (data, response, error) -> Void in
                    if let data = NSData(contentsOfURL: url){
                        let img = UIImage(data: data)
                        if img != nil
                        {
                            self.imageObject = img
                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                if completionBlock != nil {
                                    completionBlock!(image:img, error:nil)
                                }
                            }
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                if completionBlock != nil {
                                    completionBlock!(image:nil, error:NSError(domain: "ImageObject", code: 101, userInfo: nil))
                                }
                            }
                        }
                        
                    }
                })
            }
            else
            {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if completionBlock != nil {
                        completionBlock!(image:nil, error:NSError(domain: "ImageObject", code: 100, userInfo: nil))
                    }
                }
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
}
