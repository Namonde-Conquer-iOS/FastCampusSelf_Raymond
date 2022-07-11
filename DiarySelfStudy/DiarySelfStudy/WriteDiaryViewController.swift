//
//  WriteDiaryViewController.swift
//  DiarySelfStudy
//
//  Created by sanghyo on 2022/07/10.
//

import UIKit

protocol WriteDiaryViewDelegate: AnyObject {
    func registerDiary(diary: Diary)
}

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var registerButton: UIBarButtonItem!
    
    weak var delegate: WriteDiaryViewDelegate?
    var datePicker = UIDatePicker()
    private var diaryDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        configureDatePicker()
        configureTextField()
        registerButton.isEnabled = false
    }
    
    @IBAction func tapRegisterButton(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, let content = contentTextView.text, let date = diaryDate else { return }
        let diary = Diary(id: UUID().uuidString, title: title, content: content, date: date, isStar: false)
        delegate?.registerDiary(diary: diary)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureContentView() {
        self.contentTextView.layer.borderWidth = 1.0
        self.contentTextView.layer.borderColor = UIColor.black.cgColor
        self.contentTextView.layer.cornerRadius = 3.0
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        self.datePicker.locale = Locale(identifier: "ko-KR")
        self.dateTextField.inputView = self.datePicker
        self.handleFields()
    }
    
    private func configureTextField() {
        self.contentTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldChanged(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldChanged(_:)), for: .editingChanged)
    }
    
    private func handleFields() {
        registerButton.isEnabled = !(titleTextField.text?.isEmpty ?? true) && !(dateTextField.text?.isEmpty ?? true) && !contentTextView.text.isEmpty
    }
    
    @objc func datePickerChanged(_ datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.diaryDate = datePicker.date
        dateTextField.sendActions(for: .editingChanged)
    }
    
    @objc func titleTextFieldChanged(_ textField: UITextField) {
        self.handleFields()
    }
    
    @objc func dateTextFieldChanged(_ textField: UITextField) {
        self.handleFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension WriteDiaryViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.handleFields()
    }
}
