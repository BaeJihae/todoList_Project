//
//  ToDoListViewController.swift
//  todoList_
//
//  Created by 배지해 on 3/26/24.
//

import UIKit

class ToDoListViewController: UIViewController {

    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var goToTodoButton: UIButton!
    @IBOutlet weak var dateTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!

    let dataManager = ListDataManager.shared
    var selectedDate: Date?
    var todoData: [TodoData]?
    
    
    // 셀에 버튼 클릭 이벤트에 대한 클로저 정의
    var cellAction: ((IndexPath) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setBackgroundView()
        setTodayDateLabel()
        setDateTableView()
        setTapGesture()
        dateTableView.reloadData()
    }
    
    
    func setData() {
        guard let selectedDate = selectedDate else { return }
        todoData = dataManager.getTodoListCoreData(selectedDate.toString())
    }
    
    
    func setBackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 15                              // 뷰의 모서리 둥글기 설정
        backgroundView.layer.shadowColor = UIColor.black.cgColor            // 그림자 색상
        backgroundView.layer.shadowOpacity = 0.4                            // 그림자 투명도
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)     // 그림자의 위치
        backgroundView.layer.shadowRadius = 6                               // 그림자의 반경
    }
    
    
    func setTodayDateLabel() {
        todayDateLabel.text = selectedDate?.toString()
    }
    
    
    func setDateTableView() {
        dateTableView.delegate = self
        dateTableView.dataSource = self
        
        dateTableView.estimatedRowHeight = 60.0
        dateTableView.rowHeight = UITableView.automaticDimension
    }
    
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    // 바깥쪽 영역 터치 시 호출될 메서드
    @objc func handleOutsideTap() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // 버튼 눌렀을 때 해당 todoList로 이동
    @IBAction func goToTodoButtonTapped(_ sender: UIButton) {
        
    }
}
extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedDate = selectedDate else { return 0 }
        return dataManager.getTodoListCoreData(selectedDate.toString()).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateToDoCell", for: indexPath) as! DateToDoCell
        
        guard let selectedDate = selectedDate else { return cell }
        guard let todoData = todoData else { return cell }
        
        cell.todoLabel.text = todoData[indexPath.row].title
        cell.isCheckedButton.isSelected = todoData[indexPath.row].isChecked
        
        return cell
    }
}
