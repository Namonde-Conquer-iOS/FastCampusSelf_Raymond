//
//  SettingViewController.swift
//  LEDOneMore
//
//  Created by sanghyo on 2022/06/28.
//

import UIKit

protocol sendDataDelegate: AnyObject {
    func sendData(text: String?, textColor: UIColor, backgroundColor: UIColor)
}

class SettingViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    
    weak var delegate: sendDataDelegate?
    var text: String?
    var textColor = UIColor.yellow
    var backgroundColor = UIColor.black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuration()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tapTextButton(_ sender: UIButton) {
        switch sender {
        case yellowButton:
            changeTextColor(color: UIColor.yellow)
            textColor = .yellow
        case greenButton:
            changeTextColor(color: UIColor.green)
            textColor = .green
        case purpleButton:
            changeTextColor(color: UIColor.purple)
            textColor = .purple
        default:
            return
        }
        
    }
    
    @IBAction func tapBackgroundButton(_ sender: UIButton) {
        switch sender {
        case blackButton:
            changeBackgroundColor(color: UIColor.black)
            backgroundColor = .black
        case blueButton:
            changeBackgroundColor(color: UIColor.blue)
            backgroundColor = .blue
        case redButton:
            changeBackgroundColor(color: UIColor.red)
            backgroundColor = .red
        default:
            return
        }
    }
    
    @IBAction func tapSaveButton(_ sender: UIButton) {
        self.delegate?.sendData(text: textField.text, textColor: textColor, backgroundColor: backgroundColor)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func changeTextColor(color: UIColor) {
        self.yellowButton.alpha = color == UIColor.yellow ? 1 : 0.2
        self.greenButton.alpha = color == UIColor.green ? 1 : 0.2
        self.purpleButton.alpha = color == UIColor.purple ? 1 : 0.2
    }
    
    private func changeBackgroundColor(color: UIColor) {
        self.blackButton.alpha = color == UIColor.black ? 1 : 0.2
        self.blueButton.alpha = color == UIColor.blue ? 1 : 0.2
        self.redButton.alpha = color == UIColor.red ? 1 : 0.2
    }
    
    private func configuration() {
        guard let text = text else { return }
        print(text)
        textField.text = text
        changeTextColor(color: textColor)
        changeBackgroundColor(color: backgroundColor)
    }
}
