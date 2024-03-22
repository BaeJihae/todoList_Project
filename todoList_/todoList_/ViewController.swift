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
    
    
    // 페이지 날짜 저장
    var pagedate: String = ""
    
    
    // 셀에 버튼 클릭 이벤트에 대한 클로저 정의
    var cellButtonAction: ((IndexPath) -> Void)?
    
    
    // MARK: - UI관련
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        setTitle()
        buttonAction()
        setDate()
    }
    

    // 화면을 전환할 때마다 다시 테이블뷰 그리기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
    }
    
    
    // tableview 기본 설정
    func setting() {
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = 60
    }
    
    
    // 네비게이션 title에 UILabel 추가하기
    func setTitle() {
        let todoTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        todoTitle.textAlignment = .center
        todoTitle.font = UIFont.init(name: "American Typewriter", size: 25.0)
        todoTitle.text = "TodoList"
        self.navigationItem.titleView = todoTitle
    }
    
    
    // MARK: - cell로 indexPath 값 주기
    
    // 체크 버튼이 선택되었을 때, indexPath 값 넘겨주기
    func buttonAction() {
        cellButtonAction = { indexPath in
            let tododataList = self.dataManager.getTodoListCoreData(self.pagedate)[indexPath.row]
            self.dataManager.updateCheckedCoreData(moveRowAt: tododataList)
        }
    }
    
    
    // MARK: - 날짜 변경하기
    
    // 기본 날짜 오늘로 설정하기
    func setDate() {
        let now = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yy.MM.dd"
        pagedate = formatter.string(from: now)
        
        // UILabel 설정
        date.text = pagedate
    }
    
    
    
    // 날짜 변경하기
    func changeDate() {
        
        // UILabel 설정
        date.text = pagedate
        self.tableview.reloadData()
    }
    
    
    // MARK: - Edit Button
    
    // Edit Button이 눌렸을 때 버튼 이름 변경하기 / Editing 모드로 변환
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
    
    
    // MARK: - Add Button
    
    // add Button이 눌렸을 때 얼럿창 띄우기
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add",
                                      message: "해야 할 일을 입력해주세요.",
                                      preferredStyle: .alert)
        
        alert.addTextField{ $0.placeholder = "to do" }
        
        // 얼럿 창의 확인 버튼
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
        
        // 얼럿 창의 취소 버튼
        alert.addAction(UIAlertAction(title: "취소",
                                      style: .cancel,
                                      handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - BackButton
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        // 현재 pageDate에서 하루 전으로 변경
        if let date = pagedate.toDate() {
            let changedDate = Calendar.current.date(byAdding: .day, value: -1, to: date)
            if let toStringDate = changedDate?.toString() {
                pagedate = toStringDate
            }
        }
        changeDate()
    }
    
    
    // MARK: - FrontButton
    
    @IBAction func frontButtonTapped(_ sender: UIButton) {
        
        // 현재 pageDate에서 하루 후로 변경
        if let date = pagedate.toDate() {
            let changedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
            if let toStringDate = changedDate?.toString() {
                pagedate = toStringDate
            }
        }
        changeDate()
    }
}




// MARK: - UITableViewDataSource와 UITableViewDelegate 프로토콜 채택
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - TableView의 기본 함수
    
    // tableview의 Row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.getTodoListCoreData(pagedate).count
    }
    
    
    // tableview의 각 cell로 데이터 전달
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        // dataManager를 통한 코어데이터 받아오기
        let toDoData = dataManager.getTodoListCoreData(pagedate)
        print(toDoData)
        cell.toDoData = toDoData[indexPath.row]
        
        // cell로 indexPath 값 넘겨주기
        cell.buttonAction = {
            self.cellButtonAction?(indexPath)
        }
        
        // cell이 선택이 되지 않도록 설정
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    // MARK: - Editing 모드
    
    // editing 모드 결정
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    // editing 모드에서의 요소 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            todoData = dataManager.getTodoListCoreData(pagedate)[indexPath.row]
            guard let todoData = todoData else {
                print("\(#function)에서 data를 불러오지 못하였습니다.")
                return
            }
            
            // cell 삭제
            self.dataManager.deleteTodoListData(data: todoData) {
                print("data delete")
            }
            
            self.tableview.reloadData()
        }
    }
    
    
    // editing 모드에서의 row 이동
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let sourcetodoData = dataManager.getTodoListCoreData(pagedate)[sourceIndexPath.row]
        let destinationtodoData = dataManager.getTodoListCoreData(pagedate)[destinationIndexPath.row]
        
        // cell의 row 변화
        self.dataManager.updatePriorityCoreData(moveRowAt: sourcetodoData, to: destinationtodoData)
        
        self.tableview.reloadData()
    }
    
    
    // MARK: - Revise 구현
    
    // 기본 모드에서 왼쪽으로 슬라이스
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // UIContextualAction
        let revise = UIContextualAction(style: .normal, title: "revise") { (action, view, completion: @escaping (Bool) -> Void ) in
            
            // 편집 동작 구현
            let alert = UIAlertController(title: "수정",
                                          message: "to do를 수정해 주세요.",
                                          preferredStyle: .alert)
            
            alert.addTextField{ $0.placeholder = "to do" }
            
            // 얼럿 창의 확인 버튼
            alert.addAction(UIAlertAction(title: "확인",
                                          style: .default,
                                          handler: { _ in
                
                let modifiedtodoData = self.dataManager.getTodoListCoreData(self.pagedate)[indexPath.row]
                guard let text = alert.textFields?[0].text else {return}
                if text != "" {
                    
                    // cell의 title 수정
                    self.dataManager.updateTodoListData(text, modifiedtodoData)
                    
                    self.tableview.reloadData()
                }
            }))
            
            // 얼럿 창의 최소 버튼
            alert.addAction(UIAlertAction(title: "취소",
                                          style: .cancel,
                                          handler: nil))
            
            self.present(alert, animated: true, completion: nil)

            
            
            print("edit 클릭 됨")
            completion(true)
        }
        
        // 이미지 / 백그라운드 설정
        revise.image = UIImage(systemName: "pencil")
        revise.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [revise])
    }
}


// MARK: - toDate 함수

extension String {
    // String -> Date 로 변경하는 함수
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}


// MARK: - toString 함수

extension Date {
    // Date -> String 으로 변경하는 함수
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        return dateFormatter.string(from: self)
    }
}
