//
//  AddDetailsViewController.swift
//  DataBase_Core
//
//  Created by w3OnDemand on 19/02/20.
//  Copyright © 2020 w3OnDemand. All rights reserved.
//

import UIKit

class AddDetailsViewController: UIViewController {
    
    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var txt_EMPID: UITextField!
    @IBOutlet weak var txt_EMPName: UITextField!
    @IBOutlet weak var txt_EMPEmailID: UITextField!
    @IBOutlet weak var txt_EMPPassword: UITextField!
    
    var dictData = NSDictionary()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if dictData.count != 0
        {
            txt_EMPID.isUserInteractionEnabled = false
            txt_EMPID.text = dictData["id"] as? String
            txt_EMPName.text = dictData["name"] as? String
            txt_EMPEmailID.text = dictData["email_ID"] as? String
            txt_EMPPassword.text = dictData["password"] as? String
            img_Profile.image = UIImage(data: (dictData["profileImage"] as! NSData) as Data)
        }
    }
    
    @IBAction func action_ImagePick(_ sender: UIButton) {
        
        //UploadProfileImage
        imagePicker.delegate = self
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func action_SubmitDetails(_ sender: UIButton) {
        
        let imageData = img_Profile.image?.jpegData(compressionQuality: 0.3)
        if(imageData==nil)
        {
            self.showMessage(withTitle: GlobalFunctions.GlobalConstants.AppName, message: "Profile Image Is Requered")
        }
        else if GlobalFunctions.shareInstance.emptyChecker(txt_EMPID.text!)
        {
            self.showMessage(withTitle: GlobalFunctions.GlobalConstants.AppName, message: "Please enter employee Id")
        }
        else if GlobalFunctions.shareInstance.emptyChecker(txt_EMPName.text!)
        {
            self.showMessage(withTitle: GlobalFunctions.GlobalConstants.AppName, message: "Please enter name")
        }
        else if GlobalFunctions.shareInstance.emptyChecker(txt_EMPEmailID.text!) || txt_EMPEmailID.text!.isValidEmail() != false
        {
            self.showMessage(withTitle: GlobalFunctions.GlobalConstants.AppName, message: "Please enter valid email Id")
        }
        else if GlobalFunctions.shareInstance.emptyChecker(txt_EMPPassword.text!)
        {
            self.showMessage(withTitle: GlobalFunctions.GlobalConstants.AppName, message: "Please enter password")
        }
        else
        {
            let employeeIndo = ["id": txt_EMPID.text!, "name": txt_EMPName.text!, "email_ID": txt_EMPEmailID.text!, "password": txt_EMPPassword.text!]
            
            if dictData.count == 0
            {
                let status = GlobalFunctions.shareInstance.insertData(employeeIndo, emp_ProfileImage: imageData! as NSData)
                if status == "200"
                {
                    self.showAlertAction(withMessage: "Record has been saved successfully")
                }
                else if status == "401"
                {
                    self.showMessage(withTitle: "Oops...!", message: "employee id already exists")
                }
                else
                {
                    self.showMessage(withTitle: "Oops...!", message: "Record not saved")
                }
            }
            else if dictData.count != 0
            {
                let status = GlobalFunctions.shareInstance.updateData(dictData["id"] as? String ?? "", newUpdateDict: employeeIndo, emp_ProfileImage: imageData! as NSData)
                if status == "200"
                {
                    self.showAlertAction(withMessage: "Record has been update successfully")
                }
                else
                {
                    self.showMessage(withTitle: "Oops...!", message: "Record not update")
                }
            }
        }
    }
}

// MARK :- imagePicker & Set
extension AddDetailsViewController:   UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //image_Picker
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            self.img_Profile.image = pickedImage//.resized(toWidth: 300.0)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
