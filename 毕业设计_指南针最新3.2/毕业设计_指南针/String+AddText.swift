//
//  String+AddText.swift
//  MyLocations
//
//  Created by Lxrent46 on 15/9/22.
//  Copyright © 2015年 zhihong. All rights reserved.
//

import Foundation

extension String {
    mutating func addText(text: String?, withseparator separator: String = " ") {
        
        if text != nil {
            if !self.isEmpty {
                self += separator
            }
            self += text!
        }
        
    }
}