//
//  ContentView.swift
//  ToDoListApp
//
//  Created by macuser on 2023-09-20.
//

import SwiftUI

//model
struct ToDoItem {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var order: Int
}


struct ToDoItemView: View {
    var item: ToDoItem
    
    var body: some View {
        VStack {
            Text(item.title)
                .font(.headline)
            Text("Order: \(item.order)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(item.isCompleted ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
        .cornerRadius(8)
    }
}
class ToDoListViewModel: ObservableObject{
    @Published var items: [ToDoItem] = [
        ToDoItem(id:UUID(), title: "Task 1", isCompleted: true, order: 7),
        ToDoItem(id:UUID(), title: "Walk the dog", isCompleted: false, order: 3),
        ToDoItem(id:UUID(), title: "Groceries", isCompleted: true, order: 2),
        ToDoItem(id:UUID(), title: "Run", isCompleted: true, order: 4)]
    
    func AddItem(title:String){
        //??-> if items.last = null than give 0, than + 1 everything
        let order = (items.last?.order ?? 0) + 1
        let newItem = ToDoItem(id: UUID(), title: title, isCompleted: false, order: order)
        items.append(newItem)
    }
    
    func toggle(item: ToDoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
}
    
    struct ContentView: View {
        @ObservedObject var vm = ToDoListViewModel()
        @State var newTaskTitle = ""
        
        var sortedItems: [ToDoItem]{
            vm.items.sorted(by: {$0.order < $1.order})
        }
        
        var body: some View {
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(sortedItems, id: \.id) { item in
                            ToDoItemView(item: item)
                                .onTapGesture {
                                    vm.toggle(item: item)
                                }
                        }
                    }
                    .padding()
                }
                HStack{
                    TextField("New Task",text: $newTaskTitle, onCommit: {
                        
                    } )
                    Button("Save ToDo", action: {
                        vm.AddItem(title: newTaskTitle)
                        //clear
                        newTaskTitle = ""
                        
                    })
                }
            }
            .padding()
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

