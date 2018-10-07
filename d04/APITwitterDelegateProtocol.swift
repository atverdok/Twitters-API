//
//  TwitterDelegate.swift
//  d04
//
//  Created by Aleksey Tverdokhleb on 10/7/18.
//  Copyright © 2018 Aleksey Tverdokhleb. All rights reserved.
//

import Foundation

protocol APITwitterDelegate : class {
    func processTweet(_ tweets : [Tweet])
    func processError(_ error : Error)
}
