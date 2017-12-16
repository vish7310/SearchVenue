//
//  FuncationManager.swift
//  KingPage
//
//  Created by GuruUgam on 9/27/16.
//  Copyright © 2016 GuruUgam. All rights reserved.
//

import UIKit
import Foundation

@objc public class FuncationManager: NSObject {
    
    //MARK: All PopUp Message
    public class func showMessage(strTitle:String,strMessage:String,controller:UIViewController){
        let alert = UIAlertController.init(title: strTitle, message: strMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    public class func showMessageWithPop(strMessage:String,controller:UIViewController){
        let alert = UIAlertController.init(title: "", message: strMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            _ = controller.navigationController?.popViewController(animated: true)
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    public class func showMessageWithDismis(strMessage:String,controller:UIViewController){
        let alert = UIAlertController.init(title: "", message: strMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
                controller.dismiss(animated: true, completion: nil)
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    public class func showMessageWithConfirm(strMessage:String,controller:UIViewController,withBlock:@escaping (_ isFromYes:Bool)->Void){
        
        let alert = UIAlertController.init(title: NSLocalizedString("Warning", comment: ""), message: strMessage, preferredStyle: .alert)
        
        //let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        //subview.backgroundColor = UIColor(rgb: 0x7749EA)
       // alert.view.tintColor = UIColor.black
        
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("Yes", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            withBlock(true)
        }))
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("No", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            withBlock(false)
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    public class func showMessageWithBack(strMessage:String,controller:UIViewController,withBlock:@escaping (_ isFromYes:Bool)->Void){
        
        let alert = UIAlertController.init(title: "Success", message: strMessage, preferredStyle: .alert)
        
//        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
//        subview.backgroundColor = UIColor(rgb: 0x7749EA)
//        alert.view.tintColor = UIColor.black
        
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            withBlock(true)
        }))
       
        controller.present(alert, animated: true, completion: nil)
    }
    
    public class func showActionSheet(strMessage:String,controller:UIViewController,withBlock:@escaping (_ isFromWhich:String)->Void){
        
        let actionsheet = UIAlertController(title: NSLocalizedString("Selection", comment: ""), message:strMessage, preferredStyle: UIAlertControllerStyle.actionSheet)
        let Gallary = UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            withBlock("Gallary")
        }
        let Camara = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            withBlock("Camara")
        }
        let cancle = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel) {
            (result : UIAlertAction) -> Void in
            withBlock("Cancle")
        }
        actionsheet.addAction(Gallary)
        actionsheet.addAction(Camara)
        actionsheet.addAction(cancle)
        controller.present(actionsheet, animated: true, completion: nil)
    }
    
    public class func showActionSheetWithDiffTitle(strMessage:String,strFirst:String,strSecond:String,controller:UIViewController,withBlock:@escaping (_ isFromWhich:String)->Void){
        
        let actionsheet = UIAlertController(title:"", message:strMessage, preferredStyle: UIAlertControllerStyle.actionSheet)
        let Gallary = UIAlertAction(title: NSLocalizedString(strFirst, comment: ""), style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            withBlock(strFirst)
        }
        let Camara = UIAlertAction(title: NSLocalizedString(strSecond, comment: ""), style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            withBlock(strSecond)
        }
        let cancle = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel) {
            (result : UIAlertAction) -> Void in
            withBlock("Cancle")
        }
        actionsheet.addAction(Gallary)
        actionsheet.addAction(Camara)
        actionsheet.addAction(cancle)
        controller.present(actionsheet, animated: true, completion: nil)
    }
    
    public class func shareActivity(img:UIImage,title:String,sender:UIButton,view:UIViewController){
        let objectsToShare = [title , img] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        
        activityVC.popoverPresentationController?.sourceView = sender
        view.present(activityVC, animated: true, completion: nil)
    }
    
    //MARK: Progress(Loader) Hide And Show Method
    public class func showLoaginView(controller:UIViewController,message:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        controller.view.addSubview(appDelegate.loadingView)
        appDelegate.lblloading.text = message;
        appDelegate.loadingView.center = CGPoint(x: controller.view.frame.size.width/2, y: controller.view.frame.size.height/2)
        controller.view.isUserInteractionEnabled = false
    }
    public class func hideLoaginView(controller:UIViewController){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loadingView.removeFromSuperview()
        controller.view.isUserInteractionEnabled = true
    }
    
    //MARK: UserDefaults ModelClass
    public class func storeModelClassToUserDefaults(storeKey:String,object:AnyObject){
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.setValue(data, forKey: storeKey)
        UserDefaults.standard.synchronize()
    }
    public class func getModelClassFromUserDefaults(storeKey:String)->AnyObject{
        let object = UserDefaults.standard.object(forKey: storeKey) as! Data
        let data = NSKeyedUnarchiver.unarchiveObject(with: object) as AnyObject
        return data
    }
    public class func storeToUserDefaults(storeKey:String,object:AnyObject){
        UserDefaults.standard.setValue(object, forKey: storeKey)
        UserDefaults.standard.synchronize()
    }
    public class func getFromUserDefaults(storeKey:String)->AnyObject{
        
        return UserDefaults.standard.object(forKey: storeKey) as AnyObject
    }
    public class func getFromUserDefaultsBool(storeKey:String)->Bool{
        if(UserDefaults.standard.object(forKey: storeKey) != nil){
            return UserDefaults.standard.object(forKey: storeKey) as! Bool
        }
        return false
    }
    public class func getFromUserDefaultsString(_ storeKey:String)->String{
        if(UserDefaults.standard.object(forKey: storeKey) != nil){
            return UserDefaults.standard.object(forKey: storeKey) as! String
        }
        return ""
    }
    
    //MARK: DatePicker And Date Convert Function
    public class func getDateFromCurrentDate(formateType:String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = formateType
        return formatter.string(from: NSDate() as Date)
    }
    
    public class func getCurrentTimeStamp()->String{
        return String(describing: NSNumber(value: round(NSDate().timeIntervalSince1970 * 1000)))
    }
    public class func getCurrentTimeStampNSNumber()->NSNumber{
        return NSNumber(value: round((NSDate().timeIntervalSince1970)))
    }
    public class func getCurrentDateTimeFromTimeStamp(timeStapm:String)->Date{
                
        let date = NSDate(timeIntervalSince1970:Double(timeStapm)!)
        let formatone = DateFormatter()
        formatone.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeZone = NSTimeZone.local
        let seconds : TimeInterval = Double(timeZone.secondsFromGMT(for:date as Date))
        let localDate = NSDate(timeInterval: seconds, since: date as Date)
        return localDate as Date
    }
    public class func getDateFromTimeStamp(timeStapm:String, withFormate formate:String)->String{
        
        let date = NSDate(timeIntervalSince1970:Double(timeStapm)!)
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        return formatter.string(from: date as Date)
    }
    public class func getDateFromTimeStampWithDate(timeStapm:String, withFormate formate:String)->Date{
        
        let date = NSDate(timeIntervalSince1970:Double(timeStapm)!)
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        return date as Date
    }
    public class func getDateFromCurrentDateInDate(formateType:String)->Date{
        let formatter = DateFormatter()
        formatter.dateFormat = formateType
        return  NSDate() as Date
    }
    
    public class func getDateAndTimeStringFrom(strDate: String) -> String {
    
        let formatone = DateFormatter()
        formatone.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatone.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
        let yourDate = formatone.date(from: strDate)
        let currentDate = formatone.date(from: self.getDateFromCurrentDate(formateType: "yyyy-MM-dd HH:mm:ss"))
        
        var calendar = NSCalendar.current
        
        let unitFlags = Set<Calendar.Component>([.day, .hour, .year, .minute, .second])
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let components = calendar.dateComponents(unitFlags, from: yourDate!, to: currentDate!)
        
        if (components.day != 0){
            return String(describing: components.day!) + " day ago"
        }else if (components.hour != 0) {
            return String(describing: components.hour!) + " hours ago"
        }else if (components.minute != 0){
            return String(describing: components.minute!) + " minute ago"
        }else{
            return String(describing: components.second!) + " second ago"
        }
        
    }
    
    public class func getDateAndTimeStringFromWithDate(strDate: Date) -> String {
        
        let formatone = DateFormatter()
        formatone.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatone.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
        //let yourDate = formatone.date(from: strDate)
        let currentDate = formatone.date(from: self.getDateFromCurrentDate(formateType: "yyyy-MM-dd HH:mm:ss"))
        
        var calendar = NSCalendar.current
        
        let unitFlags = Set<Calendar.Component>([.day, .hour, .year, .minute, .second])
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let components = calendar.dateComponents(unitFlags, from: strDate, to: currentDate!)
        
        if (components.day != 0){
            return String(describing: components.day!) + " day ago"
        }else if (components.hour != 0) {
            return String(describing: components.hour!) + " hours ago"
        }else if (components.minute != 0){
            return String(describing: components.minute!) + " minute ago"
        }else{
            return String(describing: components.second!) + " second ago"
        }
        
    }
    
//    public class func isValidFirebaseUrl(sender:String)-> Bool{
//        if(sender.hasPrefix(Key_FIRStoragePath)){
//            return true
//        }else if(sender.hasPrefix("http://")){
//            return true
//        }else if(sender.hasPrefix("https://")){
//            return true
//        }
//        return false
//    }
     //MARK: Validation Function
    public class func isValidEmail(sender:String)-> Bool{
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: sender)
    }
    public class func isValidPhoneNumber(value: String) -> Bool {
        //SERVICES +1 415 670 9326
        let PHONE_REGEX = "^((\\+\\d{1,3}(-| )?\\(?\\d\\)?(-| )?\\d{1,5})|(\\(?\\d{2,6}\\)?))(-| )?(\\d{3,4})(-| )?(\\d{4})(( x| ext)\\d{1,5}){0,1}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    public class func getCharacteLength(value: String) -> Bool {
        
        if value.count < 8 {
            return true
        }
        return false
    }
    public class func blankValidation(sender:AnyObject,str:String) -> Bool {
        
        if let txt:UITextField = sender as? UITextField {
            if txt.text == "" {
                return true
            }
        }else if let btn:UIButton = sender as? UIButton {
            if btn.currentTitle != str {
                return true
            }
        }else if let tv:UITextView = sender as? UITextView {
            if tv.text == "" {
                return true
            }
        }
        
        return false
    }
    
    
    
    //MARK: UIChildPareshController
    public class func openChildViewController(parentVC:UIViewController, with childVC:UIViewController){
        
        parentVC.addChildViewController(childVC)
        childVC.view.frame = parentVC.view.frame
        parentVC.view.addSubview(childVC.view)
        parentVC.didMove(toParentViewController: childVC)
    }
    public class func removeChildViewController(childVC:UIViewController){
        
        childVC.willMove(toParentViewController: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParentViewController()
    }
    
    public class func getRandomNumber() -> NSInteger{
        let MAX : UInt32 = 9
        let MIN : UInt32 = 0
        let random_number = Int(arc4random_uniform(MAX) + MIN)
        return random_number
    }
    public class func randomStringWithLength (len : Int) -> NSInteger {
        
        let letters : NSString = "0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len{
            
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return Int(randomString as String)!
    }
    
    
}

