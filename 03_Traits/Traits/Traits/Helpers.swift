//
//  Helperss.swift
//  Traits
//
//  Created by Tim Beals on 2018-08-07.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

func example(of title: String, subject: @escaping () -> Swift.Void ) {
    print("---Example of \(title) ---")
    subject()
}
