//
//  AppAssets.swift
//  ExpandingCellBlog
//
//  Created by Krešimir Baković on 30/11/2020.
//

import UIKit

enum AppAssets: String {
    case downArrow
    case circleDeselected
    case circleSelected
    case payPal
    case maestro
    case visa
    case aircash
    case bitcoin
    
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
