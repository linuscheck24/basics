//
//  UIUtil.swift
//  basics
//
//  Created by Linus Widing on 07.10.24.
//

import UIKit

class UIUtil{
    static func getAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}
