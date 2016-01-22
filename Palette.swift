//
//  Palette.swift
//  VirtualCall
//
//  Created by zeng yukai on 10/15/15.
//  Copyright © 2015 Snapfit. All rights reserved.
//

import UIKit

func ColorFromRGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor{
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}



struct Palette {
    struct Color {
        static let pickerInnerBlue = ColorFromRGBA(98, g: 104, b: 246, a: 0.2)
        static func whiteWithAlpha(a: CGFloat)->UIColor {
            return UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: a)
        }
    }
    
    struct Font {
        
        // for code completion suggestion
        static let commonFontName = "HelveticaNeue"
        static let commonLight = "HelveticaNeue-Light"
        static let commonBold = "HelveticaNeue-Bold"
        
        static let chineseFont = UIFont.systemFontOfSize(15)
    }
    
    struct Style {
//        static let navigationTitle = [NSForegroundColorAttributeName: Color.green1, NSFontAttributeName: Font.systemFont]
    }
}

