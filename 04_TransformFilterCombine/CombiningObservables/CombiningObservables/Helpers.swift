//
//  Helpers.swift
//  CombiningObservables
//
//  Created by Tim Beals on 2018-08-17.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation


func example(of example: String, action: @escaping () -> ()) {
    print("--- \(example) ---")
    action()
}
