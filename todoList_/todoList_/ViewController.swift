//
//  ViewController.swift
//  todoList_
//
//  Created by 배지해 on 3/18/24.
//

import UIKit

class ViewController: UIViewController {
    
    var tododataArray: [TodoData] = [
        TodoData(id: 0, title: "안녕하세요", isChecked: false),
        TodoData(id: 1, title: "오잉?", isChecked: false),
        TodoData(id: 2, title: "체크박스 확인", isChecked: false),
        TodoData(id: 3, title: "난 지해", isChecked: false),
        TodoData(id: 4, title: "안녕하세요", isChecked: false),
        TodoData(id: 5, title: "오잉?", isChecked: false),
        TodoData(id: 6, title: "체크박스 확인", isChecked: false),
        TodoData(id: 7, title: "난 지해", isChecked: false),
        TodoData(id: 8, title: "안녕하세요", isChecked: false),
        TodoData(id: 9, title: "오잉?", isChecked: false),
        TodoData(id: 10, title: "체크박스 확인", isChecked: false),
        TodoData(id: 11, title: "난 지해", isChecked: false),
        TodoData(id: 12, title: "안녕하세요", isChecked: false),
        TodoData(id: 13, title: "오잉?", isChecked: false),
        TodoData(id: 14, title: "체크박스 확인", isChecked: false),
        TodoData(id: 15, title: "난 지해", isChecked: false)
    ]

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func setting() {
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 리턴되는 테이블 뷰 개수
        return tododataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        cell.todoText.text = tododataArray[indexPath.row].title
        return cell
    }
}
