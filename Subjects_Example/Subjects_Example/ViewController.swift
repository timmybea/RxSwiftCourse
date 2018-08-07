//
//  ViewController.swift
//  Subjects_Example
//
//  Created by Tim Beals on 2018-07-21.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        example(of: "Publish Subject") { //NO REPLAY. Subscribers only receive new events
            
            let disposeBag = DisposeBag()
            
            let pubSubj = PublishSubject<String>()
            
            pubSubj.on(.next("before subscription")) //event emitted to no subscribers
            
            pubSubj.subscribe({ //subscriber added, no replay sent.
                print("line: \(#line)", "event: \($0)")
            })
            .disposed(by: disposeBag)
            
            pubSubj.on(.next("after subscription")) //event emitted and received by sub
            
//            pubSubj.onCompleted() //emits completed and terminates sequence
            pubSubj.onError(MyError.error1) //emits error and terminates sequence
            
            pubSubj.on(.next("after completed")) //pub cannot emit this event
        }
        
        
        
        example(of: "Behavior Subject") { //SINGLE EVENT REPLAY. At the point of subscribing, the most recent next event will be sent to the new subscription
            
            let dispose = DisposeBag()
            
            let behavSub = BehaviorSubject<String>(value: "Starting value") //BehaviorSubject instantiated with a starting value (single event buffer)
            
            behavSub.subscribe({ (event) in //Sub A added and most recent event replayed ("starting value")
                print("Sub A, line: \(#line)", "event: \(event)")
            })
                .disposed(by: dispose)
            
            behavSub.on(.next("next 1")) //event emitted and received by Sub A. Value ("next 1") stored for replay
            
            behavSub.subscribe({ (event) in //Sub B added and most recent event replayed ("next 1")
                print("Sub B, line: \(#line)", "event: \(event)")
            })
                .disposed(by: dispose)
            
            behavSub.on(.next("next 2")) //event emitted to Sub A and Sub B. Value ("next 2") stored for replay
            
            behavSub.onCompleted() //emits completed event and terminates sequence
            
            
//
//            let dispose = DisposeBag()
//
//            let behavSub = BehaviorSubject<String>(value: "Starting value") //Must be instantiated with a starting value
//
//            behavSub.on(.next("before subscription")) //event emitted to no subscribers and stored for replay (single event buffer)
//
//            behavSub.subscribe({ (event) in //subscriber added and most recent event replayed
//                print("line: \(#line)", "event: \(event)")
//            })
//            .disposed(by: dispose)
//
//            behavSub.on(.next("after subscription")) //event emitted and received by subscription
//
//            behavSub.onCompleted() //emits completed event and terminates sequence
        }
        
        example(of: "Replay subject") { //REPLAY WITH BUFFER SIZE. At the point of subscribing, the new subscription will receive a replay of next events to the buffer limit.
            
            let disposeBag = DisposeBag()
            
            let replaySub = ReplaySubject<String>.create(bufferSize: 4)
            
            replaySub.on(.next("(pre) Event 1"))
            replaySub.on(.next("(pre) Event 2"))
            replaySub.on(.next("(pre) Event 3"))
            replaySub.on(.next("(pre) Event 4"))
            replaySub.on(.next("(pre) Event 5")) //5 events overfills the buffer
            
            replaySub.subscribe({ //replays the 4 events in memory (2-5)
                print("line: \(#line)", "event: \($0)")
            })

            .disposed(by: disposeBag)
            
            replaySub.on(.next("(post) Event 6")) //emits next event to subscription
            
            replaySub.onError(MyError.error2) //emits error event and terminates the sequence
            
            replaySub.on(.next("(post) Event 7")) //sequence cannot emit event as it has been terminated.
        }
        
        example(of: "Variable") {
            
            let disposeBag = DisposeBag()
            
            let variable = Variable<String>("starting value") //instantiate variable with starting value
            
            variable.asObservable().subscribe({ //asObservable() returns the BehaviorSubject which is held as a property. Sequence replays "starting value" to Sub A
                print("Sub A, line: \(#line)", "event: \($0)")
            })
                .disposed(by: disposeBag)
            
            variable.value = "next 1" // gets and sets to a privately stored property. Additionally, creates a next() event on the privately stored BehaviorSubject
            
            variable.asObservable().subscribe({ //Sequence replays "next 1" to Sub B
                print("Sub B, line: \(#line)", "event: \($0)")
            })
                .disposed(by: disposeBag)
            
            variable.value = "next 2" //emits "next 2" to both Sub A and Sub B
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

