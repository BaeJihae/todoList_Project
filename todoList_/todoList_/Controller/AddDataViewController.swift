//
//  AddDataViewController.swift
//  todoList_
//
//  Created by 배지해 on 3/22/24.
//

import UIKit

class AddDataViewController: UIViewController{
    
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    typealias CompletionHandler = () -> Void
    var completionHandler: CompletionHandler?

    
    let dataManager = ListDataManager.shared
    var todoData: TodoData?
    var selectedColor: Color = .color0
    
    
    // 피커뷰에 들어갈 색상
    let colors: [Color] = [.color0, .color1, .color2, .color3, .color4, .color5, .color6, .color7, .color8, .color9, .color10, .color11]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundView()
        setUI()
        setPickerView()
        if todoData != nil {
            setReviseView()
        }
        setTapGesture()
    }
    
    
    func setTapGesture() {
        // 터치 감지용 UITapGestureRecognizer 생성
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
        
        // ViewController의 view에 추가
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    // 바깥쪽 영역 터치 시 호출될 메서드
    @objc func handleOutsideTap() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func setUI() {
        titleTextField.keyboardType    = UIKeyboardType.default     // 텍스트 필드의 키보드 스타일 변경
        titleTextField.placeholder     = "Enter your task"          // 텍스트 필드의 가이드 역할
        titleTextField.borderStyle     = .roundedRect               // 텍스트 필드의 선 스타일
        titleTextField.clearButtonMode = .always                    // 텍스트 필드의 텍스트 지우는 버튼 설정
        titleTextField.returnKeyType   = .done                      // 텍스트 필드의 return 버튼 다른 키로 설정
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius  = 20
        cancelButton.layer.masksToBounds = true
         
        doneButton.translatesAutoresizingMaskIntoConstraints   = false
        doneButton.layer.cornerRadius    = 20
        doneButton.layer.masksToBounds   = true
    }
    
    
    func setBackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 15                              // 뷰의 모서리 둥글기 설정
        backgroundView.layer.shadowColor = UIColor.black.cgColor            // 그림자 색상
        backgroundView.layer.shadowOpacity = 0.4                            // 그림자 투명도
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)     // 그림자의 위치
        backgroundView.layer.shadowRadius = 6                               // 그림자의 반경
    }
    
    
    func setReviseView() {
        mainLabel.text      = "Edit To Do"
        titleTextField.text = todoData?.title
        datePickerView.date = todoData?.date ?? Date()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        guard let text = titleTextField.text else { return }
        let date = datePickerView.date
        let color = selectedColor
        
        if text == "" {
            
            // 텍스트가 입력되지 않았을 때 경고 얼럿창 보여주기
            let alert = UIAlertController(title: "Error",
                                          message: "todo title이 입력되지 않았습니다.",
                                          preferredStyle: .alert)
            let ok    = UIAlertAction(title: "OK",
                                      style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
            
        }else {
            if todoData != nil {
                guard let todoData = todoData else { return }
                dataManager.updateTodoListData(todoTitle: text, 
                                               todoDate: date,
                                               todoColor: Int16(color.rawValue),
                                               todoDataId: todoData) {
                    self.saveData()
                }
            }else{
                dataManager.saveTodoListData(todoTitle: text, 
                                             todoDate: date,
                                             todoColor: Int16(color.rawValue)) {
                    self.saveData()
                }
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    // 데이터 저장이 완료된 후 호출되는 메서드
    func saveData() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DataSaved"), object: nil)
    }
    
}


// MARK: - PickerView 구현

extension AddDataViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(0, inComponent: 0, animated: false)
        
        colorView.backgroundColor = selectedColor.backgoundColor
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        // 커스텀 뷰 생성
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 40))
        
        // 동그란 색상 뷰 생성
        let colorView = UIView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        colorView.backgroundColor = colors[row].backgoundColor
        colorView.layer.cornerRadius = 10
        customView.addSubview(colorView)
        
        // 텍스트 레이블 생성
        let label = UILabel(frame: CGRect(x: 40, y: 0, width: pickerView.bounds.width - 50, height: 40))
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = colors[row].description
        customView.addSubview(label)
        
        return customView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColor = colors[row]
        colorView.backgroundColor = selectedColor.backgoundColor
    }
}
