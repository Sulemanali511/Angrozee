//
//  CDManager.swift
//  Smart Care
//
//  Created by Suleman Ali on 03/05/2021.
//


import Foundation
import CoreData
import SwiftyJSON
import UIKit
import JWTDecode


class CDManager: NSObject {
    
   
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    class var context : NSManagedObjectContext {
        return getContext()
    }
    
    class func saveUsersListInDB(with json: JSON, token :String, refreshToken:String){
        
//        if someEntityExists(id: json["employee"]["EmployeeId"].stringValue,entityName: "UsersList",requestedId: "employeeId"){
//            print("Record Exsist")
//        }else{
//            let currentUser = UsersList(context: context)
//            let jsonnew = json["employee"]
//
//            currentUser.firstName =  jsonnew["FirstName"].stringValue
//            currentUser.fileId =  jsonnew["FileId"].stringValue
//            currentUser.email =  jsonnew["Email"].stringValue
//            currentUser.photoPath =  jsonnew["PhotoPath"].stringValue
//            currentUser.departmentId =  jsonnew["DepartmentId"].stringValue
//            currentUser.localId =  jsonnew["LocalId"].stringValue
//            currentUser.countryId =  jsonnew["CountryId"].stringValue
//            currentUser.userId =  jsonnew["UserId"].stringValue
//            currentUser.userName =  jsonnew["UserName"].stringValue
//            currentUser.clientId =  jsonnew["ClientId"].stringValue
//            currentUser.lastName =  jsonnew["LastName"].stringValue
//            currentUser.employeeId = jsonnew["EmployeeId"].stringValue
//            currentUser.token = token
//            currentUser.refreshToken = refreshToken
//            let rolejson = json["roles"].arrayValue
//            if rolejson.count != 0{
//                currentUser.roleId = rolejson[0]["Id"].stringValue
//            }
//
//            do {
//                try context.save()
//            } catch let error as NSError  {
//                print("Could not save \(error), \(error.userInfo)")
//            }
//        }
    }
    
//    class func fetchUsersList() -> [UsersListModel]? {
//        let context = getContext()
//        let fetchRequest:NSFetchRequest<UsersList> = UsersList.fetchRequest()
//        var obj:[UsersListModel]?
//        
//        do {
//            let team = try context.fetch(fetchRequest)
//            
//            var arr = [UsersListModel]()
//            
//            for obj in team{
//                arr.append(UsersListModel(managedObject: obj))
//            }
//            obj = arr
//            return obj
//            
//        }catch {
//            return obj
//        }
//    }
    
    //MARK: - User details
    class func saveUserInDB(with json: JSON){
        
        //        let currentUser = User(context: context)
        //        let jsonnew = json["employee"]
        //        currentUser.firstName =  jsonnew["FirstName"].stringValue
        //        currentUser.fileId =  jsonnew["FileId"].stringValue
        //        currentUser.email =  jsonnew["Email"].stringValue
        //        currentUser.photoPath =  jsonnew["PhotoPath"].stringValue
        //        currentUser.departmentId =  jsonnew["DepartmentId"].stringValue
        //        currentUser.localId =  jsonnew["LocalId"].stringValue
        //        currentUser.countryId =  jsonnew["CountryId"].stringValue
        //        currentUser.userId =  jsonnew["UserId"].stringValue
        //        currentUser.userName =  jsonnew["UserName"].stringValue
        //        currentUser.clientId =  jsonnew["ClientId"].stringValue
        //        currentUser.lastName =  jsonnew["LastName"].stringValue
        //        currentUser.employeeId = jsonnew["EmployeeId"].stringValue
        //
        //        let rolejson = json["roles"].arrayValue
        //        if rolejson.count != 0{
        //            currentUser.roleId = rolejson[0]["Id"].stringValue
        //        }
        //
        //
        //        do {
        //            try context.save()
        //        } catch let error as NSError  {
        //            print("Could not save \(error), \(error.userInfo)")
        //        }
    }
    
    //    class func fetchUser() -> UserModel? {
    //        let context = getContext()
    //        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
    //        var obj:UserModel?
    //
    //        do {
    //            let team = try context.fetch(fetchRequest)
    //
    //            var arr = [UserModel]()
    //
    //            for obj in team{
    //                arr.append(UserModel(managedObject: obj))
    //            }
    //            if arr.count != 0{
    //                obj = arr[0]
    //                return obj
    //            }else{
    //                return obj
    //            }
    //
    //        }catch {
    //            return obj
    //        }
    //    }
    
    //MARK: - User Rights
    
    //    class func saveUserRightsInDB(with json: JSON){
    //        let rights = UserRights(context: context)
    //        rights.id = json["id"].stringValue
    //        rights.right = json["right"].stringValue
    //        do {
    //            try context.save()
    //        } catch let error as NSError  {
    //            print("Could not save \(error), \(error.userInfo)")
    //        }
    //
    //    }
    
    
    //    class func fetchUserRights() -> [UserRights]? {
    //        let context = getContext()
    //        let fetchRequest:NSFetchRequest<UserRights> = UserRights.fetchRequest()
    //        // var team:[MyTeam]? = nil
    //        var arr = [UserRights]()
    //
    //        do {
    //            arr = try context.fetch(fetchRequest)
    //            return arr
    //        }catch {
    //            return arr
    //        }
    //    }
    
    
    
    
    //
    //
    //    class func saveMessages(with json: JSON){
    //        let chatList = Messages(context: context)
    //
    //        chatList.id = json["id"].stringValue
    //        chatList.conversationId = json["conversationId"].stringValue
    //        chatList.filePath = json["filePath"].stringValue
    //        chatList.fileSize = json["fileSize"].stringValue
    //        chatList.fileName = json["fileName"].stringValue
    //        chatList.message = json["message"].stringValue
    //        chatList.senderId = json["senderId"].stringValue
    //        chatList.receiverId = json["receiverId"].stringValue
    //        chatList.senderName = json["senderName"].stringValue
    //        chatList.receiverName = json["receiverName"].stringValue
    //        chatList.senderImage = json["senderImage"].stringValue
    //        chatList.receiverImage = json["receiverImage"].stringValue
    //        chatList.timestamp = json["timestamp"].doubleValue
    //        chatList.date = json["date"].stringValue
    //        chatList.msgStatus = json["msgStatus"].stringValue
    //        chatList.isSeen = json["isSeen"].boolValue
    //        chatList.type = json["type"].stringValue
    //        chatList.isDeletedForAll = json["isDeletedForAll"].boolValue
    //
    //        let replyMsgJson = json["replyTo"]
    //        if replyMsgJson != ""{
    //            let replyMsg = ReplyMessage(context: context)
    //            replyMsg.id = replyMsgJson["id"].stringValue
    //            replyMsg.conversationId = replyMsgJson["conversationId"].stringValue
    //            replyMsg.filePath = replyMsgJson["filePath"].stringValue
    //            replyMsg.fileSize = replyMsgJson["fileSize"].stringValue
    //            replyMsg.fileName = replyMsgJson["fileName"].stringValue
    //            replyMsg.message = replyMsgJson["message"].stringValue
    //            replyMsg.senderId = replyMsgJson["senderId"].stringValue
    //            replyMsg.receiverId = replyMsgJson["receiverId"].stringValue
    //            replyMsg.senderName = replyMsgJson["senderName"].stringValue
    //            replyMsg.receiverName = replyMsgJson["receiverName"].stringValue
    //            replyMsg.senderImage = replyMsgJson["senderImage"].stringValue
    //            replyMsg.receiverImage = replyMsgJson["receiverImage"].stringValue
    //            replyMsg.timestamp = replyMsgJson["timestamp"].doubleValue
    //            replyMsg.date = replyMsgJson["date"].stringValue
    //            replyMsg.msgStatus = replyMsgJson["msgStatus"].stringValue
    //            replyMsg.isSeen = replyMsgJson["isSeen"].boolValue
    //            replyMsg.type = replyMsgJson["type"].stringValue
    //            replyMsg.isDeletedForAll = replyMsgJson["isDeletedForAll"].boolValue
    //
    //
    //            chatList.addToReplyMessage(replyMsg)
    //
    //        }
    //
    //        do {
    //            try context.save()
    //        } catch let error as NSError  {
    //            print("Could not save \(error), \(error.userInfo)")
    //        }
    //
    //    }
    //
    //    class func getAllMessages(otherUserId:String) -> [MessagesModel]?{
    //        let context = getContext()
    //        let fetchRequest:NSFetchRequest<Messages> = Messages.fetchRequest()
    //        fetchRequest.predicate = NSPredicate(format: "senderId = %@ || receiverId = %@" ,otherUserId,otherUserId)
    //
    //        // var team:[MyTeam]? = nil
    //        var arr = [MessagesModel]()
    //
    //        do {
    //            let team = try context.fetch(fetchRequest)
    //            for obj in team{
    //                arr.append(MessagesModel(managedObject: obj))
    //            }
    //            return arr
    //        }catch {
    //            return arr
    //        }
    //
    //    }
    //    class func deleteMessages(otherUserId:String)
    //    {
    //        let fetchRequest: NSFetchRequest<Messages> = Messages.fetchRequest()
    //        fetchRequest.predicate = NSPredicate(format: "senderId = %@ || receiverId = %@" ,otherUserId,otherUserId)
    //        var fetchedItems = [Messages]()
    //        do{
    //            fetchedItems=try context.fetch(fetchRequest)
    //        }catch{
    //            fatalError("Could not fetch")
    //        }
    //        for item in fetchedItems{
    //            context.delete(item)
    //        }
    //        do{
    //            try context.save()
    //        }catch {
    //            let nserror = error as NSError
    //            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    //        }
    //
    //    }
    //
    
}
