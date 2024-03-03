//
//  thiredViewController.swift
//  Modern-Concurrency-Demo
//
//  Created by Mohamed Abd Elhakam on 27/02/2024.
//

import UIKit

class thiredViewController: UIViewController {
    
    //MARK: how to use dispatch semaphore to solve problem

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {  //MARK: الكومنت  رقم ١
            do {
                let data = try self.downloadImage(url: URL(string: "https://www.google.com")!)
                let image = try self.decodeImage(from: data)
                let processImage = try self.processImage(image: image)
                print(processImage)
            }catch {
                print(error)
            }
        }
    }
    
    func downloadImage(url : URL) throws -> Data{
        let semaphore = DispatchSemaphore(value: 0)
        var data : Data?
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)){
            data = Data()
            semaphore.signal()
        }
//        DispatchQueue.global().async {
//            data = Data()
//            semaphore.signal()
//        }
        _ = semaphore.wait(timeout: .distantFuture)
        if let data = data {
            return data
        }
        throw ApiError.noData
    }
    
    func decodeImage(from data: Data) throws -> UIImage{
        let semaphore = DispatchSemaphore(value: 0)
        var image : UIImage?
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)){
            image = UIImage()
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        if let image = image {
            return image
        }
        throw ApiError.noData
    }
    
    func processImage(image : UIImage) throws -> UIImage{
        let semaphore = DispatchSemaphore(value: 0)
        var processImage : UIImage?
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)){
            processImage = image
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        if let image = processImage {
            return image
        }
        throw ApiError.noData
        
    }
    func saveImage(image : UIImage) throws -> URL{
        // like previous functions
        let url = URL(string: "")
        return url!
    }

}


//MARK: Mistakes and Notes


//MARK: هل ينفع ان اعمل كال ل "اسينك فانكشن" واعمل "ريترن ل ريزلت" واعمل "سرو ل ايرور" الخ ---> الاجابة: (ايوا)



// يعني اي "فاليو يساوي صفر اللي في ديسباتش سيمافور" الرقم هو عدد ال"ثريدز" او الحاجات اللي ممكن تعملها "اكسيس كونكارنسي" الخ

// semaphore.wait() ---> semaphore.signal() ده معناه انه هيعمل "ويت" لحد اما تعمل
// لازم كل "ويت" قصادها "سيجنال" الخ

// كده انا حولت "الفانكشنز" ن "اسينك" ل "سينك" بآستخدام "سيمافور" الخ


// مشكلة الكود ده ان الديزين اللي علي الشاشة مش هيظهر غير لما الداتا ترجع لان احنا عملنا "سيمافور دوت ويت" علي "مان ثريد" فكده عمل "ويت" لحد اما "الفانكشن" تخلص

// احل المشكلة ده في ان اخلي "الفانكشن" تعمل رن داخل "الجلوبل" اللي هي الكومنت رقم ١

// كده انا حققت ان الكود بقي شكله "سينك" علي الرغم ان "الفانكشنز اسينك" الخ


//fourthView وده في ModernConccurency وده عن طريق ان استخدمmuch more swifty شكل الفانكشنز كده مش حلو ازاي اخلي الكود
