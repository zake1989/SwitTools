//
//  Common.swift
//  VirtualCall
//
//  Created by zeng yukai on 10/15/15.
//  Copyright © 2015 Snapfit. All rights reserved.
//

import UIKit


class Common: NSObject {

}

func po(obj: Any?) {
//    #if DEBUG
//    if true {
//        print(obj)
//    }
//    #endif
}

func poDB(obj: Any?) {
    //    #if DEBUG
    //        if dbDebug {
//    print(obj)
    //        }
    //    #endif
}

//callTime: String, callFrom: NSDictionary, radioIndex: Int, ringToneIndex: Int, conuinue: Int, wattingIndex: Int
struct CommonSettings {
    static let callTime = "CallTimePeriod"
}

struct Notification {
    static let PickContactNotification = "pickContact"
}

func getCurrentTimeStamp() -> String! {
    return "\(NSDate().timeIntervalSince1970 * 1000)"
}

func LS(key: String, inTable table: String) -> String {
    return NSBundle.mainBundle().localizedStringForKey(key, value: "", table: table)
}

func randRange(lower: Int , upper: Int) -> Int {
    return lower + Int(arc4random_uniform(UInt32(upper - lower)))
}

func removeFileAtUrl(fielURL: NSURL) {
    let fileManager = NSFileManager.defaultManager()
    do{
       try fileManager.removeItemAtURL(fielURL)
    } catch {
        
    }
}

func screenShotOn(view: UIView) -> UIImage {
    //Create the UIImage
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    //Save it to the camera roll
    return image
}

func getTextSize(text:String, font:UIFont)->CGSize {
    let label = UILabel()
    label.font = font
    label.text = text
    label.sizeToFit()
    return CGSizeMake(label.frame.width, label.frame.height)
}

func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
//    if #available(iOS 8.0, *) {
//    QOS_CLASS_USER_INITIATED
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if(background != nil){ background!(); }
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue()) {
                if(completion != nil){ completion!(); }
            }
        }
//    } else {
//        // Fallback on earlier versions
//    }
}

func JSONObjectOrNull(object: Any?, dataFormat: String = "yyyy-MM-dd") -> AnyObject {
    if let obj = object {
        switch obj {
        case let data as NSData:
            if let string = String(data: data, encoding: NSUTF8StringEncoding) {
                return string
            } else {
                return data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
            }
        case let date as NSDate:
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = dataFormat
            return dateFormatter.stringFromDate(date)
        case let n as NSNumber:
            return n
        case let s as NSString:
            return s
        case let s as String:
            return s
        case let a as [AnyObject?]:
            var ta = [AnyObject]()
            for x in a {
                ta.append(JSONObjectOrNull(x))
            }
            return ta
        case let h as [String: Any?]:
            var td = [String: AnyObject]()
            for (k, v) in h {
                td[k] = JSONObjectOrNull(v)
            }
            return td
        default:
            po("Invalid JSON object in JSONObjectOrNull(\(obj)), returning null")
            return NSNull()
        }
    }
    return NSNull()
}

