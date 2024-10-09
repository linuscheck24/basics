//
//  BasicStrings.swift
//  basics
//
//  Created by Linus Widing on 09.10.24.
//

import Foundation

enum BasicStrings: String{
    case deleteTodo
    
    var localized: String{
        NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
    }
}
