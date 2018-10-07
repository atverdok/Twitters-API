//
//  Tweet.swift
//  d04
//
//  Created by Aleksey Tverdokhleb on 10/7/18.
//  Copyright © 2018 Aleksey Tverdokhleb. All rights reserved.
//

import Foundation

struct Tweet : CustomStringConvertible {
    
    let name : String
    let date : String
    let text : String
    var description: String {
        return "(name: \(name),  date: \(date), text: \(text))"
    }
}
