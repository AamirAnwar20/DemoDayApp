//
//  UIImageView+DownloadImage.swift
//  DemoDaySwift
//
//  Created by zomato on 16/10/16.
//  Copyright © 2016 zomato. All rights reserved.
//

import UIKit

extension UIImageView {

    func loadImage (urlRequest:URLRequest) -> URLSessionDownloadTask {
        
        // Get shared session
        let session = URLSession.shared
        
        // Create download task from shared session [URL, Response, Error]
        /*
         1) Download task saves data locally automatically instead of in memory
         2) URL passed into the closure is the path to the image and not its web URL 
         */
        let downloadTask = session.downloadTask(with: urlRequest, completionHandler : { [weak self] url, response, error in
            
            // Check if error is nil and THEN unwrap the optionals passed in the completion handler
            if error == nil, let url = url,
                             let data = try? Data(contentsOf:url),
                             let image = UIImage(data: data),
                             let response = response
            {
                
                URLCache.shared.storeCachedResponse(CachedURLResponse.init(response: response, data: data), for: urlRequest)
                
                DispatchQueue.main.async {
                    
                    // Check to see if this image view still exists
                    if let strongSelf = self {
                        strongSelf.image = image
                    }
                }
                
            }
            
        })
        // Start the download
        downloadTask.resume()
        
        // Allows us to cancel the request
        return downloadTask
    }
    
}
