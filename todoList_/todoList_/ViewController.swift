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
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    let dataManager = ListDataManager.shared
    
    var todoData: TodoData?
    
    // 셀에 버튼 클릭 이벤트에 대한 클로저 정의
    var cellButtonAction: ((IndexPath) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        setTitle()
        // 셀 버튼 클릭 이벤트에 대한 클로저 처리
        cellButtonAction = { indexPath in
            // 선택된 셀에 대한 작업 수행
            let tododataList = self.dataManager.getTodoListCoreData()[indexPath.row]
            self.dataManager.updateCheckedCoreData(moveRowAt: tododataList)
        }
    }
    
    // 화면에 다시 진입할때마다 다시 테이블뷰 그리기 (업데이트 등 제대로 표시)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
    }
    
    // tableview 기본 설정
    func setting() {
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = 60
//        tableview.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
    }
    
    // 네비게이션 title에 UILabel 추가하기
    func setTitle() {
        let nTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        nTitle.textAlignment = .center
        nTitle.font = UIFont.init(name: "American Typewriter Bold", size: 29.0)
        nTitle.text = "Todo List"
        self.navigationItem.titleView = nTitle
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
        
        let alert = UIAlertController(title: "Add",
                                      message: "해야 할 일을 입력해주세요.",
                                      preferredStyle: .alert)
        
        alert.addTextField{ $0.placeholder = "to do" }
        
        alert.addAction(UIAlertAction(title: "확인",
                                      style: .default,
                                      handler: { _ in
            guard let text = alert.textFields?[0].text else {return}
            if text != "" {
                self.dataManager.saveTodoListData(todoTitle: text) {
                    print("저장완료")
                }
                self.tableview.reloadData()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "취소",
                                      style: .cancel,
                                      handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - UITableViewDataSource와 UITableViewDelegate 프로토콜 채택
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // tableview의 Row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.getTodoListCoreData().count
    }
    
    
    // tableview의 각 cell로 데이터 전달
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        // dataManager를 통한 코어데이터 받아오기
        let toDoData = dataManager.getTodoListCoreData()
        cell.toDoData = toDoData[indexPath.row]
        
        // 셀에 클로저 할당
        cell.buttonAction = {
            self.cellButtonAction?(indexPath)
        }
        
        // cell 선택되지 않도록 설정
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
            todoData = dataManager.getTodoListCoreData()[indexPath.row]
            guard let todoData = todoData else {
                print("데이터 저장 실패")
                return
            }
            self.dataManager.deleteTodoListData(data: todoData) {
                print("삭제")
            }
            self.tableview.reloadData()
        }
    }
    
    
    // editing 모드에서의 row 이동구현
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let nowtodoData = dataManager.getTodoListCoreData()[sourceIndexPath.row]
        let destinationtodoData = dataManager.getTodoListCoreData()[destinationIndexPath.row]
        
        self.dataManager.updatePriorityCoreData(moveRowAt: nowtodoData, to: destinationtodoData)
        self.tableview.reloadData()
    }
    
}
