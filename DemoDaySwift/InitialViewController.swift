//
//  InitialViewController.swift
//  DemoDaySwift
//
//  Created by zomato on 24/09/16.
//  Copyright © 2016 zomato. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var datasource: Array <(title : String, subtitle : String, URL:URL)>?
    
    @IBOutlet weak var loaderBGView: UIView!
    @IBOutlet weak var swiftDemoDayTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // HARD CODED DATA
        //        datasource?.append((title:"Free Pizza", subtitle: "No really"))
        
        URLCache.shared = URLCache(memoryCapacity: 4*1024*1024, diskCapacity: 40*1024*1024, diskPath: nil)
        
        let requestURL = URL(string: "https://alpha-api.app.net/stream/0/posts/stream/global")!
        let urlRequest = URLRequest (url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully with response")
                
                do {
                    let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSDictionary
                    
                    if let posts = json["data"] as? Array<NSDictionary> {
                        self.datasource = Array()
                        for post in posts {
                            if let userDict = post["user"] as? NSDictionary {
                                
                                if let userName = userDict["username"] {
                                    // If we have a valid user name get 'text' and avatar URL
                                    var subtitleString:String?
                                    var url:URL?
                                    
                                    
                                    
                                    // Get avatar image url
                                    if let avatarData = userDict["avatar_image"] {
                                        
                                        if let avatarDict = avatarData as? NSDictionary {
                                            //url = avatarDict.value(forKey: "url") as! URL?
                                            url = URL(string: avatarDict.value(forKey: "url") as! String)
                                        }
                                    }
                                    
                                    // Get subtitle as text
                                    if let text = post["text"] {
                                        
                                        subtitleString = text as? String
                                        print(userName,text)
                                    }
                                    
                                    if  let unwrappedTitle = (userName as? String), let unwrappedSubtitle = subtitleString, let imageURL:URL = url {
                                        //self.datasource?.append((title:title, subtitle:subtitle, URL:imageURL))
                                        self.datasource?.append((title:unwrappedTitle, subtitle:unwrappedSubtitle, URL:imageURL))
                                        
                                        
                                        
                                    }

                                    
                                }
                            }
                        }
                        DispatchQueue.main.async(execute: {
                            self.swiftDemoDayTableView.reloadData()
                            
                            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
                                self.loaderBGView.alpha = 0.0
                                }, completion: { (didFinish) in
                                    
                                    if (didFinish) {
                                        self.loaderBGView.isHidden = true
                                        self.activityIndicator.stopAnimating()
                                    }
                            })
                        })
                    }
                } catch {
                    print("Error with Json: \(error)")
                    
                }
                
            }
                
            else {
                
                print("Error with api call: \(error?.localizedDescription)")
                
            }
        }
        
        task.resume()
    
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = datasource?.count {
            return count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SwiftDemoDayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SwiftDemoDayCell") as! SwiftDemoDayTableViewCell
        
        let (titleString, subtitleString, url) = (datasource?[indexPath.row])!
        cell.configure(title: titleString, subtitle: subtitleString, imageURL: url)
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell: SwiftDemoDayTableViewCell = sender as! SwiftDemoDayTableViewCell
        let indexPath:IndexPath? = self.swiftDemoDayTableView.indexPath(for: cell)
        
        if let indexPathValue = indexPath {
            let item = datasource?[indexPathValue.row]
            let detailVC:SwiftDemoDayDetailViewController = segue.destination as! SwiftDemoDayDetailViewController
            detailVC.text = (item?.title)!
        }
        
    }
    

}
