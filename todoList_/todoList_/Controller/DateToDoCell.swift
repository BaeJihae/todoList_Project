//
//  DateToDoCell.swift
//  todoList_
//
//  Created by 배지해 on 3/26/24.
//

import UIKit

class DateToDoCell: UITableViewCell {

    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var isCheckedButton: UIButton!
    
    let dataManager = ListDataManager.shared
    var buttonAction: (() -> Void)?
    
    // ToDoData를 전달받을 변수
    var toDoData: TodoData? {
        didSet {
            configureUIwithData()
        }
    }
    
    func configureUIwithData() {
        todoLabel.text = toDoData?.title
        if let toDoData = toDoData {
            if let color = Color(rawValue: Int(toDoData.color)) {
                contentView.backgroundColor = color.backgoundColor
                contentView.layer.cornerRadius = 20
                contentView.layer.masksToBounds = true
            }
        }
        setTableViewCell()
    }
    
    func setTableViewCell() {
        if let ischecked = toDoData?.isChecked {
            if ischecked == true {
                isCheckedButton.isSelected = true
                todoLabel.textColor = UIColor.darkGray
                todoLabel.attributedText = todoLabel.text?.strikeThrough()
            }else {
                isCheckedButton.isSelected = false
                todoLabel.textColor = UIColor.black
                todoLabel.attributedText = todoLabel.text?.removeStrikeThrough()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
