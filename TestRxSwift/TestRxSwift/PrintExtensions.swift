//
//  PrintExtensions.swift
//  TestRxSwift
//
//  Created by Tim Beals on 2018-07-09.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

public func example(of description: String, action: () -> Void) {
    print("\n -- Example of: \(description) --")
    action()
}
