//
//  ScratchView.swift
//  1BiteLess
//
//  Created by z on 6/17/15.
//  Copyright (c) 2015 Basadora. All rights reserved.
//
import UIKit

public enum iPhoneScreenType {
    case iPhone4S, iPhone5S, iPhone6, iPhone6P, Unknown
}

public struct DADevice {
    struct DAiPhone6P {
        static var numberPadHeight: CGFloat = 226
        
        static var portraitWidth: CGFloat = 414
        static var portraitHeight: CGFloat = 736
    }
    
    struct DAiPhone6 {
        static var numberPadHeight: CGFloat = 216
        
        static var portraitWidth: CGFloat = 375
        static var portraitHeight: CGFloat = 667
    }
    
    struct DAiPhone5S {
        static var numberPadHeight: CGFloat = 216
        
        static var portraitWidth: CGFloat = 320
        static var portraitHeight: CGFloat = 568
    }
    
    struct DAiPhone4S {
        static var numberPadHeight: CGFloat = 216
        
        static var portraitWidth: CGFloat = 320
        static var portraitHeight: CGFloat = 480
    }
    
    
    public let scale: CGFloat
    public let aspectRatio: CGFloat
    public let onePixel: CGFloat
    public let portraitWidth: CGFloat
    public let portraitHeight: CGFloat
    public let screenType: iPhoneScreenType
    public let screenBounds: CGRect
    
    let referringScales: CGPoint
    
    public var numberPadHeight: CGFloat {
        switch screenType {
        case .iPhone4S:
            return DAiPhone4S.numberPadHeight
        case .iPhone5S:
            return DAiPhone5S.numberPadHeight
        case .iPhone6:
            return DAiPhone6.numberPadHeight
        case .iPhone6P:
            return DAiPhone6P.numberPadHeight
        default:
            return DAiPhone5S.numberPadHeight
        }
    }
    
    init() {
        scale = UIScreen.mainScreen().scale
        onePixel = 1 / scale
        
        screenBounds = UIScreen.mainScreen().bounds

        portraitWidth = screenBounds.size.width
        portraitHeight = screenBounds.size.height
        
        aspectRatio = portraitWidth / portraitHeight
        referringScales = CGPoint(x: portraitWidth / DAiPhone6.portraitWidth, y: portraitHeight / DAiPhone6.portraitHeight)
        
        switch portraitWidth {
        case DAiPhone6P.portraitWidth:
            screenType = iPhoneScreenType.iPhone6P
        case DAiPhone6.portraitWidth:
            screenType = iPhoneScreenType.iPhone6
        case DAiPhone5S.portraitWidth:
            switch portraitHeight {
            case DAiPhone5S.portraitHeight:
                screenType = iPhoneScreenType.iPhone5S
            case DAiPhone4S.portraitHeight:
                screenType = iPhoneScreenType.iPhone4S
            default:
                screenType = iPhoneScreenType.Unknown
            }
        default:
            screenType = iPhoneScreenType.Unknown
        }
        
    }
    
}

let Device = DADevice() // *let* ensures thread safe
