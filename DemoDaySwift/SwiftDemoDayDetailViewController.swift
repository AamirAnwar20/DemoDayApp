//
//  SwiftDemoDayDetailViewController.swift
//  DemoDaySwift
//
//  Created by zomato on 08/10/16.
//  Copyright © 2016 zomato. All rights reserved.
//

import UIKit

class SwiftDemoDayDetailViewController: UIViewController {
    
    var text:String = String()
    
    @IBOutlet weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailLabel.text = text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
