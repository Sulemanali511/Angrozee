//
//  ApiManager.swift
//  Smart Care
//
//  Created by Suleman Ali on 03/05/2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

enum VoidResult {
    case success(result:JSON)
    case failure(NSError)
}



struct errorCode{
    /**
     501 mean session expired. Need to login again
     */
    static var loginAgain = 501
    
    /**
     200 mean sucess response
     */
    static var success = 200
    
    static var permissionDenied = 401
    
}



class ApiManager: NSObject {
    
    class func headers() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let authToken = UserDefaults.standard.string(forKey: "token") {
            headers["Authorization"] = "bearer " + authToken
        }
        
        return headers
    }
    /// post request for array of dict
    class func newPostRequest(with url: String,parameters: [[String:Any]], completion: @escaping (_ result: VoidResult) -> ())
    {
        
        
        if Reachability.isConnectedToNetwork(){
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.headers = ApiManager.headers()
            
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                print(response!)
                do {
                    let jsonobj = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(jsonobj)
                    
                    let json = JSON(jsonobj)
                    DispatchQueue.main.async {
                        completion(.success(result: json))
                    }
                    
                } catch {
                    print("error")
                }
            })
            
            task.resume()
            
            
        }else{
            Functions.noInternetConnection(status: true)
        }
        print(url)
    }
    class func postRequest(with url: String,parameters: [String:Any], completion: @escaping (_ result: VoidResult) -> ())
    {
        
        if Reachability.isConnectedToNetwork(){
            print("url: ",url)
            print("param: ",JSON(parameters))
            Functions.showActivity()
            AF.request(url,method: .post, parameters: parameters, encoding: JSONEncoding.prettyPrinted, headers: ApiManager.headers()).responseJSON { (response:AFDataResponse<Any>) in
                Functions.hideActivity()
                if let jsonObject = response.value
                {
                    let json = JSON(jsonObject)
                    print(json)
                    if response.response?.statusCode == 200{
                        completion(.success(result: json))
                    }else if response.response?.statusCode == 500{
                        completion(.success(result: json))
                        //  ApiManager.loginAgainOnTokenExpiration(isTokenExpire: true, msg:json["message"].stringValue)
                        Functions.showToast(message: json["returnMessage"][0].stringValue, type: .failure, duration: 3.0, position: .center)
                        
                    }else if response.response?.statusCode == 404{
                        completion(.success(result: json))
                    }
                    else if response.response?.statusCode == 401{
                        ApiManager.loginAgainOnTokenExpiration(isTokenExpire: true, msg:json["returnMessage"][0].stringValue)
                    }else{
                        
                        Functions.showToast(message: json["returnMessage"][0].stringValue, type: .failure, duration: 3.0, position: .center)
                    }
                    
               
                    
                } else if let error = response.error {
                    
                    if response.response?.statusCode == 401 {
                       
                    ApiManager.loginAgainOnTokenExpiration(isTokenExpire: true)
                    }else if response.response?.statusCode == 500{
                        Functions.showToast(message: error.localizedDescription)
                        completion(.failure(error as NSError))
                    }else if response.response?.statusCode == 200
                    {
                        
                        let json = JSON(response.response!)
                        print(json)
                        completion(.success(result: json))
                    }else{
                        completion(.failure(error as NSError))
                    }
                    
                } else {
                    fatalError("No error, no failure")
                    
                }
            }
        }else{
            Functions.noInternetConnection(status: true)
        }
        print(url)
        
        
    }

    
    
    class func deleteRequest(with url: String,parameters: [String: Any]?, completion: @escaping (_ result: VoidResult) -> ())
    {
        print(url)
        if Reachability.isConnectedToNetwork(){
            
            
            AF.request(url,method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers:ApiManager.headers()).responseJSON { (response:AFDataResponse<Any>) in
                
                
                
                if let jsonObject = response.value
                {
                    let json = JSON(jsonObject)
                    completion(.success(result: json))
                    
                } else if let error = response.error {
                    ///reference from "https://stackoverflow.com/questions/29131253/swift-alamofire-how-to-get-the-http-response-status-code"
                    if response.response?.statusCode == 401 || response.response?.statusCode == 500{
                        Functions.hideActivity()
                        
                        //                        ApiManager.loginAgainOnTokenExpiration(isTokenExpire: true)
                    }else{
                        completion(.failure(error as NSError))
                    }
                } else {
                    fatalError("No error, no failure")
                }
            }
        }else{
            Functions.noInternetConnection(status: true)
        }
        
        
    }
    class func getRequest(with url: String,parameters: [String:Any]?, completion: @escaping (_ result: VoidResult) -> ())
    {
        print("url: ",url)
        print("param: ",JSON(parameters ?? [:]))
        if Reachability.isConnectedToNetwork(){
            AF.request(url,method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString) , headers:ApiManager.headers()).responseJSON { (response:AFDataResponse<Any>) in
                Functions.hideActivity()
                if let jsonObject = response.value
                {
                    let json = JSON(jsonObject)
                    
                    
                    if response.response?.statusCode == 200{
                        completion(.success(result: json))
                    }else if response.response?.statusCode == 500{
                        Functions.showToast(message: json["returnMessage"][0].stringValue, type: .failure, duration: 3.0, position: .center)
                    }else  if response.response?.statusCode == 401{
                        
                        ApiManager.loginAgainOnTokenExpiration(isTokenExpire: true, msg:json["returnMessage"][0].stringValue)
                    }else{
                        print(json)
                        if json["returnMessage"].arrayValue.count > 0{
                            Functions.showToast(message: json["returnMessage"][0].stringValue, type: .failure, duration: 3.0, position: .center)
                        }
                        
                    }
                    
                    /*if json["statusCode"].intValue == 500{
                     Functions.hideActivity()
                     ApiManager.loginAgainOnTokenExpiration(isTokenExpire: true)
                     Functions.showToast(message: json["message"].stringValue, type: .failure, duration: 3.0, position: .center)
                     
                     }else{
                     completion(.success(result: json))
                     }*/
                } else if let error = response.error {
                    
                    if response.response?.statusCode == 401 || response.response?.statusCode == 500{
                            ApiManager.loginAgainOnTokenExpiration(isTokenExpire: true)
                        
                    }else{
                        completion(.failure(error as NSError))
                    }
                } else {
                    fatalError("No error, no failure")
                }
            }
        }else{
            Functions.noInternetConnection(status: true)
        }
    }
    
    class func postRequestWithForm(params: Dictionary<String, Any>?, urlRequst:String, completion: @escaping (_ result: VoidResult) -> ())
    {
        
        AF.upload(multipartFormData: { multipartFormData in
            
            
            for p in params! {
                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
            
        }, to: urlRequst, method: .post, headers: ApiManager.headers()) .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
            
           
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(data)")
        }).response { response in
            Functions.hideActivity()
            print(response.response?.statusCode as Any)
            if let jsonObject = response.value
            {
                let json = JSON(jsonObject as Any)
                print(json)
                completion(.success(result: json))
                
            }  else if let error = response.error {
                completion(.failure(error as NSError))
            } else {
                fatalError("No error, no failure")
            }
            
        }
        
    }
    class func uploadPhoto(with imgData: Data,fileuRL: URL?, completion: @escaping (_ result: VoidResult) -> ())
    {
        
        AF.upload(multipartFormData: { multipartFormData in
            
            if fileuRL != nil{
                let mimeType = String(format: "application/%@", fileuRL!.pathExtension)
                let filename = String(format: "%@", fileuRL!.lastPathComponent)
                multipartFormData.append("\(filename)".data(using: String.Encoding.utf8)!, withName: "name")
               
                
                multipartFormData.append(imgData, withName: "file",fileName: filename, mimeType: mimeType)
            }else{
                let str = "\(Date().timeIntervalSince1970).jpg"
                multipartFormData.append("\(str)".data(using: String.Encoding.utf8)!, withName: "name")
               
                multipartFormData.append(imgData, withName: "file",fileName: str, mimeType: "image/jpeg")
            }
        }, to: APPURL.UploadFile, method: .post, headers: ApiManager.headers()) .uploadProgress(queue: .main, closure: { progress in
            print (APPURL.UploadFile)
            print("Upload Progress: \(progress.fractionCompleted)")
            Functions.showActivity(progres: progress.fractionCompleted)
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(data)")
        }).response { response in
            Functions.hideActivity()
            print(response.response?.statusCode as Any)
            if let jsonObject = response.value
            {
                let json = JSON(jsonObject as Any)
                print(json)
                completion(.success(result: json))
                
            }  else if let error = response.error {
                completion(.failure(error as NSError))
            } else {
                fatalError("No error, no failure")
            }
            
        }
        
    }
    class func downloadFileAndSaveinDocument(imageUrl:String , success: @escaping ((_ response: String?) -> Void)) {
        //audioUrl should be of type URL
        let url = URL(string: imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? imageUrl)
        let audioFileName = String((url?.lastPathComponent)!) as NSString
        
        //path extension will consist of the type of file it is, epub
        // let pathExtension = audioFileName.pathExtension
        
        
        let destination : DownloadRequest.Destination = {_,_ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            // the name of the file here I kept is yourFileName with appended extension
            documentsURL.appendPathComponent((audioFileName as String))
            return (documentsURL, [.removePreviousFile])
        }
        
        
        AF.download(
            url!,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
                print("download Progress: \(progress.fractionCompleted)")
            }).response(completionHandler: { (response) in
                //here you able to access the DefaultDownloadResponse
                //result closure
                if response.fileURL != nil {
                    print(response.fileURL!)
                    DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                        let path =  Functions.checkfileInDocumentDirecotory(with: imageUrl)
                        success(path)
                    })
                    
                }else{
                    print("url is nill")
                }
                
            })
    }
    
    
    class func uploadChatFiles(with imgData: Data,params: Dictionary<String, Any>?,fileuRL: String , urlRequst:String, completion: @escaping (_ result: VoidResult) -> ())
    {
        
        AF.upload(multipartFormData: { multipartFormData in
            if fileuRL != ""{
                let url = URL(string: fileuRL)
                let mimeType = String(format: "application/%@", url!.pathExtension)
                let filename = String(format: "%@", url!.lastPathComponent)
                if urlRequst == APPURL.UploadFile{
                    multipartFormData.append(imgData, withName: "Photo",fileName: filename, mimeType: mimeType)
                }else{
                    multipartFormData.append(imgData, withName: "File",fileName: filename, mimeType: mimeType)
                }
            }else{
                
                let str = "\(Date().timeIntervalSince1970).jpg"
                multipartFormData.append("\(str)".data(using: String.Encoding.utf8)!, withName: "name")
               
                multipartFormData.append(imgData, withName: "file",fileName: str, mimeType: "image/jpeg")

             /*   if params?.count != 0{
                    let name = params!["Name"] as? String
                    let fileName = String(format: "%@", name ?? "")
                    multipartFormData.append(imgData, withName: "File",fileName: fileName, mimeType: "image/jpeg")
                }else{
                    let fileName = String.random(length: 20) + ".jpg"
                    multipartFormData.append(imgData, withName: "Photo",fileName: fileName, mimeType: "image/jpeg")
                    //  multipartFormData.append(imgData, withName: "Photo",fileName: fileName, mimeType: "audio/m4a")
                    
                    //            multipartFormData.append(songData_ as Data, withName: "Photo", fileName: fileName, mimeType: "audio/m4a")
                    
                }
                */
            }
            
            for p in params! {
                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
            
        }, to: urlRequst, method: .post, headers: ApiManager.headers()) .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
            
            Functions.showActivity(progres: progress.fractionCompleted)
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(data)")
        }).response { response in
            Functions.hideActivity()
            print(response.response?.statusCode)
            if let jsonObject = response.value
            {
                let json = JSON(jsonObject as Any)
                print(json)
                completion(.success(result: json))
                
            }  else if let error = response.error {
                completion(.failure(error as NSError))
            } else {
                fatalError("No error, no failure")
            }
            
        }
        
    }
    class func loginAgainOnTokenExpiration(isTokenExpire:Bool , msg:String = ""){
        
        
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "refresh_token")
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
  
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginNAV") as! UINavigationController
        
        vc.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        vc.navigationController?.navigationBar.isHidden = true
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }) { (_) in
            if isTokenExpire == true{
                Functions.showToast(message: msg, type: .failure, duration: 3.0, position: .center)
            }
        }
        
    }
    
    
    class func firebaseHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        headers["Authorization"] = "key=AAAAsXE3W_E:APA91bElVaFzFmbgf30fgcmqXDfNrPBUWrQmclJeI2oXgbJ7t45MY5kWF_uHiW3wnODQii5dSppBxW2BjvUasN1tI4n97UuvEqJxa8rRh0DHz7oOVHnXkjNWLJ1lUFRoAGtsHz4jc-ji" //+ "42"
        
        return headers
    }
    class func postFirebaseNotification(with request: String,parameters: [String: Any], completion: @escaping (_ result: VoidResult) -> ())
    {
        print(request)
        
        
        AF.request(request,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ApiManager.firebaseHeaders()).responseJSON { (response:AFDataResponse<Any>) in
            
            if let jsonObject = response.value
            {
                let json = JSON(jsonObject)
                completion(.success(result: json))
                
            } else if let error = response.error {
                completion(.failure(error as NSError))
            } else {
                fatalError("No error, no failure")
                
            }
        }
    }
    
}





