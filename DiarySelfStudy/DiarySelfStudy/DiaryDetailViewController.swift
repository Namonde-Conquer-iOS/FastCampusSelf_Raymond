//
//  DiaryDetailViewController.swift
//  DiarySelfStudy
//
//  Created by sanghyo on 2022/07/10.
//

import UIKit

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var starButton: UIBarButtonItem?
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: Notification.Name.editDiary,
                                               object: nil)
        // Do any additional setup after loading the view.
    }
    
    private func configureView() {
        guard let diary = diary else { return }
        titleLabel.text = diary.title
        contentTextView.text = diary.content
        dateLabel.text = dateToString(from: diary.date)
        starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton(_:)))
        starButton?.image = diary.isStar ? UIImage(systemName: "star.fill" ): UIImage(systemName: "star")
        starButton?.tintColor = UIColor.orange
        navigationItem.rightBarButtonItem = starButton
    }
    
    private func dateToString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    
    @objc func tapStarButton(_ button: UIBarButtonItem) {
        guard let isStar = diary?.isStar else { return }
        
        let image = isStar ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")
        starButton?.image = image
        diary?.isStar.toggle()
        NotificationCenter.default.post(name: NSNotification.Name.starDiary,
                                        object: diary,
                                        userInfo: nil)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        self.diary = diary
        configureView()
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let writeViewController = storyboard?.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let diary = diary else { return }
        writeViewController.writeMode = .edit(diary)
        navigationController?.pushViewController(writeViewController, animated: true)
    }
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.deleteDiary,
                                        object: diary?.id,
                                        userInfo: nil)
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
