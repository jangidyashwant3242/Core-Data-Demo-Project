//
//  ViewController.swift
//  DataBase_Core
//
//  Created by w3OnDemand on 19/02/20.
//  Copyright © 2020 w3OnDemand. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tbl_View: UITableView!
    
    var arrEmployDataList = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func actionAddDetails(_ sender: UIBarButtonItem) {
        
        
    }
    
}

extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrEmployDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")
        
        let lbl_EMP_ID = cell?.viewWithTag(1) as? UILabel
        let img_EMP_Profile = cell?.viewWithTag(2) as? UIImageView
        let lbl_EMP_Name = cell?.viewWithTag(3) as? UILabel
        let lbl_EMP_Email = cell?.viewWithTag(4) as? UILabel
        let lbl_EMP_Password = cell?.viewWithTag(3) as? UILabel
        
        let dict = arrEmployDataList[indexPath.row] as! NSDictionary
        lbl_EMP_ID?.text = String(dict[""] as? Int ?? 0)
        lbl_EMP_Name?.text = dict[""] as? String ?? ""
        lbl_EMP_Email?.text = dict[""] as? String ?? ""
        lbl_EMP_Password?.text = dict[""] as? String ?? ""
        
        img_EMP_Profile?.image = UIImage(data: (dict[""] as! NSData) as Data)
        
        return cell!
    }
}
