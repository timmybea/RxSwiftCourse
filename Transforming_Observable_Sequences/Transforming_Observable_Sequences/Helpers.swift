//
//  Helpers.swift
//  Transforming_Observable_Sequences
//
//  Created by Tim Beals on 2018-08-13.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation


func example(of title: String, example: @escaping () -> ()) {
    print("--- Example of \(title) ---")
    example()
}
