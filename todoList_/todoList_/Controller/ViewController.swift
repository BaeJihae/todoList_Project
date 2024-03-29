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
    
    var tododataSegue: TodoData? = nil
    
    // MARK: - UI관련
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        buttonAction()
        setDate()
        NotificationCenter.default.addObserver(self, selector: #selector(dataSaved), name: NSNotification.Name(rawValue: "DataSaved"), object: nil)
    }

    // 데이터 저장 완료 알림을 받았을 때 호출되는 메서드
    @objc func dataSaved() {
        print(#function)
        tableview.reloadData()
    }
    
    // 화면을 전환할 때마다 다시 테이블뷰 그리기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
        date.text = pagedate
    }
    
    
    // tableview 기본 설정
    func setting() {
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = 60
    }
    
    
    // 네비게이션 title에 UILabel 추가하기
    func setTitle() {
        let todoTitle = UILabel(frame: CGRect(x: 0, y: -30, width: 200, height: 60))
        todoTitle.textAlignment = .left
        todoTitle.font = UIFont.init(name: "Charter Bold", size: 25.0)
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
        pagedate = now.toString()
        
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
            
        } else {
            
            // editing 모드 활성화
            self.editButton.title = "Done"
            self.tableview.setEditing(true, animated: true)
            
        }
    }
    
    
    // MARK: - Add Button
    
    // add Button이 눌렸을 때 얼럿창 띄우기
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        let transparentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddDataViewController")
        
        // 뷰 컨트롤러의 전환 스타일 설정 (모달, 밑에서 위로 올라오는 애니메이션)
        transparentViewController.modalPresentationStyle = .overFullScreen
        transparentViewController.modalTransitionStyle = .coverVertical
        
        // ViewController 전환
        present(transparentViewController, animated: true, completion: nil)
        
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
        cell.toDoData = toDoData[indexPath.row]
        
        // cell로 indexPath 값 넘겨주기
        cell.buttonAction = {
            self.cellButtonAction?(indexPath)
        }
        
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
    
    
//    // editing 모드에서의 row 이동
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        
//        let sourcetodoData = dataManager.getTodoListCoreData(pagedate)[sourceIndexPath.row]
//        let destinationtodoData = dataManager.getTodoListCoreData(pagedate)[destinationIndexPath.row]
//        
//        // cell의 row 변화
//        self.dataManager.updatePriorityCoreData(moveRowAt: sourcetodoData, to: destinationtodoData)
//        
//        self.tableview.reloadData()
//    }
    
    // 테이블 셀을 클릭할 시 수정 화면
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        
        guard let AddDataViewController = storyboard?.instantiateViewController(withIdentifier: "AddDataViewController") as? AddDataViewController else { return }
        
        AddDataViewController.todoData = self.dataManager.getTodoListCoreData(self.pagedate)[indexPath.row]
        
        AddDataViewController.modalPresentationStyle = .overFullScreen
        AddDataViewController.modalTransitionStyle = .coverVertical
        
        present(AddDataViewController, animated: true, completion: nil)
        
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
