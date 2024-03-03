//
//  ViewController.swift
//  Modern-Concurrency-Demo
//
//  Created by Mohamed Abd Elhakam on 26/02/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        LoadData { result in
            switch result {
            case .success(let todos):
                print(todos)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func LoadData(completionHandler:@escaping(Result<[Todo], Error>)-> Void){
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else{
                completionHandler(.failure(ApiError.noData))
                return
            }
            do{
                let todos = try JSONDecoder().decode([Todo].self , from: data)
                completionHandler(.success(todos))
//                completionHandler(.failure(ApiError.noData))  الكومنت رقم ١
                
            }catch{
                completionHandler(.failure(ApiError.noData))
            }
        }
        .resume()
        
    }
}




//MARK: Mistakes and Notes

//MARK: 1 default way
// ١: المشكلة ان الشكل ده بياخد سطور كتيرة عشان نكتبة وهنا احنا بنتكلم عن الطريقة العادية

//MARK: 2 Result way
// ٢: من كام سنة اخترعت "اينم" اسمه "ريزالت" بقي فيه "تو كاس" الاولي "ساقسيس" والتانية "فالير" ،ده خلي "الكود" بقي "مور ريدابل" وخلي "التو كاس " يا "ساقسيس" يا "فالير" ومستحيل يكونوا الاتنين مع بعض

//MARK: 3 question
// ٣: هل ممكن يكونوا الاتنين مع بعض
// الاجابة: ممكن ايوا وممكن لآ

//MARK: result_1
//لآ: لآن دة المفروض ما يحصلش
//MARK: result_2 and comment
//  ايوا: لان بكل بساطة لو عملت "الكومنت رقم١" هيشتغل تمام من غير اي "ايرور" وكده دخل "التو كاس" مع بعض وكده حرفيا مفيش حاجة تقدر توقف انك تعمل "الكومبليشن" "مالتابل تايمز" ي

//MARK: 4 experience note about completionHandler
// ٤: "الكومبليشن" حلوة وكل حاجة بس فيها "ايرور" كتير لو انت مش فاهم

//MARK: comment
// يعني مثلا لو معملتش " الكومبليشن" بتاعت "الساقسيس" اللي هي بعد ما يعمل "ديكود للداتا" وبالتالي "الفانكشن" مش هتعمل "اكستيود" طول حياتها يعني مثلا لو فيه "انديكاتور" عمره ما هيقف لان "الفانكشن" مش هتعمل "اكستيود" ومفيش اي "ايرور" هيحصل

