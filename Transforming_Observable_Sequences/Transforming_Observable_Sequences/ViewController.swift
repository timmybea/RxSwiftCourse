//
//  ViewController.swift
//  Transforming_Observable_Sequences
//
//  Created by Tim Beals on 2018-08-13.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.darkGray

        //map transforms the elements and puts them into a new sequence
        
        let db = DisposeBag()
        Observable.of(1, 2, 3, 4)
            .map() { $0 * $0 }
            .subscribe(onNext: {
                print("sub 1: \($0)")
            })
            .disposed(by: db)
        
        //IN FULL:
//        let db = DisposeBag()
//        let seq = Observable.of(1, 2, 3, 4)
//        let copySeq = seq.map() { $0 * $0 }
//        copySeq.subscribe(onNext: {
//            print("sub 1: \($0)")
//        })
//            .disposed(by: db)
        
        
        example(of: "flatMap and flatMapLatest") {
            
            struct Player {
                let score: Variable<Int>
            }
            
            let disposeBag = DisposeBag()
            
            let scott = Player(score: Variable(80))
            let lori = Player(score: Variable(95))
            
            //current player is type Variable<Player>
            var currentPlayer = Variable(scott)

            //we want to subscribe to current player's score. That is the score observable inside the player observable. Remember that Variable is a wrapper, and you can access the observable through .asObservable()
            
            currentPlayer.asObservable() //observable<Player>
                .flatMapLatest { $0.score.asObservable() }
                //.flatMap { $0.score.asObservable() }
                //observable<Int>. Notice that flatMap pulls the value out of the observable subject.
                .subscribe(onNext: {
                    print("sub 1: score is \($0)") //replays 80
                })
            .disposed(by: disposeBag)

            //Now you can change the value inside the current player...
            currentPlayer.value.score.value = 90
            
            //notice that because you are working with reference types you can do the same thing by accessing scott outside current player
            scott.score.value = 100
            
            currentPlayer.value = lori
            
            //GOTCHA: so what happened to the subscription to scott's score? FlatMap does not unsubscribe from the previous sequence, so now you have two subscriptions. FlatMapLatest however, changes the subscription from observing scott to observing lori.
            scott.score.value = 110
            lori.score.value = 135

        }

        example(of: "scan & buffer") {
            let db = DisposeBag()
            
            let dartScore = PublishSubject<Int>() //does not replay. sends .next as new elements are added.
            
            //in darts, each player starts with a score of 501 and as they score, it is taken away.
            dartScore
                .buffer(timeSpan: 0.0, count: 3, scheduler: MainScheduler.instance) //batches 3 next events
                .map() {
                    print($0, "=> ", terminator: "") //prints the array of 3 next events
                    return $0.reduce(0, +) //adds together the three values and returns
                }
                .scan(501) { $0 - $1 } // or scan(501, accumulator: -) //removes the total of the three values from the running total
                .map { max($0, 0) } //check to ensure that you don't go into negative numbers.
                
                .subscribe(onNext: {
                    print("dart score: \($0)")
                })
            .disposed(by: db)
            
            dartScore.onNext(13)
            dartScore.onNext(60)
            dartScore.onNext(50)
            
            dartScore.onNext(26)
            dartScore.onNext(60)
            dartScore.onNext(10)
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

