/*
 Copyright © 2017 Optimac, Inc. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldLabel: UILabel!
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var textViewLabel: UILabel!
    @IBOutlet weak var button: Button!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControlLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var aSwitch: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var tapCount = 0
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CONTROL EVENT: Detect tap in our view controller to end editing in the text field
        //unonwned: it is impossible for vc to be released before the method is called, so instead of using weak we use unowned.
        //THINK OF THIS AS A SELECTOR METHOD: self = target and _ = sender
        tapGestureRecognizer.rx.event
            .bind(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
        .disposed(by: disposeBag)
        
        //CONTROL PROPERTY: bind the text in our textfield to the text in the textFieldLabel
        textField.rx.text
            .bind(to: textFieldLabel.rx.text)
            .disposed(by: disposeBag)
        //note that dispose isn't necessary as control property handles completed on deinit. But for the sake of uniformity this is standard.
        
        //DRIVER: Binds observable seq to UIElement
        textView.rx.text.orEmpty.asDriver() //Drivers cannot fail, so we need the 'orEmpty' to avoid nil
        .map { "Character count: \($0.count)" }
        .drive(textFieldLabel.rx.text)
        .disposed(by: disposeBag)
        
        
        button.rx.tap
            .bind(onNext: { [unowned self] _ in
                self.tapCount += 1
                self.buttonLabel.text = "TAPPED! \(self.tapCount)"
            } )
        .disposed(by: disposeBag)
        
        
        segmentedControl.rx.value
            .skip(1) //skip first emission as there is no initially selected index
            .map { "Selected index: \($0)" }
            .bind(to: segmentedControlLabel.rx.text)
        .disposed(by: disposeBag)
        
        slider.rx.value
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        aSwitch.rx.value
            .bind(onNext: { [unowned self] on in
                switch on {
                case true:
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                case false:
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            })
        .disposed(by: disposeBag)

        stepper.rx.value
            .map { "Value is: \(Int($0))" }
            .bind(to: stepperLabel.rx.text)
        .disposed(by: disposeBag)
        
        //driver as an example: (remember driver is predominantly used for binding model objects to UI)
        datePicker.rx.date.asDriver()
            .map { self.dateFormatter.string(from: $0 ) }
            .drive(datePickerLabel.rx.text)
        .disposed(by: disposeBag)

    }
}
