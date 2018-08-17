//
//  Helpers.swift
//  FilteringObservableSequences
//
//  Created by Tim Beals on 2018-08-17.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

func example(of example: String, execution: @escaping () -> ()) {
    print("--- Example of \(example) ---")
    execution()
}


extension Int {
    
    func isPrime() -> Bool {
        guard self > 1 else { return false }
        
        var isPrime = true
        
        for number in (2..<self) {
            if self % number == 0 {
                isPrime = false
                break
            }
        }
        return isPrime
    }
    
}
