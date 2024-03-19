//
//  ViewController.swift
//  todoList_
//
//  Created by 배지해 on 3/18/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let dataManager = ListDataManager()

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.makeListData()
        setting()
        setTitle()
    }
    
    // edit Button이 눌렸을 때 버튼 이름 변경하기 -> 추가모드로 변환
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if self.tableview.isEditing {
            // editing 모드 비활성화
            self.editButton.title = "Edit"
            self.tableview.setEditing(false, animated: true)
            // addButton 비활성화 / 숨기기
            self.addButton.isEnabled = false
            self.addButton.isHidden = true
        } else {
            // editing 모드 활성화
            self.editButton.title = "Done"
            self.tableview.setEditing(true, animated: true)
            // addButton 활성화 / 보이기
            self.addButton.isEnabled = true
            self.addButton.isHidden = false
        }
    }
    
    // add Button이 눌렸을 때 얼럿창 띄우기
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add", message: "해야 할 일을 입력해주세요.",
                                      preferredStyle: .alert)
        alert.addTextField{ tf in
            tf.placeholder = "to do"
        }
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            guard let text = alert.textFields?[0].text else {return}
            if text != "" {
                self.dataManager.updateTodoListData(text)
                self.tableview.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // 네비게이션 title에 UILabel 추가하기
    func setTitle() {
        let nTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        nTitle.textAlignment = .center
        nTitle.font = UIFont.init(name: "American Typewriter Bold", size: 29.0)
        nTitle.text = "Todo List"
        self.navigationItem.titleView = nTitle
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setting() {
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 리턴되는 테이블 뷰 개수
        return dataManager.getTodoListData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        let todoArray = dataManager.getTodoListData()
        cell.todoText.text = todoArray[indexPath.row].title
        cell.selectionStyle = .none
        
        return cell
    }
    
    // editing 모드의 스타일
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // editing 모드에서의 요소 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            print("delete")
            self.dataManager.deleteTodoListData(indexPath.row)
            self.tableview.reloadData()
        }
    }
    
    // editing 모드에서의 row 이동구현
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todolistArray = dataManager.getTodoListData()
        let targetList: TodoData = todolistArray[sourceIndexPath.row]
        dataManager.deleteTodoListData(sourceIndexPath.row)
        dataManager.insertTodoListData(destinationIndexPath.row, targetList)
    }
    
}
