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
    
    
    // MARK: - (Get) 날짜에 따른 TodoDate 배열
    
    func getTodoListCoreData(_ Date: String) -> [TodoData] {
        
        var todoListDataArray: [TodoData] = []
        
        guard let todoListDataArray = fetchDataByDate()[Date] as? [TodoData] else {
            return todoListDataArray
        }
        
        return todoListDataArray
    }
    

    // MARK: - 데이터를 날짜별로 정리하는 함수
    
    func fetchDataByDate() -> [String: [NSManagedObject]] {
        
        if let context = context {
            
            // NSFetchRequest 생성
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.modelName)
            
            // 날짜별로 정렬하기 위한 속성 추가
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            
            do {
                // 데이터 가져오기
                let fetchedResults = try context.fetch(fetchRequest) as! [NSManagedObject]
                
                // 날짜별로 데이터 정리
                var dataByDate: [String: [NSManagedObject]] = [:]
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yy.MM.dd"
                
                for data in fetchedResults {
                    if let date = data.value(forKey: "date") as? Date {
                        let dateString = dateFormatter.string(from: date)
                        if dataByDate[dateString] == nil {
                            dataByDate[dateString] = []
                        }
                        dataByDate[dateString]?.append(data)
                    }
                }
                
                return dataByDate
                
            } catch {
                print("Error fetching data: \(error)")
            }
        }
        
        return [:]
    }
    
    
    // MARK: - (save) 새로운 데이터 저장
    
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
    
    
    
    // MARK: - (delete) 데이터 삭제
    
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
    
    
    // MARK: - Data 반환 함수
    
    func fetchManagedObject(_ withId: TodoData) -> NSManagedObject? {
        
        guard let listDataId = withId.id else {
            print("id를 불러오는 과정에서 오류가 발생하였습니다.")
            return nil
        }
        
        if let context = context {
            
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)

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
    
    
   // MARK: - (Update) 제목 수정
    
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
    
    
    // MARK: - (Update) 우선순위 수정
    
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
    
    
    // MARK: - (Update) 체크 수정
    
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
