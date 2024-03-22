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
    
    var selectedDate: DateComponents? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCalendar()
        createCalendar()
        reloadDateView(date: Date())
    }
    
    fileprivate func setCalendar() {
        dateView.delegate = self
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        dateView.selectionBehavior = dateSelection
    }
    
    func createCalendar() {
        dateView.calendar = .current
        dateView.locale = .current
        dateView.fontDesign = .rounded
        dateView.delegate = self
        dateView.layer.cornerRadius = 15
        view.addSubview(dateView)
        
        NSLayoutConstraint.activate([
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dateView.heightAnchor.constraint(equalToConstant: 500),
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    
    func reloadDateView(date: Date?) {
        if date == nil { return }
        let calendar = Calendar.current
        dateView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let selectedDate = selectedDate, selectedDate == dateComponents {
            return .customView {
                let label = UILabel()
                label.text = "🩵"
                label.textAlignment = .center
                return label
            }
        }
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        selectedDate = dateComponents
        reloadDateView(date: Calendar.current.date(from: dateComponents!))
    }
    
    
}
