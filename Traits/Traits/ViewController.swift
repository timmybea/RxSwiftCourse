//
//  ViewController.swift
//  Traits
//
//  Created by Tim Beals on 2018-08-07.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import RxSwift


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        example(of: "Single") {
            let disposeBag = DisposeBag()
            
            enum FileReadError: Error {
                case fileNotFound, unreadable, encodingFailed
            }
            
            func contentsOfTextFile(named name: String) -> Single<String> {
                
//                return Single.create { single in //requires a disposable to be returned
//
//                    let disposable = Disposables.create {}
//
//                    //get the path and if it doesn't exist, return fileNotFound
//                    guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
//                        single(.error(FileReadError.fileNotFound))
//                        return disposable
//                    }
//
//                    //get the data at the path else return unreadable error
//                    guard let data = FileManager.default.contents(atPath: path) else {
//                        single(.error(FileReadError.unreadable))
//                        return disposable
//                    }
//
//                    //use the data to create the content
//                    guard let contents = String(data: data, encoding: .utf8) else {
//                        single(.error(FileReadError.encodingFailed))
//                        return disposable
//                    }
//
//                    single(.success(contents))
//                    return disposable
//                }

                
                //This is a factory method that produces the same results as above, but in a more succinct manner
                return Single.deferred {
                    //get the path and if it doesn't exist, return fileNotFound
                    guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                        throw FileReadError.fileNotFound
                    }
                    
                    //get the data at the path else return unreadable error
                    guard let data = FileManager.default.contents(atPath: path) else {
                        throw FileReadError.unreadable
                    }
                    
                    //use the data to create the content
                    guard let contents = String(data: data, encoding: .utf8) else {
                        throw FileReadError.encodingFailed
                    }
                    
                    return Single.just(contents)
                }

            }
            
            contentsOfTextFile(named: "FreshPrince") // returns PrimitiveSequence<SingleTrait, String>
          
            .subscribe({
                switch $0 {
                case .success(let string):
                    print("success: \(string)")
                case .error(let error):
                    print("error: \(error)")
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

