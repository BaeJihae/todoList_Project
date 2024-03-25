//
//  AddDataViewController.swift
//  todoList_
//
//  Created by 배지해 on 3/22/24.
//

import UIKit

class AddDataViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // Closure 타입 정의
    typealias CompletionHandler = () -> Void
    // Closure 프로퍼티 선언
    var completionHandler: CompletionHandler?

    let dataManager = ListDataManager.shared
    var todoData: TodoData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundView()
        setUI()
        if todoData != nil {
            setReviseView()
        }
    }
    
    func setUI() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        // 텍스트 필드의 키보드 스타일 변경
        titleTextField.keyboardType = UIKeyboardType.default
        // 텍스트 필드의 가이드 역할
        titleTextField.placeholder = "Enter your task"
        // 텍스트 필드의 선 스타일
        titleTextField.borderStyle = .roundedRect
        // 텍스트 필드의 텍스트 지우는 버튼 설정
        titleTextField.clearButtonMode = .always
        // 텍스트 필드의 return 버튼 다른 키로 설정
        titleTextField.returnKeyType = .done
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 20
        cancelButton.layer.masksToBounds = true
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.layer.cornerRadius = 20
        doneButton.layer.masksToBounds = true
    }
    
    
    func setBackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 15 // 뷰의 모서리 둥글기 설정
        backgroundView.layer.shadowColor = UIColor.black.cgColor // 그림자 색상
        backgroundView.layer.shadowOpacity = 0.4 // 그림자 투명도
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 2) // 그림자의 위치
        backgroundView.layer.shadowRadius = 6 // 그림자의 반경
    }
    
    func setReviseView() {
        print(#function)
        mainLabel.text = "Edit Todo"
        titleTextField.text = todoData?.title
        datePickerView.date = todoData?.date ?? Date()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        guard let text = titleTextField.text else { return }
        let date = datePickerView.date
        
        if text != "" {
            if todoData != nil {
                if let todoData = todoData {
                    dataManager.updateTodoListData(todoTitle: text, todoDate: date, todoDataId: todoData) {
                        print("데이터 업데이트 완료")
                        self.saveData()
                    }
                }
            }else{
                dataManager.saveTodoListData(todoTitle: text, todoDate: date) {
                    print("새로운 데이터 저장 완료")
                    self.saveData()
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // 데이터 저장이 완료된 후 호출되는 메서드
    func saveData() {
        // 데이터 저장 완료를 알리는 알림 발송
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DataSaved"), object: nil)
    }
}
