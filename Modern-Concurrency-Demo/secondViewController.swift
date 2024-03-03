//
//  secondViewController.swift
//  Modern-Concurrency-Demo
//
//  Created by Mohamed Abd Elhakam on 27/02/2024.
//

import UIKit

class secondViewController: UIViewController {
    
    //MARK: create network calls depend for each other using completionHandler     "الطريقة العادية"

    override func viewDidLoad() {
        super.viewDidLoad()

        
        downloadImage(url: URL(string: "")!) { [weak self] result in
            guard let self = self else{return}
            switch result {
            case .success(let data):
                self.decodeImage(from: data) { result in
                    switch result {
                    case .success(let image):
                        self.processImage(image: image) { rersult in
                            switch result {
                            case .success(let processImage):
                                self.saveImage(image: processImage) { result in
                                    switch result {
                                    case .success(let url):
                                        print(url)
                                    case .failure(let error):
                                        debugPrint(error)
                                    }
                                }
                            case .failure(let error):
                                debugPrint(error)
                            }
                        }
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
       
    }// end of viewDidLoad
    
    
    
    func downloadImage(url : URL, completionHandler: @escaping (Result<Data , Error>)->Void){
        
    }
    
    func decodeImage(from image : Data , completionHandler: @escaping(Result<UIImage , Error>)->Void){
        
    }
    
    func processImage(image : UIImage ,completionHandler: @escaping(Result<UIImage , Error>)->Void){
        
    }
    func saveImage(image : UIImage ,completionHandler: @escaping(Result<URL , Error>)->Void){
        
    }

}


//MARK: Mistakes and Notes

                            //MARK: explain for problem
// لو عندنا اكتر من "فانكشن" مسؤلين علي انهم يعملوا حاجة معينة ومعتمدين علي بعض

                            //MARK: rules of each functions
//  فانكشن دقم ١ : هتعمل تنزيل للصورة من الويب
// فانكشن رقم ٢: هتعمل للصورة "ديكود" الخ
// فانكشن رقم ٣: هتعمل للصورة تعديل في الحجم
// فانكشن رقم ٤: هتعمل حفظ للصورة

                            //MARK: explain how functions dependes of each other
// ف الكود ده معتمد علي بعضه يعني عشان اعمل حفظ للصورة عاوز اعمل قبلها عملية لتغير المساحة وعشان اعمل العملية ده لازم اعمل ديكود للصورة الاول وعشان اعمل ديكود لازم انزل الصورة الاول من الويب

                            //MARK: mistake in shape in viewDidLoad
// الشكل اللي طلع ده واحنا بنعمل "كال ل الفانكشنز في الفيو ديد لود" بقي الكود "مش ريدابل" وشكل الهرم اللي اتكون ده مشكلة في حد ذاته


//MARK: ازاي اكتب بقي بطريقة "ريدابل" كده ومنظمة في الحل

                            // MARK: احنا عاوزين نخلي الشكل يكون كده
// let data = downloadImage()
// let image = decode(data: data)
// let processedImage = process(image: image)
// let filePath = save(image: processedImage)


                            //MARK: هل ممكن نوصل للشكل ده ---> الاجابة: ايوا


//MARK: solution ways

                            //MARK: Modern conccurncy
// ١: موضوع البلاي ليست وهي "الموديرن كونكارنسي" بس مش هنستخدمه دلوقت

                            //MARK: dispatch Group
// ٢: "الديسباتش جروب" بس الفكرة ان "الديسباتش جروب" مش مهمته هو مهمته انه يعمل حاجات "باراريل" ورا بعض مش مع بعض في نفس الوقت بمعني "كونكارنسي" الخ

                            //MARK: dispatch semaphore
// ٣: "الديسباتش سيمافور" وده هستخدمها عشان اكتب الكود بطريقة "سينكرونس" مش "اسنكرونس" والطريقة ده اللي هنشوفها في الصفحة رقم ٣ اللي اسمها
// thired viewController
