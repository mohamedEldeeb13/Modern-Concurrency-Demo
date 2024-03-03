//
//  fourthViewController.swift
//  Modern-Concurrency-Demo
//
//  Created by Mohamed Abd Elhakam on 27/02/2024.
//

import UIKit
import Combine
struct Todo : Decodable {
    let userId : Int
    let id : Int
    let title : String
    let completed : Bool
}

enum ApiError : Error {
    case noData
}


class fourthViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
  
    let viewModel1 = viewModel_1()
    let viewModel2 = viewModel_2()
    private var subscription = Set<AnyCancellable>()
//    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: this functon for load more todos concurrency
        viewModel2.loadDatas()
        
        
    //MARK: this functon for load only one todo
//        viewModel1.loadData()
//        viewModel1.$todos
////            .receive(on: DispatchQueue.main) //MARK: solution 2
//            .sink { [weak self] todo in
//            guard let self = self else{ return }
////            DispatchQueue.main.async { //MARK: solution 1
//                self.label.text = todo?.title
////            }
//        }
//        .store(in: &subscription)
        
        
        
        
        //MARK: first simple functions for explain how to call async function
//        Task{
//            let result = await multiply(a: 4, b: 5)
//            print(result)
//        }
    }
    
//    func sum(a: Int , b: Int) async -> Int {
//        return a + b
//    }
//    func multiply(a:Int , b:Int) async -> Int {
//        let c = await sum(a: 5, b: 5)
//        return a*c
//    }

}



//MARK: this functon for load more todos concurrency

class viewModel_2 {
    @Published private(set) var todoss : [Todo] = []
    func loadDatas(){
        Task{
            do{
                //MARK: second way
                async let firstTodos = try loadS(id: 1)
                async let secondTodos = try loadS(id: 2)
                async let thiredTodos = try loadS(id: 3)
                async let fourthTodos = try loadS(id: 4)
                
                let result = try await [firstTodos, secondTodos ,thiredTodos ,fourthTodos]
//                let result try await (firstTodos,secondTodos,thiredTodos,fourthTodos) //MARK: comment 4
                print(result)
                //MARK: first way
//                let firstTodos = try await loadS(id: 1)
//                let secondTodos = try await loadS(id: 2)
//                let thiredTodos = try await loadS(id: 3)
//                let fourthTodos = try await loadS(id: 4)
//                todoss.append(contentsOf: [firstTodos,secondTodos,thiredTodos,fourthTodos])
                doSomthingWithTodos()
            }catch {
                debugPrint(error)
            }
        }
    }
    
    private func loadS(id : Int) async throws -> Todo {
//        do{ //MARK: comment 5
            let (data,_) = try await URLSession.shared.data(from: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)
            print(data)
            
            return try JSONDecoder().decode(Todo.self ,from: data)
//        }catch{
//            return nil
//        }
        
    }
    private func doSomthingWithTodos(){
        print(todoss)
    }
}


//MARK: this functon for load only one todo
class viewModel_1 {
    @Published private(set) var todos : Todo?
    
    func loadData(){
        Task{
            do {
              let todo = try await Load(id: 1)
                await MainActor.run {
                    todos = todo
                }
                doSomthingWithTodo()
            }catch {
                debugPrint(error)
            }
        }
    }
    private func Load(id: Int) async throws -> Todo {
        
        let (data,_) = try await URLSession.shared.data(from: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)
        print(data)
        
        return try JSONDecoder().decode(Todo.self ,from: data)
    }
    private func doSomthingWithTodo(){
        print(todos)
    }
}


extension URLSession {
    func data(from url : URL) async throws ->(Data , URLResponse){
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let data = data ,
                    let response = response
                else{
                    continuation.resume(throwing: ApiError.noData)
                    return
                }
                continuation.resume(returning: (data,response))
                return
            }
            .resume()
        }
    }
}



//MARK: Mistakes and Notes

//MARK: first func
//وازاي نستخدمها asyc_await عشان نعرف بيها يعني اي  simple function ده sum



//MARK: first viewModel
//dispatch call on main thread هو اللي مسؤل انه يعمل main actors

//load for only one todo مسؤله عن انها تعمل  fuction ده فيه  viewModel_1
// i have amisrtake for reload title to label but resolve it by three way
// first way ---> in comment 1
// second way ---> in comment 2
// thired way ---> in comment 3 and this way it is conccurency way

//MARK: second viewModel

//load for four todos concurrency but show as sequentail مسؤله عن انها تعمل  fuction ده فيه  viewModel_2

// async let : store space in memory but not excute it until await


//MARK: important notes

//MARK: note 1
// if want to do multiple function and each function have diffrent result like i have load func and post func and comment func call of three functions not diffrent like this up function ,
//i have solve this problem by //MARK: comment4
// and can remove try from async let

//MARK: note 2
// but each functon depend on another function , if function have error the result of all function = nil  /like load func = nil , post func = data , comment func = data ---> result = nil
// if i want to make fuction not depend on other function make //MARK: comment 5
// comment 5 : put function in do_catch and remove throws in function , this make if function is failure not effect in another function   / like load func = nil , post func = data , comment func = data --> result of load = nil , post = data , comment = data
