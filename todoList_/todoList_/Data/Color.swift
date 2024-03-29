//
//  Color.swift
//  todoList_
//
//  Created by 배지해 on 3/25/24.
//

import Foundation
import UIKit

enum Color: Int {
    case color0  = 0
    case color1  = 1
    case color2  = 2
    case color3  = 3
    case color4  = 4
    case color5  = 5
    case color6  = 6
    case color7  = 7
    case color8  = 8
    case color9  = 9
    case color10 = 10
    case color11 = 11
    
    var backgoundColor: UIColor {
        switch self {
        case .color0:
            return UIColor(red: 203/255, green: 190/255, blue: 184/255, alpha: 0.8)
        case .color1:
            return UIColor(red: 222/255, green: 221/255, blue: 215/255, alpha: 0.8)
        case .color2:
            return UIColor(red: 229/255, green: 222/255, blue: 213/255, alpha: 0.8)
        case .color3:
            return UIColor(red: 232/255, green: 222/255, blue: 223/255, alpha: 0.8)
        case .color4:
            return UIColor(red: 216/255, green: 212/255, blue: 204/255, alpha: 0.8)
        case .color5:
            return UIColor(red: 209/255, green: 206/255, blue: 197/255, alpha: 0.8)
        case .color6:
            return UIColor(red: 234/255, green: 232/255, blue: 225/255, alpha: 0.8)
        case .color7:
            return UIColor(red: 197/255, green: 202/255, blue: 197/255, alpha: 0.8)
        case .color8:
            return UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 0.8)
        case .color9:
            return UIColor(red: 226/255, green: 220/255, blue: 208/255, alpha: 0.8)
        case .color10:
            return UIColor(red: 202/255, green: 206/255, blue: 207/255, alpha: 0.8)
        case .color11:
            return UIColor(red: 204/255, green: 201/255, blue: 198/255, alpha: 0.8)
        }
    }
    
    var description: String {
        switch self {
        case .color0:
            return "Daily"
        case .color1:
            return "Study"
        case .color2:
            return "Work"
        case .color3:
            return "Meeting"
        case .color4:
            return "Cooking"
        case .color5:
            return "Health"
        case .color6:
            return "Gift"
        case .color7:
            return "Ideas"
        case .color8:
            return "Payment"
        case .color9:
            return "Shopping"
        case .color10:
            return "Medical"
        case .color11:
            return "Miscellaneous"
        }
    }
    
    var icon: String {
        switch self {
        case .color0:
            return "house"
        case .color1:
            return "text.book.closed"
        case .color2:
            return "building.2"
        case .color3:
            return "calendar"
        case .color4:
            return "carrot"
        case .color5:
            return "dumbbell"
        case .color6:
            return "gift"
        case .color7:
            return "lightbulb.max"
        case .color8:
            return "dollarsign.circle"
        case .color9:
            return "cart"
        case .color10:
            return "cross.case"
        case .color11:
            return "pencil.and.scribble"
        }
    }
}
