//
//  ViewController.swift
//  DataBase_Core
//
//  Created by w3OnDemand on 19/02/20.
//  Copyright © 2020 w3OnDemand. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tbl_View: UITableView!
    
    var arrEmployDataList = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //MARK:- get data from data base
        GlobalFunctions.shareInstance.retrieveData(){ (_ result: AnyObject?, _ error: String?) in
            OperationQueue.main.addOperation {
                
                self.arrEmployDataList = (result as! NSArray).mutableCopy() as! NSMutableArray
                self.tbl_View.reloadData()
            }
        }
    }
    
    @IBAction func actionAddDetails(_ sender: UIBarButtonItem) {
        
        let pushViewController:AddDetailsViewController = storyboard?.instantiateViewController(identifier: "AddDetailsViewController") as! AddDetailsViewController
        self.navigationController?.pushViewController(pushViewController, animated: true)
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
        let lbl_EMP_Password = cell?.viewWithTag(5) as? UILabel
        let btn_UpdateData = cell?.viewWithTag(6) as? UIButton
        
        if let dict = arrEmployDataList[indexPath.row] as? NSDictionary
        {
            lbl_EMP_ID?.text = "EMP_ID :- \(String(describing: dict["id"] as? String ?? ""))"
            lbl_EMP_Name?.text = dict["name"] as? String
            lbl_EMP_Email?.text = dict["email_ID"] as? String
            lbl_EMP_Password?.text = dict["password"] as? String
            img_EMP_Profile?.image = UIImage(data: (dict["profileImage"] as! NSData) as Data)
            
            btn_UpdateData?.tag = indexPath.row
            btn_UpdateData?.addTarget(self, action: #selector(actionUpdateData(_:)), for: .touchUpInside)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            
            let alert = UIAlertController(title: GlobalFunctions.GlobalConstants.AppName, message: "Are you sure you want to delete employee details", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in }))
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in

                let dict = self.arrEmployDataList[indexPath.row] as! NSDictionary
                let status = GlobalFunctions.shareInstance.deleteData(dict["id"] as? String ?? "")
                if status == "200"
                {
                    self.arrEmployDataList.removeObject(at: indexPath.row)
//                    self.tbl_View.beginUpdates()
//                    self.tbl_View.deleteRows(at: [indexPath], with: .middle)
//                    self.tbl_View.endUpdates()
                    self.tbl_View.reloadData()
                }
                else
                {
                    self.showMessage(withTitle: "Oops...!", message: "Record not saved")
                }
            }))
            self.present(alert, animated: true)
        }
    }
    
    @objc func actionUpdateData(_ sender: UIButton) {
        
        let dict = self.arrEmployDataList[sender.tag] as! NSDictionary
        let pushViewController:AddDetailsViewController = self.storyboard?.instantiateViewController(identifier: "AddDetailsViewController") as! AddDetailsViewController
        pushViewController.dictData = dict
        self.navigationController?.pushViewController(pushViewController, animated: true)
    }
}
