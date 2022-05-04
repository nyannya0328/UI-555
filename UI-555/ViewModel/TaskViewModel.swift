//
//  TaskViewModel.swift
//  UI-555
//
//  Created by nyannyan0328 on 2022/05/04.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    
    @Published var currentTab : String = "Today"
    @Published var taskColor : String = "Yellow"
    @Published var openEditTask : Bool = false
    @Published var taskTitle : String = ""
    @Published var taskDedline : Date = Date()
    @Published var taskType : String = "Basic"
    
    
    @Published var editTask : Task?
    
    @Published var showPicker : Bool = false
    
    func addTask(context : NSManagedObjectContext) -> Bool{
        
        
        var task : Task!
        
        if let editTask = editTask {
            
            task = editTask
        }
        else{
            
            task = Task(context: context)
        }
        task.type = taskType
        task.title = taskTitle
        task.dedline = taskDedline
        task.color = taskColor
        task.isCompleted = false
        
        
        if let _ = try? context.save(){
            
            return true
        }
        
        return false
        
        
        
    }
  
    func restTaskDate(){
        
        taskType = "Basic"
        taskTitle = ""
        taskColor = "Yellow"
        taskDedline = Date()
        editTask = nil
        
        
    }
    
    func setUpTask(){
        
        if let editTask = editTask {
            
            taskType = editTask.type ?? "Basic"
            taskTitle = editTask.title ?? ""
            taskColor = editTask.color ?? "Yellow"
            taskDedline = editTask.dedline ?? Date()
        }
    }
}
