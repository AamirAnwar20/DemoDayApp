//
//  SwiftDemoDayTableViewCell.swift
//  DemoDaySwift
//
//  Created by zomato on 24/09/16.
//  Copyright © 2016 zomato. All rights reserved.
//

import UIKit

class SwiftDemoDayTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var demoDayImageView: UIImageView!
    
    var downloadTask:URLSessionDownloadTask?
    

    func configure (title:String, subtitle:String, imageURL:URL) {
        
        titleLabel?.text = title
        subtitleLabel?.text = subtitle
        demoDayImageView.image = UIImage(named: "PlaceHolder")
        
        let request = URLRequest(url: imageURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 90.0)
        
        if let data = URLCache.shared.cachedResponse(for: request)?.data {
            demoDayImageView.image = UIImage(data: data)
        }
        else {
            downloadTask = demoDayImageView.loadImage(urlRequest: request)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
    
}
