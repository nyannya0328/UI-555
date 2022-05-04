//
//  DynamicFileterdView.swift
//  UI-555
//
//  Created by nyannyan0328 on 2022/05/04.
//

import SwiftUI
import CoreData

struct DynamicFileterdView<Content : View,T>: View  where T : NSManagedObject {
    
    @FetchRequest var request : FetchedResults<T>
    let content : (T) -> Content
    
    init(currentTab : String,@ViewBuilder content : @escaping(T) -> Content) {
    
       
        
        let calendar = Calendar.current
        var predicate : NSPredicate!
        
        if currentTab == "Today"{
            
            let today = calendar.startOfDay(for: Date())
            
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            let filetekey = "dedline"
            
            
            predicate = NSPredicate(format:"\(filetekey) >= %@ AND \(filetekey) < %@ AND isCompleted == %i",argumentArray:[today,tomorrow,0])
            
            
        }
        else if currentTab == "UpComing"{
            
            
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            
            let tomorrow = Date.distantFuture
            
            let filetekey = "dedline"
            
            
            
            predicate = NSPredicate(format:"\(filetekey) >= %@ AND \(filetekey) < %@ AND isCompleted == %i",argumentArray:[today,tomorrow,0])
            
            
            
        }
        else if currentTab == "Failed"{
            
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            
            let filetekey = "dedline"
            
            
            predicate = NSPredicate(format:"\(filetekey) >= %@ AND \(filetekey) < %@ AND isCompleted == %i",argumentArray:[past,today,0])
            
            
            
        }
        else{
            
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])
        }
        
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.dedline, ascending: false)], predicate:predicate)
        self.content = content
        
        
        
    }
    var body: some View {
        Group{
            
            if request.isEmpty{
                
                Text("No Tasks Fouund")
                    .font(.system(size: 30, weight: .bold))
                    .offset(y: 100)
            }
            else{
                
                ForEach(request,id:\.objectID){objcet in
                    
                    content(objcet)
                }
            }
        }
    }
}

