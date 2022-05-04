//
//  Home.swift
//  UI-555
//
//  Created by nyannyan0328 on 2022/05/04.
//

import SwiftUI

struct Home: View {
    @StateObject var model : TaskViewModel = .init()
    @Namespace var animation
    @Environment(\.self) var env
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.dedline, ascending: false)], predicate: nil, animation: .easeInOut) var tasks : FetchedResults<Task>
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack{
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    
                    Text("Welcom Back")
                        .font(.callout.weight(.semibold))
                    
                    Text("Her's Update Today")
                        .font(.title.weight(.black))
                    
                }
              
                .lLeading()
                
                CustomSegnmentBar()
                    .padding(.top,15)
                
                
                TaskView()
                
                
            }
           
        }
        .padding()
        .overlay(alignment: .bottom) {
            
            
            Button {
                
                withAnimation{
                    
                    model.openEditTask.toggle()
                }
                
            } label: {
                
                Label {
                    Text("Add Task")
                } icon: {
                    Image(systemName: "plus.app.fill")
                    
                }
                .foregroundColor(.white)
                .padding(.vertical,13)
                .padding(.horizontal)
                .background(Capsule().fill(.black))

            }

        }
        .lCenter()
        .background{
            
            
            LinearGradient(colors: [
            
                .white.opacity(0.05),
                .white.opacity(0.4),
                .white.opacity(0.7),
                .white
            
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
        }
        .fullScreenCover(isPresented: $model.openEditTask) {
            
            model.restTaskDate()
        } content: {
            
            AddNewTaskView()
                .environmentObject(model)
            
        }

      
    }
    @ViewBuilder
    func TaskView()->some View{
        
        LazyVStack(spacing:20){
            DynamicFileterdView(currentTab: model.currentTab) { (task : Task) in
                
                
                TaskRowView(task: task)
            }
            
        }
    }
    
    @ViewBuilder
    func TaskRowView(task : Task)->some View{
        
        
        VStack(alignment: .leading, spacing: 13) {
            
            HStack{
                
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical,6)
                    .padding(.horizontal)
                    .background(
                    Capsule()
                        .fill(.white.opacity(0.5))
                    )
                
                Spacer()
                
                
                if !task.isCompleted && model.currentTab != "Failed"{
                    
                    
                    Button {
                        
                        model.editTask = task
                        model.openEditTask = true
                        model.setUpTask()
                        
                    } label: {
                        
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }

                    
                    
                    
                }
            }
            
            Text(task.title ?? "")
                .font(.title.bold())
                .foregroundColor(.black)
                .padding(.vertical,10)
            
            
            HStack{
                
                VStack(alignment: .leading, spacing: 13) {
                    
                    
                    Label {
                      
                        
                        Text((task.dedline ?? Date()).formatted(date: .long, time: .omitted))
                        
                        
                    } icon: {
                        
                        Image(systemName: "calendar")
                    
                            
                        
                      
                    }
                    .font(.caption)
                    
                    
                    Label {
                        
                        Text((task.dedline ?? Date()).formatted(date: .omitted, time: .shortened))
                        
                    } icon: {
                        
                        Image(systemName: "clock")
                        
                    }
                    .font(.caption)


                }
                
                
                .lLeading()
                
                if !task.isCompleted && model.currentTab != "Failed"{
                    
                    
                    Button {
                        
                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                        
                    } label: {
                        
                        Circle()
                            .strokeBorder(.black,lineWidth: 1)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }

                    
                    
                }
                
            }
            
        }
        .padding()
        .lCenter()
        .background{
            
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }
        
    }
    @ViewBuilder
    func CustomSegnmentBar()->some View{
        
        
        let tabs = ["Today","UpComing","Taks Done","Failed"]
        
        HStack(spacing:13){
            
            
            ForEach(tabs,id:\.self){tab in
                
                
                Text(tab)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(model.currentTab == tab ? .white : .black)
             
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background{
                        
                        if model.currentTab == tab{
                            
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                        
                       
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        
                        withAnimation{
                            model.currentTab = tab
                        }
                    }
            }
            
            
            
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
