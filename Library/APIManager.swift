//
//  APIManager.swift
//  AlmoraDemo
//
//  Created by Ravenous on 03/08/17.
//  Copyright © 2017 Ravenous. All rights reserved.
//

import UIKit
import Alamofire

open class APIManager: NSObject {

    public class func callPostAPI(param:[String: Any],strPage:String,controller:UIViewController, withblock:@escaping (_ response: AnyObject?,_ status:Int,_ error:NSError)->Void){
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let error = NSError()
        
        if(appDelegate.connected()){
            
            let url =  strPage
            
            let _headers : HTTPHeaders = ["Content-Type":"application/json"]
            
            let api = Alamofire.request(url, method:.post, parameters: param, encoding: JSONEncoding.default, headers: _headers)
            
            api.responseJSON {
                response -> Void in
                
                if let JSON = response.result.value
                {
                    withblock(JSON as AnyObject?, 1, error)
                }
                else if response.result.error != nil
                {
                    withblock(response.result.value as AnyObject?, 0,  response.result.error! as NSError)
                }
                else
                {
                    print("nERROR - 117")
                }
            }
            
        }else{
            FuncationManager.hideLoaginView(controller: controller)
            FuncationManager.showMessage(strTitle: "Internet_Title", strMessage: "Internet_Message", controller: controller)
        }
        
    }

    public class func callGetAPI(strPage:String,controller:UIViewController, withblock:@escaping (_ response: AnyObject?,_ status:Int,_ error:NSError)->Void){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let error = NSError()
        
        if(appDelegate.connected()){
            
            let url = strPage
            
            let _headers : HTTPHeaders = ["Content-Type":"application/json"]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: _headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        withblock(response.result.value as AnyObject?, 1, error)
                    }
                    break
                    
                case .failure(_):
                    withblock(response.result.value as AnyObject?, 0,  response.result.error! as NSError)
                    break
                    
                }
            }
            
        }else{
            FuncationManager.hideLoaginView(controller: controller)
            FuncationManager.showMessage(strTitle: "Internet_Title", strMessage: "Internet_Message", controller: controller)
        }
        
    }
    
    
}
