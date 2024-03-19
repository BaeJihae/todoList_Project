//
//  TodoTableViewCell.swift
//  todoList_
//
//  Created by 배지해 on 3/18/24.
//

import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    func removeStrikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0 , range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
class TodoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var todoText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
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
