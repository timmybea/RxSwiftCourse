//
//  ViewController.swift
//  RxPractice
//
//  Created by Tim Beals on 2018-11-26.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}



enum myErrors: Error {
    case one
    case two
    case three

}

extension myErrors: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .one: return "This is error one description"
        case .two: return "This is error two description"
        case .three: return "This is error three description"
        }
    }
}
