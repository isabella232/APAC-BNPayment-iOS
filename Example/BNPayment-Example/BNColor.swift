//
//  Created by Max Mattini on 2/08/2016.
//

import Foundation

open class BNColor:NSObject
{
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static public let purple = UIColor.purple
    static public let primary = UIColor(red: 130, green: 71, blue: 181, alpha: 1)
    static public let amethyst = UIColor(red: 69  , green: 39, blue: 89, alpha: 1)
    static public let fadetViolet = UIColor(red: 202, green: 172, blue: 223, alpha: 1)
    static public let mutedLight = UIColor(red: 246, green: 246, blue: 246, alpha: 1)
    static public let muted = UIColor(red: 240, green: 240, blue: 240, alpha: 1)
    static public let mutedDark = UIColor(red: 200, green: 200, blue: 200, alpha: 1)
    
    
}
