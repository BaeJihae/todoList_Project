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
            return UIColor(red: 234/255, green: 125/255, blue: 112/255, alpha: 1.0)
        case .oldCountry:
            return UIColor(red: 255/255, green: 175/255, blue: 110/255, alpha: 1.0)
        case .hibiscus:
            return UIColor(red: 255/255, green: 204/255, blue: 128/255, alpha: 1.0)
        case .calamine:
            return UIColor(red: 188/255, green: 192/255, blue: 123/255, alpha: 1.0)
        case .watery:
            return UIColor(red: 171/255, green: 205/255, blue: 222/255, alpha: 1.0)
        case .breezy:
            return UIColor(red: 213/255, green: 237/255, blue: 248/255, alpha: 1.0)
        case .oceanAir:
            return UIColor(red: 213/255, green: 226/255, blue: 211/255, alpha: 1.0)
        case .polarWhite:
            return UIColor(red: 154/255, green: 129/255, blue: 176/255, alpha: 1.0)
        case .teresaGreen:
            return UIColor(red: 142/255, green: 113/255, blue: 91/255, alpha: 1.0)
        case .bathSalts:
            return UIColor(red: 201/255, green: 169/255, blue: 141/255, alpha: 1.0)
        case .wytheBlue:
            return UIColor(red: 255/255, green: 169/255, blue: 186/255, alpha: 1.0)
        case .seaFoam:
            return UIColor(red: 241/255, green: 236/255, blue: 234/255, alpha: 1.0)
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
