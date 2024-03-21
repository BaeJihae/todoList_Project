//
//  TodoTableViewCell.swift
//  todoList_
//
//  Created by 배지해 on 3/18/24.
//

import UIKit

extension String {
    // 취소선 그리기
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    // 취소선 없애기
    func removeStrikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0 , range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todoText: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    // 모델
    let dataManager = ListDataManager.shared
    
    var buttonAction: (() -> Void)?
    
    // ToDoData를 전달받을 변수 (전달 받으면 ==> 표시하는 메서드 실행) ⭐️
    var toDoData: TodoData? {
        didSet {
            configureUIwithData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // (투두) 데이터를 가지고 적절한 UI 표시하기
    func configureUIwithData() {
        todoText.text = toDoData?.title
        checkButton.isSelected = ((toDoData?.isChecked) ?? true )
    }
    
    // 체크 버튼 변경하기
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        buttonAction?()
        if sender.isSelected {
            sender.isSelected = false
            todoText.textColor = UIColor.black
            todoText.font = UIFont.systemFont(ofSize:18)
            todoText.attributedText = todoText.text?.removeStrikeThrough()
        }else {
            sender.isSelected = true
            todoText.textColor = UIColor.darkGray
            todoText.font = UIFont.systemFont(ofSize:18)
            todoText.attributedText = todoText.text?.strikeThrough()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
