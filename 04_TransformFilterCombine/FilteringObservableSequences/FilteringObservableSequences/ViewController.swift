//
//  ViewController.swift
//  FilteringObservableSequences
//
//  Created by Tim Beals on 2018-08-17.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blue
        
        example(of: "Filtering") {
            
            let disposeBag = DisposeBag()
            
            let numbers = Observable.generate(initialState: 1,
                                              condition: { $0 < 101 },
                                              iterate: { $0 + 1 })

            numbers
            .filter() { $0.isPrime() } //filters
            .toArray() //assigns all of the elements to a single array (emits one next event)
            .subscribe(onNext: {
                print("sub1 onNext: \($0)") //
                }).disposed(by: disposeBag)
            
//            numbers.subscribe(onNext: {
//                print("sub2 onNext: \($0)")
//            }).disposed(by: disposeBag)
        }
        
        
        example(of: "Distinct Until Changed") {
            
            let disposeBag = DisposeBag()
            
            let searchString = Variable("")
            
            searchString.asObservable()
                .map() { $0.lowercased() }
                .distinctUntilChanged()
                .subscribe {
                    print($0)
                }
                .disposed(by: disposeBag)
            
            searchString.value = "apple"
            searchString.value = "APPLE" //not accepted through the filter
            searchString.value = "banana"
            searchString.value = "apple" //is accepted through the filter
            
        }
        
        example(of: "TakeWhile") {
            let disposeBag = DisposeBag()
            
            let numbers = Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
            
            numbers
                .takeWhile() { $0 < 5 }
                .toArray()
                .subscribe() { print($0) }
                .disposed(by: disposeBag)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

