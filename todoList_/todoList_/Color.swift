//
//  Color.swift
//  todoList_
//
//  Created by 배지해 on 3/25/24.
//

import Foundation
import UIKit

enum Color: Int {
    case coralPink   = 0
    case oldCountry  = 1
    case hibiscus    = 2
    case calamine    = 3
    case watery      = 4
    case breezy      = 5
    case oceanAir    = 6
    case polarWhite  = 7
    case teresaGreen = 8
    case bathSalts   = 9
    case wytheBlue   = 10
    case seaFoam     = 11
    
    var backgoundColor: UIColor {
        switch self {
        case .coralPink:
            return UIColor(red: 205/255, green: 156/255, blue: 148/255, alpha: 1)
        case .oldCountry:
            return UIColor(red: 238/255, green: 216/255, blue: 202/255, alpha: 1)
        case .hibiscus:
            return UIColor(red: 224/255, green: 209/255, blue: 202/255, alpha: 1)
        case .calamine:
            return UIColor(red: 227/255, green: 221/255, blue: 220/255, alpha: 1)
        case .watery:
            return UIColor(red: 178/255, green: 193/255, blue: 193/255, alpha: 1)
        case .breezy:
            return UIColor(red: 168/255, green: 175/255, blue: 181/255, alpha: 1)
        case .oceanAir:
            return UIColor(red: 227/255, green: 236/255, blue: 230/255, alpha: 1)
        case .polarWhite:
            return UIColor(red: 222/255, green: 226/255, blue: 230/255, alpha: 1)
        case .teresaGreen:
            return UIColor(red: 187/255, green: 199/255, blue: 182/255, alpha: 1)
        case .bathSalts:
            return UIColor(red: 217/255, green: 226/255, blue: 212/255, alpha: 1)
        case .wytheBlue:
            return UIColor(red: 135/255, green: 152/255, blue: 143/255, alpha: 1)
        case .seaFoam:
            return UIColor(red: 216/255, green: 221/255, blue: 217/255, alpha: 1)
        }
    }
    
    var description: String {
        switch self {
        case .coralPink:
            return "Daily"
        case .oldCountry:
            return "Study"
        case .hibiscus:
            return "Fitness"
        case .calamine:
            return "Finance"
        case .watery:
            return "Home"
        case .breezy:
            return "Work"
        case .oceanAir:
            return "Hobbies"
        case .polarWhite:
            return "Travel"
        case .teresaGreen:
            return "Education"
        case .bathSalts:
            return "Social"
        case .wytheBlue:
            return "Family"
        case .seaFoam:
            return "Miscellaneous"
        }
    }
}
