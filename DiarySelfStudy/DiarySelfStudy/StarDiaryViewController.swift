//
//  StarDiaryViewController.swift
//  DiarySelfStudy
//
//  Created by sanghyo on 2022/07/10.
//

import UIKit

class StarDiaryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var starDiaryList = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        collectionView.delegate = self
        collectionView.dataSource = self
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
        // Do any additional setup after loading the view.
    }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private func dateToString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    
    private func loadData() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        starDiaryList = data.compactMap {
            guard let id = $0["id"] as? String, let title = $0["title"] as? String, let content = $0["content"] as? String,
                  let date = $0["date"] as? Date, let isStar = $0["isStar"] as? Bool else { return nil }
            let diary = Diary(id: id, title: title, content: content, date: date, isStar: isStar)
            return diary
        }
        .filter {
            $0.isStar == true
        }
        .sorted {
            $0.date.compare($1.date) == .orderedAscending
        }
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        if diary.isStar {
            starDiaryList.append(diary)
            starDiaryList.sort {
                $0.date.compare($1.date) == .orderedAscending
            }
            collectionView.reloadData()
        } else {
            guard let index = starDiaryList.firstIndex(where: {
                $0.id == diary.id
            }) else { return }
            starDiaryList.remove(at: index)
            collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let index = starDiaryList.firstIndex(where: {
            $0.id == diary.id
        }) else { return }
        starDiaryList[index] = diary
        starDiaryList = starDiaryList.sorted {
            $0.date.compare($1.date) == .orderedAscending
        }
        collectionView.reloadData()
    }
    
    @objc func deleteNotification(_ notification: Notification) {
        guard let id = notification.object as? String else { return }
        guard let index = starDiaryList.firstIndex(where: {
            $0.id == id
        }) else { return }
        starDiaryList.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
}

extension StarDiaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 100)
    }
}

extension StarDiaryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        starDiaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCell", for: indexPath) as? StarCell else { return UICollectionViewCell()}
        let diary = starDiaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = dateToString(from: diary.date)
        
        return cell
    }
}

extension StarDiaryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = starDiaryList[indexPath.row]
        detailViewController.diary = diary
        detailViewController.indexPath = indexPath
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
