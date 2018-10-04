//
//  ViewController.swift
//  CombiningObservables
//
//  Created by Tim Beals on 2018-08-17.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.green

        example(of: "startWith") {
            
            let disposeBag = DisposeBag()
            
            Observable.of("A", "B", "C")
            .startWith("1")
            .startWith("2")
            .startWith("3", "4")
                .subscribe() {
                    print($0)
            }
            .disposed(by: disposeBag)
            //3, 4, 2, 1, A, B, C, completed
            
        }
        
        example(of: "merge") {
            
            let db = DisposeBag()
            
            let pub1 = PublishSubject<String>()
            
            let pub2 = PublishSubject<String>()
            
            Observable.of(pub1, pub2) //element type must be the same
            .merge()
                .subscribe() {
                    print($0)
            }
            .disposed(by: db)
            
            pub1.onNext("A")
            
            pub2.onNext("B")
            
            pub2.onNext("C")
            
            pub1.onNext("D")
        }
        
        example(of: "zip") {
        
            let db = DisposeBag()
            
            let pubInt = PublishSubject<Int>()
            
            let pubString = PublishSubject<String>()

            //note that zip can have up to 8 sequences feeding into it.
            //The observable will wait until all of the parameters in zip are satisfied before sending a next event.
            
            Observable.zip(pubInt, pubString) { int, string in
                "\(int)\(string)"
                }
                .subscribe() {
                    print($0)
            }
                .disposed(by: db)
            
            pubInt.onNext(1)
            pubInt.onNext(2)
            pubString.onNext("A")
            pubString.onNext("B")
            pubString.onNext("C")
            //1A, 2B
            //note that "C" is not printed because there is no third Int to satisfy the .zip
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

