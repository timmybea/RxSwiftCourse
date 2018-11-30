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

        
        //emits a value or error
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
            .disposed(by: disposeBag)
        }
        
        //emits completed or error
        example(of: "Completable") {

            let disposeBag = DisposeBag()


            enum FileWriteError: Error {
                case docDirNotFound, writeError
            }

            func write(_ text: String, tofileName name: String) -> Completable {

                return Completable.create { (completable) -> Disposable in

                    let disposable = Disposables.create {}

                    guard var filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        completable(.error(FileWriteError.docDirNotFound))
                        return disposable
                    }

                    filePath.appendPathComponent("\(name).txt")
                    
                    //see if there is already contents in the file
                    var contents = (try? String(contentsOf: filePath, encoding: .utf8)) ?? ""
                    contents += "\n\(text)"

                    do {
                        try contents.write(to: filePath, atomically: false, encoding: .utf8)
                        completable(.completed)
                        return disposable
                    } catch {
                        completable(.error(FileWriteError.writeError))
                        return disposable
                    }
                }
            }

//            write("Shanana", tofileName: "Hello_World")
//                .subscribe {
//                    switch $0 {
//                    case .completed: print("write completed")
//                    case .error(let error): print("write error: \(error)")
//                    }
//                }
//                .disposed(by: disposeBag)
//
//            //Check that the write was successful
//            if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                let files = try? FileManager.default.contentsOfDirectory(at: docDir, includingPropertiesForKeys: nil)
//
//                if let files = files {
//                    print("files in docs dir")
//                    for file in files {
//                        print(file.lastPathComponent)
//
//                        if file.pathExtension == "txt" {
//                            if let contents = try? String(contentsOf: file, encoding: .utf8) {
//                                print("contents: \(contents)")
//                            }
//                        }
//                    }
//                }
//            }
            
        }
        
        //emits a value, completed, or error
        example(of: "Maybe") {
            
            let disposeBag = DisposeBag()
            
            enum FileWriteError: Error {
                case urlFail, unreadable, encodingFailed, writeFailed
            }
            
            func write(_ text: String, toFile fileName: String) -> Maybe<String> {
                
                return Maybe.create(subscribe: { (maybe) -> Disposable in
                    
                    let disposable = Disposables.create { }
                    
                    //create url
                    guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { maybe(.error(FileWriteError.urlFail)); return disposable }
                    let myURL = docDir.appendingPathComponent("\(fileName).txt")
                    
                    
//                    //APPROACH 1: Get the data from the disk and turn it into a string. Append the new text to the end of the string and write the string.
//
//                    //check if file exists
//                    var isDir: ObjCBool = false
//                    var exists = FileManager.default.fileExists(atPath: myURL.path, isDirectory: &isDir)
//
//                    var contents = ""
//                    if exists && !isDir.boolValue {
//                        //if file exists, pull data and append text to the end
//                        guard let readData = FileManager.default.contents(atPath: myURL.path)                            else {
//                            maybe(.error(FileWriteError.unreadable))
//                            return disposable
//                        }
//
//                        if let existing = String(data: readData, encoding: .utf8) {
//                            contents = existing + "\n"
//                        }
//                    }
//
//
//                    contents.append(text)
//
//                    do {
//                        try contents.write(to: myURL, atomically: false, encoding: .utf8)
//                        maybe(.success(text))
//                        return disposable
//                    } catch {
//                        maybe(.error(FileWriteError.writeFailed))
//                        return disposable
//                    }
//
                    //APPROACH 2: Get the data from the disk, use a handle to scan to the end of the data, convert the new text to data and append it to the end. Write the data.
                    
                    //handle can only be created if there is a file at the path
                    if let handle = FileHandle(forWritingAtPath: myURL.path) {
                        
                        handle.seekToEndOfFile()
                        
                        guard let newTextData = text.data(using: .utf8) else {
                            maybe(.error(FileWriteError.encodingFailed))
                            return disposable
                        }
                        
                        handle.write(newTextData)
                        
                        maybe(.success(text))
                        return disposable
                    } else {
                        
                        do {
                            try text.write(to: myURL, atomically: false, encoding: .utf8)
                            maybe(.success(text))
                            return disposable
                        } catch {
                            maybe(.error(FileWriteError.writeFailed))
                            return disposable
                        }
                    }
                })
                
                
                
            }
            
            write("Wotcha Want?!", toFile: "My File")
                .subscribe {
                    switch $0 {
                    case .completed:
                        print("maybe: completed")
                    case .error(let error):
                        print("maybe: error \(error.localizedDescription)")
                    case .success(let element):
                        print("maybe: success \(element)")
                    }
            }
            .disposed(by: disposeBag)
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

