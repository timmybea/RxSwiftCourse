//
//  ViewController.swift
//  BindDataToUI
//
//  Created by Tim Beals on 2018-10-09.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var button: UIButton!

    var tapGesture = UITapGestureRecognizer()
    
    let disposeBag = DisposeBag()
    
    let textFieldText = BehaviorSubject<String>(value: "")
    let buttonTapped = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .bind(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
        .disposed(by: disposeBag)
        
        textField.rx.text.orEmpty
            .bind(to: textFieldText)
        .disposed(by: disposeBag)
        
        textFieldText.asObservable()
            .subscribe(onNext: { print("textFieldText: \($0)") })
        .disposed(by: disposeBag)
        
        
        button.rx.tap
            .map { "tapped!" }
        .bind(to: buttonTapped)
        .disposed(by: disposeBag)
        
        buttonTapped
            .subscribe { print($0.element ?? $0) } //print element or else print nil
        .disposed(by: disposeBag)
    }
}

