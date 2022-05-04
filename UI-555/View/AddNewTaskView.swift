//
//  AddNewTaskView.swift
//  UI-555
//
//  Created by nyannyan0328 on 2022/05/04.
//

import SwiftUI

struct AddNewTaskView: View {
    @EnvironmentObject var model : TaskViewModel
    @Namespace var animation
    @Environment(\.self) var env
    var body: some View {
        VStack{
            
            Text("Edit Task")
                .font(.title.weight(.semibold))
                .foregroundColor(.black)
                .lCenter()
                .overlay(alignment: .leading) {
                    
                    Button {
                        
                        env.dismiss()
                    } label: {
                        
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }

                }
                .overlay(alignment: .trailing) {
                    Button {
                        
                        if let editTask = model.editTask{
                            
                            env.managedObjectContext.delete(editTask)
                            try? env.managedObjectContext.save()
                            env.dismiss()
                            
                            
                        }
                    } label: {
                    
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                    .opacity(model.editTask == nil ? 0 : 1)

                    
                }
            
            
            VStack(alignment: .leading, spacing: 15) {
                
                
                
                
                Text("Task Color")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.gray)
                
                
                let colors : [String] = ["Yellow","Green","Blue","Purple","Red","Orange"]
                
                
                HStack{
                    
                    ForEach(colors,id:\.self){color in
                         
                        
                        Circle()
                            .fill(Color(color))
                            .frame(width: 30, height: 30)
                            .background{
                                
                                if model.taskColor == color{
                                    Circle()
                                        .strokeBorder(.gray)
                                        .padding(-3)
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                
                                model.taskColor = color
                            }
                    }
                }
                .padding(.top,10)
                
                
            }
            .lLeading()
            .padding(.top,30)
            
            Divider()
                .padding(.vertical)
            
            
            
            VStack(alignment: .leading, spacing: 15) {
                
                
                
                
                Text("Task Dedline")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.gray)
                
                
            
               
                    
                    
                    Text(model.taskDedline.formatted(date: .abbreviated, time: .omitted) + " , " + model.taskDedline.formatted(date: .omitted, time: .standard))
                    
                        .font(.title3.weight(.black))
                    
                 
                    
                    
                
                
                
                
             
                
            }
            .lLeading()
            .overlay(alignment: .bottomTrailing) {
                
                Button {
                    
                    model.showPicker.toggle()
                    
            
                    
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }

            }
          
            
            Divider()
            
            VStack(alignment: .leading, spacing: 15) {
                
                
                
                
                Text("Task Tile")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.gray)
                
                
            
               
                    
                    
                TextField("", text: $model.taskTitle)
                    
                       
                    
                
            }
            .padding(.vertical,15)
            
            Divider()
            
            
            VStack(alignment: .leading, spacing: 15) {
                
                let taskTypes: [String] = ["Basic","Urgent","Important"]
                
                
                Text("Task Type")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.gray)
                
                
                HStack(spacing:15){
                    
                    ForEach(taskTypes,id:\.self){type in
                        
                        
                        Text(type)
                            .font(.title3.weight(.light))
                            .lCenter()
                            .foregroundColor(model.taskType == type ? .white : .black)
                            .padding(.vertical,8)
                            .padding(.horizontal)
                            .background{
                                
                                if model.taskType == type{
                                    
                                    Capsule()
                                        .fill(.black)
                                        .matchedGeometryEffect(id: "TASKTYPE", in: animation)
                                }
                                else{
                                    
                                    Capsule()
                                        .strokeBorder(.gray)
                                }
                            }
                            .contentShape(Capsule())
                            .onTapGesture {
                                
                                withAnimation{
                                    
                                    model.taskType = type
                                }
                            }
                        
                        
                    }
                    
                }
                
            
               
                    
                    
             
                
            }
            .padding(.top)
            .lLeading()
            
            
            Divider()
                .padding(.vertical)
        
                
            Button {
                
                if model.addTask(context: env.managedObjectContext){
                    
                    env.dismiss()
                }
                
            } label: {
                
                Text("Save Task")
                    .font(.title2)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 5, y: 5)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: -5, y: -5)
                    .padding(.vertical,13)
                    .lCenter()
                    .background(Capsule().fill(.white))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                
            }
            .maxBottom()

            
            
            
            
        }
        .padding()
        .maxTop()
        .overlay {
            
            ZStack{
                
                if model.showPicker{
                    
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            model.showPicker = false
                        }
                    
                    DatePicker("", selection: $model.taskDedline,in: Date.now...Date.distantFuture)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
            }
            .animation(.easeInOut, value: model.showPicker)
        }
    }
}

struct AddNewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTaskView()
            .environmentObject(TaskViewModel())
        
    }
}
