//
//  ImagesResponse.swift
//  reed
//
//  Created by Tomas Radvansky on 26/10/2015.
//  Copyright © 2015 Radvansky.Tomas. All rights reserved.
//

import UIKit

class ImagesResponse: NSObject {
    var imagesArray:Array<ImageObject>!
    
    init(fromJson json:NSMutableArray) {
        imagesArray = Array<ImageObject>()
        for entry in json
        {
            if let entryDict:NSDictionary = entry as? NSDictionary
            {
                let newImage:ImageObject = ImageObject()
                newImage.imageName = entryDict.objectForKey("name") as? String
                newImage.imageDescription = entryDict.objectForKey("description") as? String
                if let imageStr:String = entryDict.objectForKey("image") as? String
                {
                    newImage.imageUrl = NSURL(string: "http://93.175.16.231/web/wwdc/" + imageStr)
                }
                imagesArray.append(newImage)
            }
        }
    }
}
