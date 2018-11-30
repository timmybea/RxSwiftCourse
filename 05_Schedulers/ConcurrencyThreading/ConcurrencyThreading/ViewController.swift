//
//  ViewController.swift
//  ConcurrencyThreading
//
//  Created by Tim Beals on 2018-10-04.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.green
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
//        Setup some data. You could imagine performing a urlsession to get this
        let fredImage = UIImage(named: "fred")!
        let fredImageData = fredImage.pngData()!
        
//        we're currently on the main thread
        let imageData = PublishSubject<Data>()
        
        //CONCURRENT EX:
//        let globalConcurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        //SERIAL EX: note that the serialDispatchSched will return a serial queue regardless of the queue type that you pass into its initializer
//        let customQueue = DispatchQueue.init(label: "com.roobicreative.customQueue", qos: .background, attributes: .concurrent)
//        let globalSerialScheduler = SerialDispatchQueueScheduler(queue: customQueue, internalSerialQueueName: "com.roobicreative.serialQueue")
        
        //OPERATION QUEUE EX:
        let operationQueue = OperationQueue()
        let operationQueueScheduler = OperationQueueScheduler(operationQueue: operationQueue)
        
        
        imageData
            .observeOn(operationQueueScheduler)
//        .observeOn(globalSerialScheduler)
//        .observeOn(globalConcurrentScheduler) //receive events on background thread
        .map({ UIImage(data: $0)} ) //use map to transform the data type into UIImage type
        .observeOn(MainScheduler.instance) //now receive the images on the main thread
            .subscribe(onNext: { self.imageView.image = $0 })
            .disposed(by: disposeBag) //IMPORTANT: Dispose bag is thread safe. You can add a subscription from another thread to a db on the main thread...

        
        imageData.onNext(fredImageData)
        
    }
    
    override func viewWillLayoutSubviews() {
        imageView.removeFromSuperview()
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100)
            ])
    }

    func setupImageData() {
    }

}

