//
//  CalendarViewController.swift
//  todoList_
//
//  Created by 배지해 on 3/22/24.
//

import UIKit

class CalendarViewController: UIViewController, UICalendarViewDelegate {

    
    lazy var dateView: UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.wantsDateDecorations = true
        return calendarView
    }()
    
    
    var selectedDate: DateComponents = Calendar.current.dateComponents([.day, .month, .year], from: Date())
    
    var dataManager = ListDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCalendar()
        createCalendar()
    }
    
    
    fileprivate func setCalendar() {
        dateView.delegate = self
        dateView.fontDesign = .rounded // 달력의 폰트 디자인
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        dateView.selectionBehavior = dateSelection
    }
    
    
    func createCalendar() {
        dateView.calendar = .current
        dateView.locale = .current
        dateView.layer.cornerRadius = 15
        view.addSubview(dateView)
        
        NSLayoutConstraint.activate([
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dateView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}


extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    
    
    // 선택한 날짜 클릭했을 때 다음 화면으로 date값을 넘겨주며 이동하기
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        guard let dateComponents = dateComponents else { return }
        
        // 선택한 날짜를 Date로 변환
        if let selectedDate = Calendar.current.date(from: dateComponents) {
            showToDoListViewController(with: selectedDate)
        } else {
            print("Failed to convert DateComponents to Date.")
        }
    }
    
    
    // ToDoListViewController로 이동
    func showToDoListViewController(with date: Date) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let toDoListViewController = storyboard.instantiateViewController( withIdentifier: "ToDoListViewController") as? ToDoListViewController else {
            return
        }
        
        // date 값 전달
        toDoListViewController.selectedDate = date
        
        // ToDoListViewController를 present하여 표시
        toDoListViewController.modalPresentationStyle = .overFullScreen
        toDoListViewController.modalTransitionStyle = .coverVertical
        present(toDoListViewController, animated: true, completion: nil)
    }
}
