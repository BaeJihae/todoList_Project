//
//  ListDataManager.swift
//  todoList_
//
//  Created by 배지해 on 3/19/24.
//

import UIKit
import CoreData

class ListDataManager {
    
    
    // 데이터 매니저
    static let shared = ListDataManager()
    private init() {}
    
    // 앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    // 임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    
    // 엔터티 이름 (코어 데이터에 저장된 객체)
    let modelName: String = "TodoData"
    
    // Date 인스턴스
    let now = Date()
    let formatter = DateFormatter()
    
    
    // priority 저장
    static var priority = 0
    
    
    
    // 데이터 가져오기
    func getTodoListCoreData() -> [TodoData] {
        
        // 데이터를 저장할 배열
        var todoListDataArray: [TodoData] = []
        
        // 임시 저장소 있는지 확인
        if let context = context {
            
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 정렬 순서를 정해서 요청서에 넘겨주기
            request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
            
            do {
                // 임시 저장소에서 요청서를 통해 데이터 가져오기 (fetch)
                if let fetchedTodoList = try context.fetch(request) as? [TodoData] {
                    todoListDataArray = fetchedTodoList
                }
            } catch {
                print("데이터를 가져오는 과정에서 에러가 발생하였습니다.")
            }
        }
        return todoListDataArray
    }
    
    
    
    // 데이터 저장하기
    func saveTodoListData(todoTitle: String?, completion: @escaping () -> Void){
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                if let todoData = NSManagedObject(entity: entity, insertInto: context) as? TodoData {
                    // 새로운 데이터의 요소
                    todoData.title = todoTitle
                    todoData.id = UUID()
                    todoData.isChecked = false
                    todoData.date = Date()
                    todoData.priority = Int64(ListDataManager.priority)
                    // 생성된 데이터의 개수 증가 ( 정렬 )
                    ListDataManager.priority += 1
                    appDelegate?.saveContext()
                }
            }
        }
        completion()
    }
    
    
    
    // 데이터 삭제하기
    func deleteTodoListData(data: TodoData, completion: @escaping () -> Void) {
        guard let listDataId = data.id else {
            print("id를 불러오는 과정에서 오류가 발생하였습니다.")
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "id = %@", listDataId as CVarArg)
            do {
                if let fetchedTodoList = try context.fetch(request) as? [TodoData] {
                    if let targetTodo = fetchedTodoList.first {
                        context.delete(targetTodo)
                        appDelegate?.saveContext()
                    }
                }
                completion()
            }catch let error as NSError {
                print("데이터를 삭제하는 과정에서 에러가 발생하였습니다. \(error), \(error.userInfo)")
                completion()
            }
        }
    }
    
    
    // 해당 Data를 반환하는 메서드
    func fetchManagedObject(_ withId: TodoData) -> NSManagedObject? {
        
        guard let listDataId = withId.id else {
            print("id를 불러오는 과정에서 오류가 발생하였습니다.")
            return nil
        }
        
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // id에 맞는 데이터 요청
            request.predicate = NSPredicate(format: "id = %@", listDataId as CVarArg)
            do {
                let result = try context.fetch(request)
                return result.first
            } catch let error as NSError {
                print("fetch되지 않았습니다. \(error), \(error.userInfo)")
                return nil
            }
        }
        return nil
    }
    
    
    // 데이터 title 수정 구현하기
    func updateTodoListData(_ todoTitle: String, _ todoDataId: TodoData) {
        
        // 수정할 title 내용
        let modifiedTitle = todoTitle
        
        guard let modifiedManagedObject = fetchManagedObject(todoDataId) else {
            print("Failed to fetch managed objects.")
            return
        }
        
        modifiedManagedObject.setValue(modifiedTitle, forKey: "title")
        
        // 변경 사항 저장
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            try appDelegate.persistentContainer.viewContext.save()
            print("Changes saved successfully.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    
    // 데이터 우선순위 업데이트
    func updatePriorityCoreData(moveRowAt firstDataId: TodoData, to secondDataId: TodoData) {

        // 각 데이터의 변경할 내용
        let firstDataNewValue = secondDataId.priority
        let secondDataNewValue = firstDataId.priority

        // 변경할 데이터 가져오기
        guard let firstManagedObject = fetchManagedObject(firstDataId) ,
              let secondManagedObject = fetchManagedObject(secondDataId) else {
            print("Failed to fetch managed objects.")
            return
        }

        // 가져온 데이터의 속성 업데이트
        firstManagedObject.setValue(firstDataNewValue, forKey: "priority")
        secondManagedObject.setValue(secondDataNewValue, forKey: "priority")

        // 변경 사항 저장
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            try appDelegate.persistentContainer.viewContext.save()
            print("Changes saved successfully.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // 데이터 checked 업데이트
    func updateCheckedCoreData(moveRowAt todoDataId: TodoData) {

        // 각 데이터의 변경할 내용
        let ischecked = !todoDataId.isChecked

        // 변경할 데이터 가져오기
        guard let todoManagedObject = fetchManagedObject(todoDataId) else {
            print("Failed to fetch managed objects.")
            return
        }

        // 가져온 데이터의 속성 업데이트
        todoManagedObject.setValue(ischecked, forKey: "isChecked")

        // 변경 사항 저장
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            try appDelegate.persistentContainer.viewContext.save()
            print("Changes saved successfully.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
