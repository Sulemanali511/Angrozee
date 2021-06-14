//
//  Constant.swift
//  Smart Care
//
//  Created by Suleman Ali on 03/05/2021.
//

import Foundation
import UIKit


struct APPURL{
    
    
    
    static var Domain: String {
        return "http://recta.uaenorth.cloudapp.azure.com:7281"
    }
    
    static let Route = "/api/v1.0/"
    static var BaseURL: String {
        return Domain + Route
    }
    
    
    static var SignIn: String {
        return BaseURL + "Auth"
    }
    static var Family_Create: String {
        return BaseURL + "Family/Create"
    }
    static var UploadFile:String{
        return  BaseURL + "FamilyFile/Upload"
    }
    static var Family_GetById:String{
    
        return  BaseURL + "Family/GetById?familyId=*param1*"
    }
    static var GetAllFamilies:String{
        return  BaseURL + "Family/GetAllFamilies?needFamilyHeads=*param1*&familyHeadId=*param2*"
    }
    static var GetAllCategories:String{
        return  BaseURL + "Category/GetAllCategories?familyId=*param1*"
    }
    static var Category_Create:String{
        return  BaseURL + "Category/Create"
    }
    static var Task_Create:String{
        return  BaseURL + "Task/Create"
    }
    
    static var GetCatDetails:String{
        return  BaseURL + "Category/GetAllCategories?familyId=*param1*"
    }
    
    ///api/v1.0/Task/GetAllTasks
    static var GetAllTasks:String{
        return  BaseURL + "Task/GetAllTasks"
    }
    
    ///api/v1.0/Task/GetAllTasks
    static var GetAllGroups:String{
        return  BaseURL + "Task/GetAllTasks?taskType=*param1*&familyId=*param3*"
    }
    
    static var GetTask:String{
        return  BaseURL + "Task/GetTaskByType"
    }
    static var GetAddPoints:String{
        return  BaseURL + "Point/CreatePoints"
    }
    static var GetTaskByType:String{
        return  BaseURL + "Category/GetCategoriesByTaskType?familyId=*param1*&taskType=*param2*" 
    }
    static var CreateRedeemPoints:String{
        return  BaseURL + "Point/CreateRedeemPoints"
    }
    
    static var GetPointsByFamily:String{
        return  BaseURL + "Point/GetPointsByFamily"
    }
    static var GetTaskPointsOfMember:String{
        return  BaseURL + "Point/GetTaskPointsOfMember"
    }
   
    static var GetAllNationalities :String{
    return BaseURL + "Nationality/GetAllNationalities"
    }
    
    static var OTPVerify:String{
    return BaseURL + "OTP/OTPVerify"
    }
    static var resendOTP:String{
        return BaseURL + "OTP/SendOTp"
    }
}


