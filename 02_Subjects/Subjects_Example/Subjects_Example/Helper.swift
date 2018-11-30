//
//  Helper.swift
//  Subjects_Example
//
//  Created by Tim Beals on 2018-07-21.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

enum MyError: Error {
    case error1
    case error2
    case error3
}


func example(of name: String,  event: @escaping () -> ()) {
    print("--- An example of: \(name) ---")
    event()
}
