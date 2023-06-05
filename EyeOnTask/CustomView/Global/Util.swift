//
//  Global.swift
//  Swift_Demo
//
//  Created by Hemant Pandagre on 02/09/17.
//  Copyright © 2017 Hemant Pandagre. All rights reserved.
//

import Foundation
import UIKit
import Reachability
//import FCAlertView


let ContentLimit = "150"

enum ValidCharactors : String, CaseIterable {
    case OnlyAlphabates = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case AlphaNumeric = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    case OnlyNumbers = "1234567890"
    case NumberWithDot = "1234567890."
    case NumberWithDotMinus = "1234567890.-"
}

enum DateFormate : String, CaseIterable {
    case dd_MMM_yyyy = "dd-MMM-yyyy"
    case yyyy_MM_dd = "yyyy-MM-dd"
    case ddMMMyyyy = "dd/MMM/yyyy"
    case ddMMMyyyy_hh_mm_ss_a = "dd-MMM-yyyy hh:mm:ss a"
    case ddMMMyyyy_hh_mm = "dd-MMM-yyyy hh:mm"
    case ddMMMyyyy_HH_mm = "dd-MMM-yyyy HH:mm"
    case ddMMMyyyy_hh_mm_a = "dd-MMM-yyyy hh:mm a"
    case ddMMMyyyy_hh_mma = "dd-MMM-yyyy hh:mma"
    case fromDateFormate = "dd-MMM-yyyy 00:00:00"
    case yyyy_MM_dd_00_00_00 = "yyyy-MM-dd 00:00:00"
    case toDateFormate = "dd-MMM-yyyy 23:59:59"
    case dd_MM_yyyy_hh_mm_ss_a = "dd-MM-yyyy hh:mm:ss a"
    case yyyy_MM_dd_h_mm_a = "yyyy-MM-dd h:mm a"
    case yyyy_MM_dd_HH_mm_ss = "yyyy-MM-dd HH:mm:ss"
    case yyyy_MM_dd_HH_mm_ss_a = "yyyy-MM-dd hh:mm:ss a"
    case h_mm_a = "h:mm a"
    case HH_MM = "H:MM"
    case MM_yy = "MM-yy"
    case yyyy_MM_dd_hh_mm_a = "yyyy-MM-dd hh:mm a"
    case dd_MM_yyyy = "dd-MM-yyyy h:mm a"
    case hh_mm_a  = "hh:mm a"
    case dd_MM_yyyy_HH_mm_ss = "dd-MM-yyyy HH:mm:ss"
    case dd_MM_yyyy_HH_mm = "dd-MM-yyyy HH:mm"
    case dd_MM_yy = "dd-MM-yyyy"
    case ddMMyy = "dd/MM/yyyy"
    case dd_MMM_yyyy_HH_mm = "d-MMM-yyyy HH:mm"
    case dd_MMM_yyyy_HH_mm_a = "d-MMM-yyyy HH:mm a"
    case dd_MM_yyyy_HH_mm_a = "d-MM-yyyy HH:mm a"
    case yyyy_MM_dd_HH_mm = "yyyy/MM/dd HH:mm"
    case yyyyMM_dd_HH_mm_ss = "yyyy/MM/dd HH:mm:ss"
    case dd_MMM_yyyy_hh_mm_ss = "dd-MMM-yyyy HH:mm:ss"
   
}


enum FCAlertType {
    case FCAlertTypeSuccess
    case FCAlertTypeWarning
    case FCAlertTypeCaution
    case FCAlertTypeProgress
}

// capitalization Of First Letter
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    func capitalizingFirstLetterfirstandlast() -> String {
        return prefix(1).uppercased() +  prefix(1).uppercased()
    }
    func capitalizingFirst() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
        self = self.capitalizingFirstLetterfirstandlast()
    }
    
    var containsSpecialCharacter: Bool {
        let regex = "[^0-9]"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }
    
    var containsAmountCharactor: Bool {
        let regex = "[^0-9-]"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }
    
}

extension URL {
    func filename() -> String {
         let filename = self.lastPathComponent
         let splitName = filename.split(separator: ".")
         let name = splitName.first ?? ""
         return String(name)
    }
    
    func fileExtention() -> String {
         let filename = self.lastPathComponent
         let splitName = filename.split(separator: ".")
         let name = (splitName.last ?? "").lowercased()
         return String(name)
    }
    
    
}


func hasNotch() -> Bool {
    return UIDevice.current.hasNotch
}


func headerGreenColor() -> UIColor {
    return UIColor(red:0/255, green:132/255, blue:141/255, alpha:1.0)
}

func setRegion(region: String) -> Void {
    UserDefaults.standard.set(region, forKey: "region")
}


func currentRegion() -> String? {
    return  UserDefaults.standard.value(forKey: "region") as? String
}

func isValidateInputCharactors(text: String, validation:ValidCharactors) -> String {
    let aSet = NSCharacterSet(charactersIn:validation.rawValue).inverted
    let compSepByCharInSet = text.components(separatedBy: aSet)
    let finalText = compSepByCharInSet.joined(separator: "")
    return  finalText
}

func trimString(string:String) -> String {
    let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedString
}

func updateDefaultTime(_ duration: String) -> String { 
   // "01:undefin" // reason for crash
    if duration.contains("un") {
        return "01:00"
    } else {
        return duration
    }
}

func DebugModePrint() -> Bool {
    #if DEBUG
     return true
    #else
     return false
    #endif
}


extension UIViewController {
    
    func showToast(message: String) {
        DispatchQueue.main.async {
            let window = windowController.topMostViewController().view
            let toastLbl = UILabel()
            toastLbl.text = message
            toastLbl.textAlignment = .center
            toastLbl.font = UIFont.systemFont(ofSize: 16)
            toastLbl.textColor = UIColor.white
            toastLbl.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLbl.numberOfLines = 0
            let textSize = toastLbl.intrinsicContentSize
            let labelHeight = ( textSize.width / window!.frame.width ) * 30
            let labelWidth = min(textSize.width, window!.frame.width - 40)
            let adjustedHeight = max(labelHeight, textSize.height + 20)
            
            toastLbl.frame = CGRect(x: 20, y: (window!.frame.height - 90 ) - adjustedHeight, width: labelWidth + 20, height: adjustedHeight)
            toastLbl.center.x = window!.center.x
            toastLbl.layer.cornerRadius = 10
            toastLbl.layer.masksToBounds = true
            
            window!.addSubview(toastLbl)
            
            UIView.animate(withDuration: 3.0, animations: {
                toastLbl.alpha = 0
            }) { (_) in
                toastLbl.removeFromSuperview()
            }
        }
    }
    
    
    func showToast(message : String , width : CGFloat ) {
        let toastLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - (width/2), y: self.view.frame.size.height-100, width: width, height: 45))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = Font.ArimoRegular(fontSize: 13.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        windowController.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
  
}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

//======================================================
// MARK: For size setting according to device screen
//======================================================
extension UIScreen {
    
    enum SizeType: CGFloat {
        case Unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5 = 1136.0
        case iPhone6 = 1334.0
        case iPhone6Plus = 1920.0
        case iPhoneX = 2436
        case iPhoneSE = 1234.0
        case iPhone7 = 1335.0
    }
    
    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
        return sizeType
    }
}


extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}



//============================
//MARK:- Get json from local
//============================
func getJson(fileName : String)-> [String : Any]{
    if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            let dict = (jsonResult as? [String : Any])
           // print(dict)
            return dict!
            
        } catch {
        }
    }
    return ["" : ""]
}


//============================
//MARK:- UserDefalt
//============================
func setDataInUserDefalt( key : String , userData : Any){
    
    let userDefaults = UserDefaults.standard
    userDefaults.setValue(userData, forKey: key)
    userDefaults.synchronize() // don't forget this!!!!
  }

   func getDataInUserDefalt(key : String) -> Any{
       let userDefaults = UserDefaults.standard
       return userDefaults.value(forKey:key) as Any
    }


//============================
//MARK:- AppDelegate Object
//============================
    let APP_Delegate = UIApplication.shared.delegate as! AppDelegate


func lineSpacing(string : String, lineSpacing : CGFloat) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string)
    
    // *** Create instance of `NSMutableParagraphStyle`
    let paragraphStyle = NSMutableParagraphStyle()
    
    // *** set LineSpacing property in points ***
    paragraphStyle.lineSpacing = lineSpacing // Whatever line spacing you want in points
    
    // *** Apply attribute to string ***
    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor(red: 115/255, green: 125/255, blue: 126/255, alpha: 1), range:NSMakeRange(0, attributedString.length))
    
    
    return attributedString
}

func convertDateToString(date:Date, dateFormate:DateFormate) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormate.rawValue
    formatter.timeZone = TimeZone.current
    //formatter.locale = Locale(identifier: "en_US")
    if let langCode = getCurrentSelectedLanguageCode() {
        formatter.locale = Locale(identifier: langCode)
    }
    let strDate = formatter.string(from: date)
    return strDate
}


func convertTimeStampToString(timestamp:String, dateFormate:DateFormate) -> String {
    let date = NSDate(timeIntervalSince1970: (Double(timestamp)!))
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormate.rawValue
    formatter.timeZone = TimeZone.current
    //formatter.locale = Locale(identifier: "en_US")
    if let langCode = getCurrentSelectedLanguageCode() {
        formatter.locale = Locale(identifier: langCode)
    }
    //=====================================================converttimezone
    var converTimeZone = ""
    
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            converTimeZone = formatter.string(from: date as Date)
        }else{
            let timeZoneDemo11 = formatter.string(from: date as Date)
           converTimeZone = createDateTimeDemo(timestamp: timestamp, dateFormate: formatter.dateFormat) ?? ""
        }
    }
    //=====================================================converttimezone
    let strDate = converTimeZone//formatter.string(from: date as Date)
    return strDate
}

func convertTimeStampToStringForDetailJob(timestamp:String, dateFormate:DateFormate) -> String {
    let date = NSDate(timeIntervalSince1970: (Double(timestamp)!))
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormate.rawValue
    formatter.timeZone = TimeZone.current
    //formatter.locale = Locale(identifier: "en_US")
    if let langCode = getCurrentSelectedLanguageCode() {
        formatter.locale = Locale(identifier: langCode)
    }
    
    //============================================================Time zoneCovert
    var converTimeZone = ""
    
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            converTimeZone = formatter.string(from: date as Date)
        }else{
          
            converTimeZone = createDateTimeDemo(timestamp: timestamp, dateFormate: formatter.dateFormat) ?? ""
           
        }
    }
    //============================================================
    
    let strDate = converTimeZone//formatter.string(from: date as Date)
    return strDate
}


func convertDateToStringForServer(date:Date, dateFormate:DateFormate) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormate.rawValue
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale(identifier: "en_US")
    
    //=====================================================converttimezone
    var converTimeZone = ""

    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            converTimeZone = formatter.string(from: date)
        }else{
            let timeZoneDemo11 = formatter.string(from: date)
           converTimeZone = convertTimeZoneForAllDateTime(dateStr: timeZoneDemo11, dateFormate: formatter.dateFormat) ?? ""
        }
    }
    //=====================================================converttimezone
    let strDate = converTimeZone//formatter.string(from: date)
    return strDate
}

func convertDateToStringForcostomfieldandform(date:Date, dateFormate:DateFormate) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormate.rawValue
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale(identifier: "en_US")
    let strDate = formatter.string(from: date)
    return strDate
}

func convertDateRangeInString(date:Date, dateFormate:DateFormate) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormate.rawValue
    //formatter.timeZone = TimeZone.timeZoneDataVersion
    formatter.locale = Locale(identifier: "en_US")
    let strDate = formatter.string(from: date)
    return strDate
}


func convertTimestampToDateString( timeInterval : String) -> String{
    let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm a"
    
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter.locale = Locale(identifier: langCode)
    }
    //=====================================================converttimezone
    var converTimeZone = ""
    
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            converTimeZone = dateFormatter.string(from: date as Date)
        }else{
          converTimeZone = createDateTimeDemo(timestamp: timeInterval, dateFormate: dateFormatter.dateFormat) ?? ""
        }
    }
    //=====================================================converttimezone
    
    return converTimeZone
}

func convertTimestampToDateForPayment( timeInterval : String) -> String{
    
    let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormate.dd_MMM_yyyy.rawValue
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter.locale = Locale(identifier: langCode)
    }
    
    //=====================================================converttimezone
    var converTimeZone = ""
    
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            converTimeZone = dateFormatter.string(from: date as Date)
        }else{
           converTimeZone = createDateTimeDemo(timestamp: timeInterval, dateFormate: dateFormatter.dateFormat) ?? ""
        }
    }
    //=====================================================converttimezone
    //let strDate = dateFormatter.string(from: date as Date)
    return converTimeZone
}

func convertTimestampToDateForComplationDetail( timeInterval : String) -> String{
    let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormate.yyyyMM_dd_HH_mm_ss.rawValue
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter.locale = Locale(identifier: langCode)
    }
    
    //============================================================Time zoneCovert
    var converTimeZone = ""
   
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            converTimeZone = dateFormatter.string(from: date as Date)
        }else{
       
            converTimeZone = createDateTimeDemo(timestamp: timeInterval, dateFormate: dateFormatter.dateFormat) ?? ""
           
        }
    }
    //============================================================
    
    let strDate = converTimeZone//dateFormatter.string(from: date as Date)
    return strDate
}

func convertTimestampToDate( timeInterval : String) -> (String, String){


    let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

    let strTime = dateFormatter.string(from: date as Date)
    
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm:ss"
    let date1 : Date = dateFormatter1.date(from: strTime)!

    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
        if enableCustomForm == "0"{
            dateFormatter1.dateFormat = "h:mm a"
        }else{
            dateFormatter1.dateFormat = "HH:mm"
        }
    }
    
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter1.locale = Locale(identifier: langCode)
    }
    
    let schTime12 = dateFormatter1.string(from: date1)
  
    //============================================================Time zoneCovert
    var converTimeZone = ""
   
    
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            converTimeZone = schTime12
        }else{
       
            converTimeZone = createDateTimeDemo(timestamp: timeInterval, dateFormate: dateFormatter1.dateFormat) ?? ""
           
        }
    }
    //============================================================
    let myStringArr = converTimeZone.components(separatedBy: " ")
    if myStringArr.count == 1 {
        return (myStringArr[0] , "")
    }else{
        return (myStringArr[0] , myStringArr[1])
    }
}

func convertTimestampToDateFormate( timeInterval : String) -> String{
    
    if timeInterval != "" {
        let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
         
            if let langCode = getCurrentSelectedLanguageCode() {
                dateFormatter.locale = Locale(identifier: langCode)
            }
        
        //============================================================Time zoneCovert
        var converTimeZone = ""
       
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                converTimeZone = dateFormatter.string(from: date as Date)
            }else{
           
                converTimeZone = createDateTimeDemo(timestamp: timeInterval, dateFormate: dateFormatter.dateFormat) ?? ""
                
            }
        }
        //============================================================
            let strTime = converTimeZone//dateFormatter.string(from: date as Date)
            
            return strTime
    }
    
    return " "
}

func convertTimestampToDateFormatejob11( date1 : Date) -> String{
    
    if date1 != nil {
       
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
      
            if let langCode = getCurrentSelectedLanguageCode() {
                dateFormatter.locale = Locale(identifier: langCode)
            }
            let strTime = dateFormatter.string(from: date1 as Date)
    
            return strTime
    }
    
    return ""
}

func currentDateToStringDate(date: Date)-> String {
   // let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.locale = Locale(identifier: "en_US")
    let timeStamp = dateFormatter.string(from: date)
    return timeStamp
}

func currentDateAnTime24HrFormate(date: Date)-> String {
   
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.locale = Locale(identifier: "en_US")
    let timeStamp = dateFormatter.string(from: date)
    return timeStamp
}


func CurrentDateTime() -> String {// FOR SYNC REQUEST  DATETIME
  
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.locale = Locale(identifier: "en_US")
    
    //=====================================================converttimezone
    var timeZoneDemo1 = ""
    
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            timeZoneDemo1 = dateFormatter.string(from: date)
        }else{
           let timeZoneDemo11 = dateFormatter.string(from: date)//notchang for sync time
            timeZoneDemo1 = convertTimeZoneForAllDateTime(dateStr: timeZoneDemo11, dateFormate: dateFormatter.dateFormat) ?? ""
           
        }
    }
    //=====================================================converttimezone
   // let timeStamp = dateFormatter.string(from: date)
    return timeZoneDemo1
}

func CurrentDateTime24Hr() -> String {
    //Get current time of Device
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    dateFormatter.timeZone = NSTimeZone.local
    
    
    dateFormatter.locale = Locale(identifier: "en_US")
    let timeStamp = dateFormatter.string(from: date)
    return timeStamp
}

func CurrentDateTimeForLocation() -> String {
    //Get current time of Device
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.locale = Locale(identifier: "en_US")
    let timeStamp = dateFormatter.string(from: date)
    return timeStamp
}


func currentDateTime24HrsFormate()-> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.locale = Locale(identifier: "en_US")
    let timeStamp = dateFormatter.string(from: date)
    return timeStamp
}

func currentDateforAddQuote()-> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.locale = Locale(identifier: "en_US")
    let timeStamp = dateFormatter.string(from: date)
    return timeStamp
}

func CurrentTime() -> String {
    //Get current time of Device
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mma"
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.locale = Locale(identifier: "en_US")
    let timeStamp = dateFormatter.string(from: date)
    return timeStamp
}

func CurrentLocalDate() -> Date {
    //Get current time of Device
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = NSTimeZone.local
    let timeStamp = dateFormatter.string(from: date)
    dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
    dateFormatter.locale = Locale(identifier: "en_US")
     let convertedDate = dateFormatter.date(from: timeStamp)
    return convertedDate!
}

func convertInlocalDate(date : Date) -> Date {
    //Get current time of Device
   // let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = NSTimeZone.local
    let timeStamp = dateFormatter.string(from: date)
    dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
    dateFormatter.locale = Locale(identifier: "en_US")
     let convertedDate = dateFormatter.date(from: timeStamp)
    return convertedDate!
}

func isPngJpgJpegImage(fileExtention : String) -> Bool {
    if fileExtention == "jpg" || fileExtention == "png" || fileExtention == "jpeg" {
        return true
    }else{
        return false
    }
}

func getTwoDaysAgoTimeStamp() -> String {
    
    var noon: Date {
           return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
       }
    
    var twoDayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }

   

    let timeStamp = twoDayBefore.timeIntervalSince1970
    let strTimeStamp = Int(timeStamp)
    return String(strTimeStamp)
}

func convertDateStringToTimestampAppoiment(dateString : String) -> String {
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
dateFormatter.timeZone = TimeZone.current
dateFormatter.locale = Locale(identifier: "en_US")
let date: Date? = dateFormatter.date(from: dateString)
let interval: TimeInterval? = date?.timeIntervalSince1970
return String(Int(interval!))
}

func convertDateStringToTimestamp(dateString : String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US")
    let date: Date? = dateFormatter.date(from: dateString)
    let interval: TimeInterval? = date?.timeIntervalSince1970
    return String(Int(interval!))
}

func convertDateToStringForServerAddJob(dateStr: String) -> String {

    let formatter = DateFormatter()
       formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
       formatter.timeZone = TimeZone.current
       formatter.locale = Locale(identifier: "en_US")
       let strDate = formatter.date(from: dateStr)!
       
       let formatter1 = DateFormatter()
       formatter1.dateFormat = "dd-MM-yyyy HH:mm:ss"
       formatter1.timeZone = TimeZone.current
       formatter1.locale = Locale(identifier: "en_US")
       let strDate1 = formatter.string(from: strDate)
       
       return strDate1
}

func convertDateForFirebaseInUTC(date : Date) -> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    dateFormatter.locale = Locale(identifier: "en_US")
    return  dateFormatter.string(from: date)
}

func dateWithComparisonDate(strDate : String) -> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    dateFormatter.locale = Locale(identifier: "en_US")
    let enteredDate = dateFormatter.date(from: strDate)
    
  
    let calender = Calendar.current
    let otherDay = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: enteredDate!)
    let today = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())

    if(today.day == otherDay.day && today.month == otherDay.month && today.year == otherDay.year && today.era == otherDay.era && today.day == otherDay.day && today.day == otherDay.day){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = Locale(identifier: "en_US")
        let display = dateFormatter.string(from: enteredDate!)
        return String(format: "%@", display)
    }else{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = Locale(identifier: "en_US")
        let display = dateFormatter.string(from: enteredDate!)
        return String(format: "%@", display)
        // return dateFormateChange(dateString: strDate)
    }
}


func compareTime(serverStartTime : String, serverEndTime : String) -> (Bool,Int,Int) {

    let calendar = Calendar.current
    let now = Date()
    
    let start = change12hourTo24hour(timeString: serverStartTime).components(separatedBy: ":")
    let end = change12hourTo24hour(timeString: serverEndTime).components(separatedBy: ":")
    
    
    let startTime = calendar.date(
        bySettingHour: Int(start[0])!,
        minute: Int(start[1])!,
        second: Int(start[2])!,
        of: now)!
    
    let endTime = calendar.date(
        bySettingHour: Int(end[0])!,
        minute: Int(end[1])!,
        second: Int(start[2])!,
        of: now)!
    
    if now <= endTime
    {
    
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: now, to: startTime)
        let intervalTime = (components.hour! * 3600) + (components.minute! * 60) + (components.second!)
       // print("The time is between 8:00 and 16:30")
        
        let components1 = Calendar.current.dateComponents([.hour, .minute, .second], from: now, to: endTime)
        let endIntervalTime = (components1.hour! * 3600) + (components1.minute! * 60) + (components1.second!)
        
        
        return (true,intervalTime,endIntervalTime)
    }
    
     return (false,0,0)
}

func change12hourTo24hour(timeString : String) -> String {
    let dateAsString = timeString
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    dateFormatter.dateFormat = "h:mm:ss a"
    let date = dateFormatter.date(from: dateAsString)
    dateFormatter.dateFormat = "HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US")
    let date24 = dateFormatter.string(from: date!)

    return date24
}

func change24hourTo12hour(timeString : String) -> String {
    let dateAsString = timeString
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
    let date = dateFormatter.date(from: dateAsString)
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
    dateFormatter.locale = Locale(identifier: "en_US")
    let date24 = dateFormatter.string(from: date!)

    return date24
}

func dateFormateChange(dateString : String) -> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    let date = dateFormatter.date(from: dateString)
    
    dateFormatter.dateFormat = "EEE-MMM-dd, HH:mm"
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.locale = Locale(identifier: "en_US")
    return dateFormatter.string(from: date!)
    
}

func timeStampToDateFormateForCustomFieldAndFome( timeInterval : String, dateFormate : String) -> String{
    let date = NSDate(timeIntervalSince1970: (Double(timeInterval))!)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormate
    dateFormatter.locale = Locale(identifier: "en_US")
    
    //=====================================================converttimezone
    var converTimeZone = ""
    
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            converTimeZone = dateFormatter.string(from: date as Date)
        }else{
            let timeZoneDemo11 = dateFormatter.string(from: date as Date)
            converTimeZone = createDateTimeDemo(timestamp: timeZoneDemo11, dateFormate: dateFormatter.dateFormat) ?? ""
         
        }
    }
    //=====================================================converttimezone
    
    let strDate = converTimeZone//dateFormatter.string(from: date as Date)
   
    return strDate
}

func timeStampToDateFormate( timeInterval : String, dateFormate : String) -> String{
    let date = NSDate(timeIntervalSince1970: (Double(timeInterval))!)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormate
    dateFormatter.locale = Locale(identifier: "en_US")
    let strDate = dateFormatter.string(from: date as Date)
   
    return strDate
}


func dateFormateWithoutTime( timeInterval : String) -> String{
    let date = NSDate(timeIntervalSince1970: (Double(timeInterval))!)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "en_US")
    let strDate = dateFormatter.string(from: date as Date)
    //print("Date = " , strDate)
    return strDate
}

func CurrentDateTimeForLiveLocationTracking() -> String {
    //Get current time of Device
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.locale = Locale(identifier: "en_US")
    let timeStamp = dateFormatter.string(from: date)
    return timeStamp
}

func timeDifferenceForChat(unixTimestamp : String) -> String
{
    if  unixTimestamp == "" {
        return ""
    }
    let calendar = NSCalendar.current
    let dateFormatter = DateFormatter()
     let date = Date(timeIntervalSince1970: Double(unixTimestamp)!)
    dateFormatter.dateFormat = DateFormate.ddMMMyyyy_hh_mm_a.rawValue
    dateFormatter.timeZone = NSTimeZone.local
    
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter.locale = Locale(identifier: langCode)
    }
    
    let strDate = dateFormatter.string(from: date)
    
    if calendar.isDateInYesterday(date) { return "Yesterday"}
    else if calendar.isDateInToday(date) {
        
        let time = strDate.components(separatedBy: " ")
        
        if time.count > 2 {
            return "\(time[1]) \(time[2])"
        }
        
        return ""
    }
    else if calendar.isDateInTomorrow(date) { return "Tomorrow"}
    else {
        let time = strDate.components(separatedBy: " ")
        
        if time.count > 2 {
            return "\(time[0])"
        }
        
        return ""
    }
}


func compareTwodate(schStartDate : String , schEndDate : String, dateFormate:DateFormate) -> String{
   
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormate.rawValue  //"MM-yy
    //formatter.locale = Locale(identifier: "en_US")
    
    if let langCode = getCurrentSelectedLanguageCode() {
        formatter.locale = Locale(identifier: langCode)
    }
    
    let startDate = formatter.date(from: schStartDate)
    let endDate = formatter.date(from: schEndDate)
    switch startDate?.compare(endDate!) {
    case .orderedAscending?     :  return("orderedAscending")
    case .orderedDescending?    :  return("orderedDescending")
    case .orderedSame?          :  return("orderedSame")
    case .none:    return ""
    }
}

func compareTwodateInAddQuotes(schStartDate : String , schEndDate : String, dateFormate:DateFormate) -> String{
    
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormate.rawValue  
    formatter.locale = Locale(identifier: "en_US")
    let startDate = formatter.date(from: schStartDate)
    let endDate = formatter.date(from: schEndDate)
    switch startDate?.compare(endDate!) {
    case .orderedAscending?     :  return("orderedAscending")
    case .orderedDescending?    :  return("orderedDescending")
    case .orderedSame?          :  return("orderedSame")
    case .none:    return ""
    }
    
}


func convertSystemDateIntoLocalTimeZone(date : Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd 00:00:00"
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale(identifier: "en_US")
    let result = formatter.string(from: date)
    return result
    
}

func convertSystemDateIntoLocalTimeZoneWithStaticTime(date : Date) -> String {
    
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss a"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US")
        let strDate = formatter.string(from: date)

    return strDate
    
}

func getDate(localDate: Date) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd 00:00:00 +000"
    dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")! as TimeZone
    let startDate2 = dateFormatter.string(from: localDate)
    //print(startDate2)
    
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "yyyy-MM-dd 00:00:00 +000"
    dateFormatter1.timeZone = NSTimeZone(abbreviation: "GMT")! as TimeZone
    dateFormatter1.locale = Locale(identifier: "en_US")
    let startDate21 = dateFormatter1.date(from: startDate2)
   
    
    return startDate21!
}

func datedifference(timeInterval : String , timeZone : String) -> String{ // which date small of big
    
    let sourceTimeZoneGMT = NSTimeZone(abbreviation: "GMT")
    let destinationTimeZoneGMT = TimeZone.current
    let sourceGMTOffsetGMT = sourceTimeZoneGMT?.secondsFromGMT(for: Date())
    let destinationGMTOffsetGMT = destinationTimeZoneGMT.secondsFromGMT(for: Date())
    let intervalGMT =  destinationGMTOffsetGMT - sourceGMTOffsetGMT!
    let currentDate = Date.init(timeInterval: TimeInterval(intervalGMT), since: Date())

    
    
    
    let sourceDate1 = NSDate(timeIntervalSince1970:Double(timeInterval)!)
    let sourceTimeZone1 = NSTimeZone(abbreviation: "GMT")
    var destinationTimeZone1 : TimeZone!
    if(timeZone == ""){
         destinationTimeZone1 = TimeZone.current
    }else{
         destinationTimeZone1 = TimeZone.init(identifier: timeZone)
    }
    let sourceGMTOffset1 = sourceTimeZone1?.secondsFromGMT(for: sourceDate1 as Date)
    let destinationGMTOffset1 = destinationTimeZone1?.secondsFromGMT(for: sourceDate1 as Date)
    let interval1 =  destinationGMTOffset1! - sourceGMTOffset1!
    let destinationDate = Date.init(timeInterval: TimeInterval(interval1), since: sourceDate1 as Date)
    
   
   //  print(getDate(localDate: currentDate))
     //print(getDate(localDate: destinationDate))
    
    let startDate = getDate(localDate: currentDate)
    let endDate = getDate(localDate: destinationDate)
 
  //  print(startDate)
  //  print(endDate)
    
    let dateCompaire = startDate.compare(endDate)
   // print(dateCompaire)
        switch dateCompaire  {
        case .orderedAscending:
            //print("\(secoundDate!) is after \(firstDate!)")
            return("Big")
        case .orderedDescending:
            //print("\(secoundDate!) is before \(firstDate!)")
            return("Small")
        default:
            // print("\(secoundDate!) is the same as \(firstDate!)")
            return("Same")
        }
    
}



func mergedDate(date : Date , time : Date) -> Date{
    if(date.description != " " && time.description != " "){
        let gregorian = Calendar.init(identifier: .gregorian)
        let unitFlagsDate: Set<Calendar.Component> = [.year, .month, .day]
        var dateComponents = gregorian.dateComponents(unitFlagsDate, from: date)
        let unitFlagsTime: Set<Calendar.Component> = [.hour, .minute, .second]
        var timeComponents = gregorian.dateComponents(unitFlagsTime, from: time)
        timeComponents.timeZone = TimeZone.init(secondsFromGMT: 0)
        dateComponents.second = timeComponents.second
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
       // dateComponents.timeZone = TimeZone.init(secondsFromGMT: 0)
        let combDate = gregorian.date(from: dateComponents)
        return combDate!
    }
    return date
}

func currentMergedDate(date : Date , time : Date) -> Date{
   
    if(date.description != " " && time.description != " "){
        let gregorian = Calendar.init(identifier: .gregorian)
        let unitFlagsDate: Set<Calendar.Component> = [.year, .month, .day]
        var dateComponents = gregorian.dateComponents(unitFlagsDate, from: date)
       //   let unitFlagsTime: Set<Calendar.Component> = [.hour, .minute, .second]
      //  var timeComponents = gregorian.dateComponents(unitFlagsTime, from: time)
        dateComponents.second = -10
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone.init(secondsFromGMT: 0)
        let combDate = gregorian.date(from: dateComponents)
        return combDate!
    }
    return date
}


    
    func compareOfTodayAndYesterday(dateString : String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let serverDate = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "EEE-MMM-dd, HH:mm"
        dateFormatter.timeZone = NSTimeZone.local
        
        
        let sysDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
         formatter.locale = Locale(identifier: "en_US")
        let order = Calendar.current.compare(sysDate, to: serverDate!, toGranularity: .day)
        
        switch order {
        case .orderedAscending:
            //print("\(serverDate!) is after \(sysDate)")
            return("Big")
        case .orderedDescending:
            //print("\(serverDate!) is before \(sysDate)")
            return("Small")
        default:
           // print("\(serverDate!) is the same as \(sysDate)")
            return("Today")
        }
    }

func dayDifference(unixTimestamp : String) -> String
{
   // print(unixTimestamp)
    if  unixTimestamp == "" {
        return ""
    }
    let calendar = NSCalendar.current
    let dateFormatter = DateFormatter()
    var date = Date(timeIntervalSince1970: Double(unixTimestamp)!)
    dateFormatter.dateFormat = "d MMM,yyyy"
    dateFormatter.timeZone = NSTimeZone.local
    
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter.locale = Locale(identifier: langCode)
    }

    
    let strDate = dateFormatter.string(from: date)
    //============================================================Time zoneCovert
    var converTimeZone = ""
   
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            converTimeZone = strDate
        }else{
       
            converTimeZone = createDateTimeDemo(timestamp: unixTimestamp, dateFormate: dateFormatter.dateFormat) ?? ""
        
            date = dateFormatter.date(from: converTimeZone) ?? Date()
            
        }
    }
    //============================================================
 
    
    if calendar.isDateInYesterday(date) {
        
        return "Yesterday, \(converTimeZone)"}
    
    else if calendar.isDateInToday(date) {
        
        return "Today, \(converTimeZone)"}
    
    else if calendar.isDateInTomorrow(date) {
        
        return "Tomorrow, \(converTimeZone)"}
    
    else {
       
        return converTimeZone
    }
  //  print("cunvertFinal \(converTimeZone)")
        
    
}

func dayDifferenceDemo(unixTimestamp : String) -> String
{
   // print(unixTimestamp)
    if  unixTimestamp == "" {
        return ""
    }
    let calendar = NSCalendar.current
    let dateFormatter = DateFormatter()
    let date = Date(timeIntervalSince1970: Double(unixTimestamp)!)
    dateFormatter.dateFormat = "d MMM,yyyy"
    dateFormatter.timeZone = NSTimeZone.local
    
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter.locale = Locale(identifier: langCode)
    }
    
    //=====================================================converttimezone
    var converTimeZone = ""
    
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            converTimeZone = dateFormatter.string(from: date)
        }else{
            let timeZoneDemo11 = dateFormatter.string(from: date as Date)
            converTimeZone = createDateTimeDemo(timestamp: unixTimestamp, dateFormate: dateFormatter.dateFormat) ?? ""
         
        }
    }
    //=====================================================converttimezone
    
    
    let strDate = converTimeZone//dateFormatter.string(from: date)
    
    if calendar.isDateInYesterday(date) { return "Yesterday, \(strDate)"}
    else if calendar.isDateInToday(date) { return "Today, \(strDate)"}
    else if calendar.isDateInTomorrow(date) { return "Tomorrow, \(strDate)"}
    else {
        return strDate
    }
}

func dayDifferenceJobDetail(unixTimestamp : String) -> String
{
   // print(unixTimestamp)
    if  unixTimestamp == "" {
        return ""
    }
    let calendar = NSCalendar.current
    let dateFormatter = DateFormatter()
    let date = Date(timeIntervalSince1970: Double(unixTimestamp)!)
    dateFormatter.dateFormat = "dd-MMM-yyyy"
    dateFormatter.timeZone = NSTimeZone.local
    
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter.locale = Locale(identifier: langCode)
    }
    
    let strDate = dateFormatter.string(from: date)
    
    if calendar.isDateInYesterday(date) { return "\(strDate)"}
    else if calendar.isDateInToday(date) { return "\(strDate)"}
    else if calendar.isDateInTomorrow(date) { return "\(strDate)"}
    else {
        return strDate
    }
}


func changeColoreOFDate(main_string : String , string_to_color : String)-> NSMutableAttributedString{
    
    let range = (main_string as NSString).range(of: string_to_color)
    let attribute = NSMutableAttributedString.init(string: main_string)
    attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 38.0/255.0, green: 151.0/255.0, blue: 159.0/255.0, alpha: 1.0), range: range)
    return attribute
}


func dateFormateWithMonthandDayAndYears(timeInterval : String)-> String{
    
    var strDate = ""
    if timeInterval != ""{
        let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")! as TimeZone
        dateFormatter.locale = Locale(identifier: "en_US")
        strDate = dateFormatter.string(from: date as Date)
    }
    
    return strDate
}

func dateFormateWithYeat(timeInterval : String)-> String{
    
    var strDate = ""
    if timeInterval != ""{
        let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.timeZone =  NSTimeZone.local
       // dateFormatter.locale = Locale(identifier: "en_US")
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter.locale = Locale(identifier: langCode)
        }
        strDate = dateFormatter.string(from: date as Date)
    }
    
    return strDate
}

func dateFormateWithYeatExpense(timeInterval : String)-> String{
    
    var strDate = ""
    if timeInterval != ""{
        let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.timeZone =  NSTimeZone.local
       // dateFormatter.locale = Locale(identifier: "en_US")
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter.locale = Locale(identifier: langCode)
        }
        strDate = dateFormatter.string(from: date as Date)
    }
    
    return strDate
}

func dateFormateWithYeat1(timeInterval : String)-> String{
    
    var strDate = ""
    if timeInterval != ""{
        let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone =  NSTimeZone.local
       // dateFormatter.locale = Locale(identifier: "en_US")
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter.locale = Locale(identifier: langCode)
        }
        strDate = dateFormatter.string(from: date as Date)
    }
    
    return strDate
}


func dateFormateWithMonthandDay(timeInterval : String)-> String{
    
    var strDate = ""
    if timeInterval != ""{
        let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        dateFormatter.timeZone =  NSTimeZone.local
    
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter.locale = Locale(identifier: langCode)
        }
        //=====================================================converttimezone
        var converTimeZone = ""
        
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                converTimeZone = dateFormatter.string(from: date as Date)
            }else{
               
                converTimeZone = createDateTimeDemo(timestamp: timeInterval, dateFormate: dateFormatter.dateFormat) ?? ""
            }
        }
        //=====================================================converttimezone
        strDate = converTimeZone//dateFormatter.string(from: date as Date)
    }
    
    return strDate
}

func dateFormateWithMonthandDayAndYearsShowDayh(timeInterval : String)-> String{
    
    var strDate = ""
    if timeInterval != ""{
        let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone =  NSTimeZone.local
       // dateFormatter.locale = Locale(identifier: "en_US")
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter.locale = Locale(identifier: langCode)
        }
        //=====================================================converttimezone
        var converTimeZone = ""
        
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                converTimeZone = dateFormatter.string(from: date as Date)
            }else{
               
                converTimeZone = createDateTimeDemo(timestamp: timeInterval, dateFormate: dateFormatter.dateFormat) ?? ""
            }
        }
        //=====================================================converttimezone
        strDate = converTimeZone//dateFormatter.string(from: date as Date)
    }
    
    return strDate
}
func dateFormateWithMonthandDayAndYearsShowDay(timeInterval : String)-> String{
    
    var strDate = ""
    if timeInterval != ""{
        let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-d-yyyy"
        dateFormatter.timeZone =  NSTimeZone.local
       // dateFormatter.locale = Locale(identifier: "en_US")
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter.locale = Locale(identifier: langCode)
        }
        //=====================================================converttimezone
        var converTimeZone = ""
        
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                converTimeZone = dateFormatter.string(from: date as Date)
            }else{
               
                converTimeZone = createDateTimeDemo(timestamp: timeInterval, dateFormate: dateFormatter.dateFormat) ?? ""
            }
        }
        //=====================================================converttimezone
        strDate = converTimeZone//dateFormatter.string(from: date as Date)
    }
    
    return strDate
}

func dateFormateWithMonthandDayAndYearsShowDayAndTime(timeInterval : String)-> String{
    
    var strDate = ""
    if timeInterval != ""{
        let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d yyyy, hh:mm a"
        dateFormatter.timeZone =  NSTimeZone.local
       // dateFormatter.locale = Locale(identifier: "en_US")
        if let langCode = getCurrentSelectedLanguageCode() {
            dateFormatter.locale = Locale(identifier: langCode)
        }
        
        //=====================================================converttimezone
        var converTimeZone = ""
        
        if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
            if isAutoTimeZone == "0"{
                converTimeZone = dateFormatter.string(from: date as Date)
            }else{
               
                converTimeZone = createDateTimeDemo(timestamp: timeInterval, dateFormate: dateFormatter.dateFormat) ?? ""
            }
        }
        //=====================================================converttimezone
        strDate = converTimeZone //dateFormatter.string(from: date as Date)
    }
    
    return strDate
}



func schStartDate(timeInterval : String)-> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone.local
    let date = dateFormatter.date(from:timeInterval)
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.locale = Locale(identifier: "en_US")
    let timeStamp = dateFormatter.string(from: date!)
    return timeStamp
}

func ndDateForAgoTime( min : Int)-> (String ){
   // print(Date())
    let date = Date().addingTimeInterval(TimeInterval(60*min))
   // print(date)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat =  "hh:mm a"
    dateFormatter.timeZone = NSTimeZone.local
    
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter.locale = Locale(identifier: langCode)
    }
       let schStart = dateFormatter.string(from: date)
   
    return (schStart )
}

func getSchuStartAndEndDateForAgoTimeAfterDay(Hrs: Int , min : Int , diffOfHr : Int , diffOfMin : Int)-> (String , String){
   // print(Date())
    let today = NSDate() as Date+1
    let date = Calendar.current.date(byAdding: .day, value: 1, to: today as Date)
   // let date = Date().addingTimeInterval(TimeInterval(3600*Hrs + 60*min))
   // print(date)
    let dateFormatter = DateFormatter()
    
    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
        if enableCustomForm == "0"{
            dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        }else{
           dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" //"dd-MM-yyyy h:mm a"
        }
    }
    
   
    dateFormatter.timeZone = NSTimeZone.local
    
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter.locale = Locale(identifier: langCode)
    }
    
    let schStart = dateFormatter.string(from: date!)
    
    
    let date1 = date!.addingTimeInterval(TimeInterval(3600*diffOfHr + 60*diffOfMin))
    let dateFormatter1 = DateFormatter()
    
    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
        if enableCustomForm == "0"{
            dateFormatter1.dateFormat = "dd-MM-yyyy h:mm a"
        }else{
           dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm" //"dd-MM-yyyy h:mm a"
        }
    }
    
    //dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm"//"dd-MM-yyyy h:mm a"
    dateFormatter1.timeZone = NSTimeZone.local
   // dateFormatter1.locale = Locale(identifier: "en_US")
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter1.locale = Locale(identifier: langCode)
    }
    let schEndDate = dateFormatter1.string(from: date1)
    return (schStart , schEndDate)
}


func getSchuStartAndEndDateForAgoTime(Hrs: Int , min : Int , diffOfHr : Int , diffOfMin : Int)-> (String , String){
   // print(Date())
    let date = Date().addingTimeInterval(TimeInterval(3600*Hrs + 60*min))
   // print(date)
    let dateFormatter = DateFormatter()
    
    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
        if enableCustomForm == "0"{
            dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        }else{
           dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        }
    }
    
   
    dateFormatter.timeZone = NSTimeZone.local
    
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter.locale = Locale(identifier: langCode)
    }
    //=====================================================converttimezone
//    var converTimeZoneschStart = ""
//
//    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
//        if isAutoTimeZone == "1"{
//            converTimeZoneschStart = dateFormatter.string(from: date)
//        }else{
//            let timeZoneDemo11 = dateFormatter.string(from: date)
//            converTimeZoneschStart = createDateTimeDemo(timestamp: timeZoneDemo11, dateFormate: dateFormatter.dateFormat) ?? ""
//        }
//    }
    //=====================================================converttimezone
    
    
    let schStart = dateFormatter.string(from: date)//converTimeZoneschStart
    
    
    let date1 = date.addingTimeInterval(TimeInterval(3600*diffOfHr + 60*diffOfMin))
    let dateFormatter1 = DateFormatter()
    
    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
        if enableCustomForm == "0"{
            dateFormatter1.dateFormat = "dd-MM-yyyy h:mm a"
        }else{
           dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm"
        }
    }
    
   
    dateFormatter1.timeZone = NSTimeZone.local
   // dateFormatter1.locale = Locale(identifier: "en_US")
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter1.locale = Locale(identifier: langCode)
    }
    //=====================================================converttimezone
//    var converTimeZoneschEndDate = ""
//
//    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
//        if isAutoTimeZone == "1"{
//            converTimeZoneschEndDate = dateFormatter1.string(from: date1)
//        }else{
//            let timeZoneDemo11 = dateFormatter1.string(from: date1)
//            converTimeZoneschEndDate = convertTimeZoneForAllDateTime(dateStr: timeZoneDemo11, dateFormate: dateFormatter1.dateFormat) ?? ""
//        }
//    }
    //=====================================================converttimezone
    
   // let schEndDate = converTimeZoneschEndDate
    let schEndDate = dateFormatter1.string(from: date1)
    return (schStart , schEndDate)
}

func getSchuStartAndEndDateForAgoTime24(Hrs: Int , min : Int , diffOfHr : Int , diffOfMin : Int)-> (String , String){
   // print(Date())
    let date = Date().addingTimeInterval(TimeInterval(3600*Hrs + 60*min))
   // print(date)
    let dateFormatter = DateFormatter()
    
    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
        if enableCustomForm == "0"{
            dateFormatter.dateFormat = "HH:mm"
        }else{
           dateFormatter.dateFormat = "HH:mm"//"dd-MM-yyyy h:mm a"
        }
    }
    
   
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            dateFormatter.timeZone = NSTimeZone.local
        }else{
           
            let loginUsrTz = getDefaultSettings()?.loginUsrTz
            dateFormatter.timeZone = TimeZone(identifier: loginUsrTz ?? "")
           
        }
    }
    
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter.locale = Locale(identifier: langCode)
    }
    
    let schStart = dateFormatter.string(from: date)
    
    
    let date1 = date.addingTimeInterval(TimeInterval(3600*diffOfHr + 60*diffOfMin))
    let dateFormatter1 = DateFormatter()
    
    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
        if enableCustomForm == "0"{
            dateFormatter1.dateFormat = "HH:mm"
        }else{
           dateFormatter1.dateFormat = "HH:mm" //"dd-MM-yyyy h:mm a"
        }
    }
    
    //dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm"//"dd-MM-yyyy h:mm a"
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            dateFormatter.timeZone = NSTimeZone.local
        }else{
           
            let loginUsrTz = getDefaultSettings()?.loginUsrTz
            dateFormatter.timeZone = TimeZone(identifier: loginUsrTz ?? "")
           
        }
    }
   // dateFormatter1.locale = Locale(identifier: "en_US")
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter1.locale = Locale(identifier: langCode)
    }
    
    let schEndDate = dateFormatter1.string(from: date1)
    return (schStart , schEndDate)
}


func getSchStartandEndDateAndTimeForSchDate( timeInterval : String, diffOfHr : Int , diffOfMin : Int) -> (String , String){
    


    let currentDate = Date()
    let dateFormatter2 = DateFormatter()
    dateFormatter2.dateFormat = "dd-MM-yyyy"
    dateFormatter2.timeZone = NSTimeZone.local
    let strDate1 = dateFormatter2.string(from: currentDate as Date)
    let dateArr = strDate1.components(separatedBy: "-") // get current date


    let date = NSDate(timeIntervalSince1970: (Double(timeInterval)!))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH-mm"
    let strDate  = dateFormatter.string(from: date as Date)
    let timeArr = strDate.components(separatedBy: "-") // get time from server timestamp

       var dateComponents = DateComponents()
       dateComponents.year = Int(dateArr[2])
       dateComponents.month = Int(dateArr[1])
       dateComponents.day = Int(dateArr[0])
       dateComponents.minute = Int(timeArr[1])
       dateComponents.hour = Int(timeArr[0])


    var calender = Calendar.current
    calender.timeZone = NSTimeZone.local
    let finalDate = calender.date(from:dateComponents)
    
    let dateFormatter3 = DateFormatter()
    dateFormatter3.dateFormat = "dd-MM-yyyy h:mm a"
    dateFormatter3.timeZone = NSTimeZone.local
    dateFormatter3.locale = Locale(identifier: "en_US")
    let schStartDate = dateFormatter3.string(from: finalDate!)

    
    let date1 = finalDate!.addingTimeInterval(TimeInterval(3600*diffOfHr + 60*diffOfMin))
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "dd-MM-yyyy h:mm a"
    dateFormatter1.timeZone = NSTimeZone.local
    dateFormatter1.locale = Locale(identifier: "en_US")
    let schEndDate = dateFormatter1.string(from: date1 as Date)
    
    return (schStartDate , schEndDate)
}

func getCurrentTimeStamp() -> String {
    let timeStamp = NSDate().timeIntervalSince1970
    let strTimeStamp = Int(timeStamp)
    return String(strTimeStamp)
}


let reachability = try! Reachability()
var isNetwork = Bool()
 //===========================
 // MARK:- Network Monitoring
 //===========================
     func StartNetworkMonitoring() -> Void {
        
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                isNetwork = true

                if UserDefaults.standard.bool(forKey: "login"){
                     DatabaseClass.shared.syncDatabase()
                }
                
                if reachability.connection == .wifi {
                  //  print("Reachable via WiFi")
                } else {
                  //  print("Reachable via Cellular")
                }
            }
         }
       
        reachability.whenUnreachable = { reachability in

            DispatchQueue.main.async {
                isNetwork = false
               // print("Not reachable")
            }
        }
     
        do {
            try reachability.startNotifier()
        } catch {
           // print("Unable to start notifier")
        }
     }
     
     func StopNetowrkMonitoring() -> Void {
          reachability.stopNotifier()
     }
     
     
     func isHaveNetowork() -> Bool {
          return isNetwork
     }


func setUserData (userData : [String : Any]){
    let userDefaults = UserDefaults.standard
    userDefaults.setValue(userData, forKey: "userDetails")
    userDefaults.synchronize() // don't forget this!!!!
}


func getUserData() -> [String : Any]{
    let userDefaults = UserDefaults.standard
    return userDefaults.value(forKey: "userDetails") as! [String : Any]
}




//====================
//MARK:- Show Alert
//====================
func ShowAlert(title:String? , message:String?,controller:UIViewController, cancelButton:NSString?, okButton:NSString?, style:UIAlertController.Style, callback:@escaping(Bool, Bool) -> Void){
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title:title, message:message, preferredStyle: style)
            
            
            //Tap on Cancel button
            if (cancelButton != nil) {
                alert.addAction(UIAlertAction(title:cancelButton! as String, style: UIAlertAction.Style.cancel, handler:{ action in
                    callback(true,false)
                }))
            }
            
            //Tap on Ok button
            if (okButton != nil) {
                alert.addAction(UIAlertAction(title:okButton! as String, style: UIAlertAction.Style.default, handler: { action in
                    callback(false,true)
                }))
            }
            controller.present(alert, animated: true, completion: nil)
        }
    }


func ShowError(message:String, controller:UIViewController) -> Void {
    ShowAlert(title: nil, message: message, controller: controller, cancelButton: LanguageKey.ok as NSString, okButton:nil,style:UIAlertController.Style.alert, callback:{_ ,_  in})
    //killLoader()
}


//====================
//MARK:- Loader
//====================
var loader_View : LoaderView?
import NVActivityIndicatorView
func showLoader(){
    
    
    
    DispatchQueue.main.async {
        if (loader_View == nil) {
            loader_View = LoaderView.instanceFromNib() as? LoaderView
            loader_View!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
       loader_View!.hudView.startAnimating()
       showLoaderWithAnimation()
       windowController.topMostViewController().view.addSubview(loader_View!)
    }
}

func showLoaderOnWindow(){
    
    if (loader_View == nil) {
        loader_View = LoaderView.instanceFromNib() as? LoaderView
        loader_View!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    loader_View!.hudView.startAnimating()
    showLoaderWithAnimation()
    windowController.view.addSubview(loader_View!)
    
}


func killLoader(){
    if(loader_View != nil){
        DispatchQueue.main.async {
           killLoaderWithAnimation()
        }
    }
}


fileprivate func showLoaderWithAnimation(){
    
    if loader_View != nil{
        loader_View!.isHidden=false;
        loader_View!.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    

    //view.alpha = 0.0
    
    UIView.animate(withDuration: 0.1,
                   delay: 0.1,
                   options: UIView.AnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    
                    if loader_View != nil{
                        loader_View!.transform = CGAffineTransform(scaleX:1, y: 1)
                    }
                   
                    
    }, completion: { (finished) -> Void in
        // ....
    })
}

fileprivate func killLoaderWithAnimation(){
    UIView.animate(withDuration: 0.1,
                   delay: 0.1,
                   options: UIView.AnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                  
                    if loader_View != nil{
                        loader_View!.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                    
    }, completion: { (finished : Bool) -> Void in
        if(finished){
            
                        if loader_View != nil{
                            //loader_View!.hudView.removeFromSuperview()
                            loader_View!.removeFromSuperview()
                           // loader_View!.hudView = nil
                             loader_View = nil
                        }
            
        }
    })
}

//=======================
//MARK:- Email Validation
//=======================
func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with:testStr)
}


//==========================
//MARK:- Password Validation
//==========================
func isValidPassword(_ password : String) -> Bool{
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
    return passwordTest.evaluate(with: password)
}


//==========================
//MARK:- PhoneNumber Validation
//==========================
func isValidPhoneNumber(_ PhoneNumber : String) -> Bool{
    let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: PhoneNumber)
    return result
}


//==========================
//MARK:- UserName Validation
//==========================
func isValidUsername(Input:String) -> Bool {
    let RegEx = "\\A\\w{4,12}\\z"
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return Test.evaluate(with: Input)
}


//========================
//MARK:- Window Controller
//========================

   let windowController = (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController)


//====================
//MARK:- Add Shadow
//====================
func dropShadow(view : UIView,color: UIColor, opacity: Float, offSet: CGSize, shadowRadius: CGFloat,round :Bool) {
    view.layer.cornerRadius = view.bounds.width/2
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOpacity = opacity
    view.layer.shadowRadius = shadowRadius
    view.layer.shadowOffset = offSet
    view.layer.masksToBounds = false
}

//======================================================
//MARK:- Convert TimeZone For All DateTime Formate :- 
//======================================================

func convertTimeZoneForAllDateTime(dateStr: String ,dateFormate: String) -> String? {
    var strDate = ""
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormate
    dateFormatter.calendar = Calendar.current
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale(identifier: "en_US")
    if let date = dateFormatter.date(from: dateStr) {
        let loginUsrTz = getDefaultSettings()?.loginUsrTz
        dateFormatter.timeZone = TimeZone(identifier: loginUsrTz ?? "")
        strDate =  dateFormatter.string(from: date)
    }
    return strDate
}

func createDateTimeDemo(timestamp: String ,dateFormate: String) -> String? {

    var strDate = ""
        
    if let unixTime = Double(timestamp) {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        let loginUsrTz = getDefaultSettings()?.loginUsrTz
        dateFormatter.timeZone = TimeZone(identifier: loginUsrTz ?? "")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = dateFormate
        strDate = dateFormatter.string(from: date)
    }
        
    return strDate
}

func createDateTimeForCustomFieldamdForm(timestamp: String ,dateFormate: String) -> String? {
    
    var strDate = ""
    
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            if let unixTime = Double(timestamp) {
                let date = Date(timeIntervalSince1970: unixTime)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateFormate
                dateFormatter.locale = Locale(identifier: "en_US")
                strDate = dateFormatter.string(from: date as Date)
                
            }
            
        }else{
            if let unixTime = Double(timestamp) {
                let date = Date(timeIntervalSince1970: unixTime)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateFormate
                let loginUsrTz = getDefaultSettings()?.loginUsrTz
                dateFormatter.timeZone = TimeZone(identifier: loginUsrTz ?? "")
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = dateFormate
                strDate = dateFormatter.string(from: date)
            }
            
        }
    }
    
    return strDate
}

func createDateTimeForCustomFieldamdFormDraft(timestamp: String ,dateFormate: String) -> String? {
    var strDate = ""
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            if let unixTime = Double(timestamp) {
                let date = Date(timeIntervalSince1970: unixTime)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateFormate
                dateFormatter.locale = Locale(identifier: "en_US")
                strDate = dateFormatter.string(from: date as Date)
            }
        } else {
            if let unixTime = Double(timestamp) {
                let date = Date(timeIntervalSince1970: unixTime)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateFormate
                let loginUsrTz = getDefaultSettings()?.loginUsrTz
                dateFormatter.timeZone = TimeZone(identifier: loginUsrTz ?? "")
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = dateFormate
                strDate = dateFormatter.string(from: date)
            }
        }
    }
    
    if strDate == "" {
        strDate = timestamp
    }
    return strDate
}

func createDateTimeForCheckInandOut(timestamp: String) -> String? {
    
    var strDate = ""
    
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            if let unixTime = Double(timestamp) {
                let date = Date(timeIntervalSince1970: unixTime)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
                dateFormatter.locale = Locale(identifier: "en_US")
                strDate = dateFormatter.string(from: date)
                
            }
            
        }else{
            if let unixTime = Double(timestamp) {
                let date = Date(timeIntervalSince1970: unixTime)
                let dateFormatter = DateFormatter()
                let loginUsrTz = getDefaultSettings()?.loginUsrTz
                dateFormatter.timeZone = TimeZone(identifier: loginUsrTz ?? "")
                dateFormatter.locale = Locale(identifier: "en_US")
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
                strDate = dateFormatter.string(from: date)
            }
        }
    }
    
    return strDate
}

func CheckInandOutCurrentTime(timestamp: Date) -> String? {
    var strDate = ""
    let date = timestamp

    //=====================================================converttimezone
    var timeZoneDemo1 = ""
    
    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
            dateFormatter.locale = Locale(identifier: "en_US")
            strDate = dateFormatter.string(from: date)
        }else{
            let dateFormatter = DateFormatter()
            let loginUsrTz = getDefaultSettings()?.loginUsrTz
            dateFormatter.timeZone = TimeZone(identifier: loginUsrTz ?? "")
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
            strDate = dateFormatter.string(from: date)
           
        }
    }
    
    return strDate
}



func getSchuStartAndEndDateForAgoTimeDemo(Hrs: Int , min : Int , diffOfHr : Int , diffOfMin : Int)-> (String , String){
   
    let date = Date().addingTimeInterval(TimeInterval(3600*Hrs + 60*min))
  
    let dateFormatter = DateFormatter()
    
    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
        if enableCustomForm == "0"{
            dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        }else{
           dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        }
    }
    
   
    dateFormatter.timeZone = NSTimeZone.local
    
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter.locale = Locale(identifier: langCode)
    }
    //=====================================================converttimezone
    var converTimeZoneschStart = ""

    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            converTimeZoneschStart = dateFormatter.string(from: date)
        }else{
            let timeZoneDemo11 = dateFormatter.string(from: date)
            converTimeZoneschStart = convertTimeZoneForAllDateTime(dateStr: timeZoneDemo11, dateFormate: dateFormatter.dateFormat) ?? ""
        }
    }
    //=====================================================converttimezone
    
    
    let schStart = converTimeZoneschStart//dateFormatter.string(from: date)//converTimeZoneschStart
    
    
    let date1 = date.addingTimeInterval(TimeInterval(3600*diffOfHr + 60*diffOfMin))
    let dateFormatter1 = DateFormatter()
    
    if let enableCustomForm = getDefaultSettings()?.is24hrFormatEnable{ //This is round off digit for invoice
        if enableCustomForm == "0"{
            dateFormatter1.dateFormat = "dd-MM-yyyy h:mm a"
        }else{
           dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm"
        }
    }
    
   
    dateFormatter1.timeZone = NSTimeZone.local
   
    if let langCode = getCurrentSelectedLanguageCode() {
        dateFormatter1.locale = Locale(identifier: langCode)
    }
    //=====================================================converttimezone
    var converTimeZoneschEndDate = ""

    if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            converTimeZoneschEndDate = dateFormatter1.string(from: date1)
        }else{
            let timeZoneDemo11 = dateFormatter1.string(from: date1)
            converTimeZoneschEndDate = convertTimeZoneForAllDateTime(dateStr: timeZoneDemo11, dateFormate: dateFormatter1.dateFormat) ?? ""
        }
    }
    //=====================================================converttimezone
   
    let schEndDate = converTimeZoneschEndDate
    return (schStart , schEndDate)
}

//======================================================
//MARK:- getCurrentTimeZone :-
//======================================================
func getCurrentTimeZone() -> String {
    TimeZone.current.identifier
}
