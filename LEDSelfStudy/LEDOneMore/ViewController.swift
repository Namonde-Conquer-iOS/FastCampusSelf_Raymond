//
//  ViewController.swift
//  LEDOneMore
//
//  Created by sanghyo on 2022/06/28.
//

import UIKit

class ViewController: UIViewController, sendDataDelegate {

    @IBOutlet weak var contentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.contentsLabel.textColor = UIColor.yellow
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? SettingViewController else { return }
        viewController.delegate = self
        viewController.text = contentsLabel.text
        viewController.textColor = contentsLabel.textColor
        viewController.backgroundColor = view.backgroundColor ?? UIColor.black
    }

    func sendData(text: String?, textColor: UIColor, backgroundColor: UIColor) {
        guard let text = text else { return }
        self.contentsLabel.text = text
        self.contentsLabel.textColor = textColor
        self.view.backgroundColor = backgroundColor
    }
}

