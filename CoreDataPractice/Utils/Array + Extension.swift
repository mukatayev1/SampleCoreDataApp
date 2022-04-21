//
//  Array + Extension.swift
//  CoreDataPractice
//
//  Created by Aidos Mukatayev on 2022/04/21.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
