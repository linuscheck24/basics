//
//  UIViewExt.swift
//  basics
//
//  Created by Linus Widing on 06.10.24.
//

import UIKit

extension UIView{
    func pin(to superView: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
    
    func addToSafeArea(to superView: UIView, padding: CGFloat = 0){
        superView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            self.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: padding)
        ])
        
    }
}
