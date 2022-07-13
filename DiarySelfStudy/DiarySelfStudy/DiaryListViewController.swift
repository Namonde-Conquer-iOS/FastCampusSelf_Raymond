//
//  DiaryListViewController.swift
//  DiarySelfStudy
//
//  Created by sanghyo on 2022/07/10.
//

import UIKit

class DiaryListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var diaryList = [Diary]() {
        didSet {
            saveData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureCollectionView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(starDiaryNotification(_:)),
                                               name: NSNotification.Name.starDiary,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: Notification.Name.editDiary,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteNotification(_:)),
                                               name: NSNotification.Name.deleteDiary,
                                               object: nil)
    }
    
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
        
    private func dateToString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    
    private func saveData() {
        let userDefaults = UserDefaults.standard
        let diaries = diaryList.map {
            [
                "id": $0.id,
                "title": $0.title,
                "content": $0.content,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        userDefaults.set(diaries, forKey: "diaryList")
    }
    
    private func loadData() {
        let userDefaults = UserDefaults.standard
        guard let diaries = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        diaryList = diaries.compactMap {
            guard let id = $0["id"] as? String, let title = $0["title"] as? String, let content = $0["content"] as? String,
                  let date = $0["date"] as? Date, let isStar = $0["isStar"] as? Bool else { return nil }
            let diary = Diary(id: id, title: title, content: content, date: date, isStar: isStar)
            return diary
        }
        diaryList = diaryList.sorted {
            $0.date.compare($1.date) == .orderedAscending
        }
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let index = diaryList.firstIndex(where: {
            $0.id == diary.id
        }) else { return }
        diaryList[index].isStar.toggle()
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let index = diaryList.firstIndex(where: {
            $0.id == diary.id
        }) else { return }
        diaryList[index] = diary
        diaryList = diaryList.sorted {
            $0.date.compare($1.date) == .orderedAscending
        }
        collectionView.reloadData()
    }
    
    @objc func deleteNotification(_ notification: Notification) {
        guard let id = notification.object as? String else { return }
        guard let index = diaryList.firstIndex(where: {
            $0.id == id
        }) else { return }
        diaryList.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? WriteDiaryViewController else { return }
        viewController.delegate = self
    }
}

extension DiaryListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListCell else { return UICollectionViewCell()}
        let diary = diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = dateToString(from: diary.date)
        
        return cell
    }
}

extension DiaryListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
    }
}

extension DiaryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        detailViewController.diary = diaryList[indexPath.row]
        detailViewController.indexPath = indexPath
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}

extension DiaryListViewController: WriteDiaryViewDelegate {
    func registerDiary(diary: Diary) {
        self.diaryList.append(diary)
        self.diaryList.sort {
            $0.date.compare($1.date) == .orderedAscending
        }
        self.collectionView.reloadData()
    }
}
