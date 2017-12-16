//
//  ViewController.swift
//  Testing
//
//  Created by Ravenous on 16/12/17.
//  Copyright © 2017 Ravenous. All rights reserved.
//

import UIKit

// MARK: - ====================  Search Category Cell ====================
class serchVenueCell: UITableViewCell {
    
    @IBOutlet weak var lblCategoriesName: UILabel!
    
}

// MARK: - ==================== Detail Cell ====================
class DetailCell: UITableViewCell {
    
    @IBOutlet weak var ListName: UILabel!
    
}

class ViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , UITextFieldDelegate {

     // MARK: - ====================  All IBOutlet ====================
    @IBOutlet weak var tblDetail: UITableView!
    @IBOutlet weak var tblSearchVenues: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
     // MARK: - ====================  All Variable Declaration ====================
    var arrAllCateogries = NSMutableArray()
    var filterArr = NSMutableArray()
    var appDelegate = AppDelegate()
    var isFromSelect = Bool()
    var serchID = String()
    var arrDetailList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblSearchVenues.isHidden = true
        self.tblDetail.isHidden = true
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CallGetVenueAPI()
    }

    // MARK: - ====================  Call GetVenue API ====================
    func CallGetVenueAPI(){
        
        self.arrAllCateogries.removeAllObjects()
        
        APIManager.callGetAPI(strPage: API_GetCat, controller: self) { (response, status, error) in
            
            if status == 1{
                FuncationManager.hideLoaginView(controller: self)
                let dic = response as! NSDictionary
                let arrCategories = (dic.object(forKey: "response") as! NSDictionary).object(forKey: "categories") as! NSArray
            
                for i in 0..<arrCategories.count {
                    self.arrAllCateogries.add(arrCategories.object(at: i) as! NSDictionary)
                    //self.arrAllCateogries.add((arrCategories.object(at: i) as! NSDictionary).object(forKey: "name")!)
                }
                
            }else{
                FuncationManager.hideLoaginView(controller: self)
                FuncationManager.showMessage(strTitle: "", strMessage: error.localizedDescription, controller: self)
            }
        }
        
    }
    
    // MARK: - ====================  UITableView Delegate Methos ====================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tblSearchVenues  {
            return self.filterArr.count
        }else{
            return self.arrDetailList.count
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tblSearchVenues  {
            let searchCell = tableView.dequeueReusableCell(withIdentifier: "serchVenueCell", for: indexPath) as! serchVenueCell
            
            searchCell.lblCategoriesName.text = (self.filterArr.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
            //searchCell.lblCategoriesName.text = self.filterArr.object(at: indexPath.row) as? String
            return searchCell
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
            
            let Detail = self.arrDetailList.object(at: indexPath.row) as! VenuesListModel
            
            Cell.ListName.text = Detail.name
            
            return Cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblSearchVenues  {
            self.isFromSelect = true
            self.view.endEditing(true)
            self.txtSearch.text = (self.filterArr.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
            self.serchID = (self.filterArr.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String
        }else{
           self.performSegue(withIdentifier: "GoToDetail", sender: self.arrDetailList.object(at: indexPath.row))
        }
        
    }
    
    // MARK: - ====================  UITextField Delegate Methos ====================
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtSearch {
            self.isFromSelect = false
            self.tblSearchVenues.isHidden = false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtSearch {
            self.isFromSelect = true
            self.tblSearchVenues.isHidden = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.isFromSelect == false{
            let searchPredicate = NSPredicate(format: "name CONTAINS[C] %@", textField.text!)
            self.filterArr = ((arrAllCateogries as NSArray as! NSMutableArray).filtered(using: searchPredicate) as NSArray).mutableCopy() as! NSMutableArray
            if (textField.text == ""){
                self.filterArr.removeAllObjects()
            }
            self.tblSearchVenues.reloadData()
            
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func btnSearchTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.tblDetail.isHidden = false
        
        if (self.txtSearch.text != "") {
            if (self.serchID != ""){
               self.CallGetVenueDetailAPI()
            }
        }
        
    }
    
    // MARK: - ====================  Call GetVenueDetail API ====================
    func CallGetVenueDetailAPI(){
        
        self.arrDetailList.removeAllObjects()
        
        let strApi =  API_BaseUrl + "ll=\(self.appDelegate.Latitude),\(self.appDelegate.Longitude)&&categoryId=\(self.serchID)&&limit=50&oauth_token=DW2YOG0TYWAKTGU1SY32TWLBO02GB1YLHYHOT5U4ZRX0BKRX&v=20171216"
        
        APIManager.callGetAPI(strPage: strApi, controller: self) { (response, status, error) in
            
            if status == 1{
                FuncationManager.hideLoaginView(controller: self)
                let dic = response as! NSDictionary
                let temparr = (dic.object(forKey: "response") as! NSDictionary).object(forKey: "venues") as! NSArray
                
                for i in 0..<temparr.count {
                    self.arrDetailList.add(VenuesListModel(dicData: temparr.object(at: i) as! NSDictionary))
                }
                self.tblDetail.reloadData()
            }else{
                FuncationManager.hideLoaginView(controller: self)
                FuncationManager.showMessage(strTitle: "", strMessage: error.localizedDescription, controller: self)
            }
        }
        
    }
    
    // MARK: - ====================  Navigation ====================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetail"{
            let DetailVC = segue.destination as! DetailViewController
            DetailVC.passModel = sender as! VenuesListModel
        }
    }
}

