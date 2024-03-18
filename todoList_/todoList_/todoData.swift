//
//  todoData.swift
//  todoList_
//
//  Created by 배지해 on 3/18/24.
//

struct TodoData {
    var id: Int?
    var title: String?
    var isChecked: Bool = false
    
    init(id: Int? = nil, title: String? = nil, isChecked: Bool) {
        self.id = id
        self.title = title
        self.isChecked = isChecked
    }
}
