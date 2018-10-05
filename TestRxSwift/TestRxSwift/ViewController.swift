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
        
        
        //Just: single element
        example(of: "just") {
            //just is an 'operator' in
            //(option click) returns an observable sequence with a single element of String type
            let observable = Observable.just("Hello world")
            //Now you can subscribe to events being emitted by the observable sequence and print the results
            //Event is an enum representation of a sequence event (next, error, completed)
            //Note that Event and observable types are the same. Observable<String> emits Event<String>
            
            let disposable = observable.subscribe({ (event: Event<String>) in
                print(event)
            })
            
            disposable.dispose()
        }
        
        //of: elements
        example(of: "of") {
            let observable = Observable.of("Tim", "Tara", "Silas", "Ruby")
            let subscription = observable.subscribe({
                print($0)
            })
            
            subscription.dispose()
        }
        
        
        //Disposing a subscription will cause the underlying sequence to emit a completed event and terminate
        //You need to manually terminate your sequences otherwise you risk leaking memory. In previous examples I have called dispose on the subscriptions individually.
        //The more common approach is to create a container called a 'dispose bag' which holds reference to the subscriptions and disposes of them all when it is deinitialized.
        
        
        //from: a collection
        //This time I am chaining the creation of the observable to a subscribe call
        example(of: "from") {
            
            let disposeBag = DisposeBag()
            
            let subscription = Observable.from([1, 2, 3, 4, 5])
            .subscribe({
                print($0)
            })
            
              //adds the sub to the dispose bag
        } // deinits the dispose bag as the scope ends
        
        
        //subscribe on next: Passes the element as opposed to the event
        //Only next events are processed. Completed event is ignored.
        example(of: "subscribe on next") {
            
            let disposeBag = DisposeBag()
            
            let numbers = Observable.from([6, 7, 8, 9, 10]) // returns observable
                numbers.subscribe(onNext: { print($0) },
                           onError: { print($0.localizedDescription)},
                           onCompleted: { print("sequence has completed") },
                           onDisposed: { print("subscription disposed") }) //returns disposable
                
                .disposed(by: disposeBag)
            
            
        }
        
        example(of: "error") {
            
            enum MyError: Error {
                case test
            }
            
            let db = DisposeBag()
            
            Observable<Void>.error(MyError.test)
                .subscribe(onError: { print("Error: \($0)") })
                .disposed(by: db)
        }
        
        //Performing side-effects: You can listen to but not effect the values in the events
        
        var squaredVals = [Int]()
        
        let db = DisposeBag()
        
        let fahrenheitTemps = PublishSubject<Int>()
        fahrenheitTemps
            .do(onNext: { print("do1 next: ", squaredVals.append($0 * $0)) }) //Notice that do is escaping!
            .do(onNext: { print("do2 next: ", "\($0)℉") })
            .map { Double($0 - 32) * 5/9.0 }
            .do(onError: { print("do3: Error \($0)")},
                onCompleted: { print("do3 Completed") },
                onSubscribe: { print("do3: Subscribed")},
                onDispose: { print("do3: Disposed")})
            
            .subscribe(onNext: { print("Subscription: ", String(format: "%.1f℃", $0))})
            .disposed(by: db)
        
        fahrenheitTemps.onNext(70)
        
        print("SquaredVals: ", squaredVals)
        
        fahrenheitTemps.onCompleted() //This will dispose of the Observable
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

