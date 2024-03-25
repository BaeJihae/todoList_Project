//
//  TodoTableViewCell.swift
//  todoList_
//
//  Created by 배지해 on 3/18/24.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todoText: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    let dataManager = ListDataManager.shared
    var buttonAction: (() -> Void)?
    
    // ToDoData를 전달받을 변수
    var toDoData: TodoData? {
        didSet {
            configureUIwithData()
        }
    }
    
    // TodoData로 UI 표시
    func configureUIwithData() {
        todoText.text = toDoData?.title
        setTableViewCell()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Cell 간격 조정
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setView() {
        // Cell 둥근 모서리 적용(값이 커질수록 완만)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = 30
        contentView.backgroundColor = UIColor(red: 217, green: 221, blue: 217, alpha: 0)
    }
    
    func setTableViewCell() {
        if let ischecked = toDoData?.isChecked {
            if ischecked == true {
                checkButton.isSelected = true
                todoText.textColor = UIColor.darkGray
                todoText.attributedText = todoText.text?.strikeThrough()
            }else {
                checkButton.isSelected = false
                todoText.textColor = UIColor.black
                todoText.attributedText = todoText.text?.removeStrikeThrough()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: - CheckButton 구현
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        
        buttonAction?()
        
        // 체크 -> 미체크
        if sender.isSelected {
            sender.isSelected = false
            todoText.textColor = UIColor.black
            todoText.attributedText = todoText.text?.removeStrikeThrough()
        }else { // 미체크 -> 체크
            sender.isSelected = true
            todoText.textColor = UIColor.darkGray
            todoText.attributedText = todoText.text?.strikeThrough()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

// MARK: - strike 함수

extension String {
    
    // 취소선 그리기
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    // 취소선 없애기
    func removeStrikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 0 ,
                                     range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
