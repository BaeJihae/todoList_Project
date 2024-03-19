//
//  ListDataManager.swift
//  todoList_
//
//  Created by 배지해 on 3/19/24.
//

import UIKit

class ListDataManager {
    private var todoListDataArray: [TodoData] = []
    
    func makeListData() {
        todoListDataArray = [
            TodoData(id: 0, title: "오이사기", isChecked: false),
            TodoData(id: 1, title: "헤드셋고치기", isChecked: false),
            TodoData(id: 2, title: "책사기", isChecked: false),
            TodoData(id: 3, title: "영양제 먹기", isChecked: false),
            TodoData(id: 4, title: "병원 방문", isChecked: false),
            TodoData(id: 5, title: "물 2L 마시기", isChecked: false),
            TodoData(id: 6, title: "강아지 산책 시키기", isChecked: false),
            TodoData(id: 7, title: "자기소개 하기", isChecked: false),
            TodoData(id: 8, title: "iOS 강의듣기", isChecked: false),
            TodoData(id: 9, title: "TIL 작성하기", isChecked: false),
            TodoData(id: 10, title: "알고리즘 문제 풀기", isChecked: false),
            TodoData(id: 11, title: "열공하기", isChecked: false),
        ]
    }
    
    func getTodoListData() -> [TodoData] {
        return todoListDataArray
    }
    
    func updateTodoListData(_ title: String) {
        let todo = TodoData(id: todoListDataArray.count + 1, title: title, isChecked: false)
        todoListDataArray.append(todo)
    }
    
    func deleteTodoListData(_ row: Int) {
        todoListDataArray.remove(at: row)
    }
}
