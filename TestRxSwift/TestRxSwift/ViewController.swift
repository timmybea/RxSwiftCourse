//
//  ViewController.swift
//  TestRxSwift
//
//  Created by Tim Beals on 2018-07-09.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        example(of: "just") {
            let observable = Observable.just("Hello world")
            let _ = observable.subscribe({ (event: Event<String>) in
                print(event)
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

