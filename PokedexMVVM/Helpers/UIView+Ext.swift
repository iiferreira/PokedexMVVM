
//
//  UIView+Ext.swift
//  PokdexMVVM
//
//  Created by Iuri Ferreira on 5/29/25.
//

import UIKit

extension UIViewController {
    func convertReturnedColorToBackGroundColor(color:String) -> UIColor? {
            switch color.lowercased() {
            case "red": return UIColor(red: 0.45, green: 0, blue: 0, alpha: 1.0)
            case "blue": return UIColor(red: 0, green: 0, blue: 0.45, alpha: 1.0)
            case "green": return UIColor(red: 0, green: 0.45, blue: 0, alpha: 1.0)
            case "yellow": return UIColor(red: 1, green: 0.8, blue: 0.5, alpha: 1.0)
            case "purple": return .purple
            case "brown" : return .brown
            case "pink" : return .systemPink
            case "cyan" : return .cyan
            case "orange": return .orange
            case "black": return .black
            case "white": return .systemGray2
            case "gray": return .gray
            default: return .black
        }
    }
}
