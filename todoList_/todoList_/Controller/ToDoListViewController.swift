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
    @IBOutlet weak var stackView: UIStackView!
    
    let dataManager = ListDataManager.shared
    var selectedDate: Date?
    var todoData: [TodoData]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setBackgroundView()
        setGoToTodoButton()
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
        backgroundView.layer.shadowPath = UIBezierPath(roundedRect: backgroundView.bounds,
                                                       cornerRadius: backgroundView.layer.cornerRadius).cgPath
        backgroundView.layer.shadowColor = UIColor.black.cgColor            // 그림자 색상
        backgroundView.layer.shadowOpacity = 0.4                            // 그림자 투명도
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)     // 그림자의 위치
        backgroundView.layer.shadowRadius = 6                               // 그림자의 반경
    }
    
    
    func setGoToTodoButton() {
        stackView.isUserInteractionEnabled = true // 이제 subview로 이벤트를 전달함
        stackView.addSubview(goToTodoButton) // 버튼이 이벤트를 받음
    }
    
    
    func setTodayDateLabel() {
        todayDateLabel.text = selectedDate?.toString()
    }
    
    
    func setDateTableView() {
        dateTableView.delegate = self
        dateTableView.dataSource = self
        dateTableView.rowHeight = 60
    }
    
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    // 바깥쪽 영역 터치 시 호출될 메서드
    @objc func handleOutsideTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: self.view)
        
        if backgroundView.frame.contains(tapLocation) {
            return
        }
        
        // BackgroundView 이외의 영역을 탭한 경우에는 화면을 닫습니다.
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func goToButtonTapped(_ sender: UIButton) {
        //화면전환버튼
        guard let nextViewController = self.storyboard?.instantiateViewController(identifier: "ViewController") else {return}
        nextViewController.modalTransitionStyle = .coverVertical
        self.present(nextViewController, animated: true)
        
    }
}
extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedDate = selectedDate else { return 0 }
        return dataManager.getTodoListCoreData(selectedDate.toString()).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateToDoCell", for: indexPath) as! DateToDoCell
        
        guard let todoData = todoData else { return cell }
        cell.toDoData = todoData[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
    }
}
