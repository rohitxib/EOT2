//
//  ChatMessageModel.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 19/12/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation

class ChatMessageModel : Codable {
     var usrid:  String?
     var msg: String?
     var file:  String?
     var usrnm :  String?
     var time : String?
     var jobId : String?
     var jobCode : String?
     var type : String?
     var isClientChat : String?
//     var content : String?
//     var createdAt : String?
//     var senderId : String?
//     var doc : String?
    
    
//    convenience init(messageDict : [String : Any]) {
//        self.init()
//        self.msg = messageDict["content"] as? String
//        self.usrid = messageDict["senderId"] as? String
//        self.time = messageDict["createdAt"] as? String
//        self.doc = messageDict["doc"] as? String
//    }
    
}

class ChatMessageModelForJob1 : Codable {
var usrId:  String?
var msg: String?
var action:  String?
var usrNm :  String?
var usrType : String?
var type : String?
var id : String?
var time : String?
var statusId : String?
}




class ChatUserMessageModel: Codable {
    var content : String?
    var createdAt : String?
    var senderId : String?
    var doc : String?
    var senderNm : String?
    convenience init(messageDict : [String : Any]) {
        self.init()
        self.content = messageDict["content"] as? String
        self.senderId = messageDict["senderId"] as? String
        self.createdAt = messageDict["createdAt"] as? String
        self.doc = messageDict["doc"] as? String
        self.senderNm = messageDict["senderNm"] as? String
    }
}

class ChatNotificationModel : Codable {
    // for demo purpose
       var usrnm : String?
       var msg : String?
       var senderid : String?
       var msgUrl : String?
    
    convenience init(title: String, subtitle: String, senderId: String, msgUrl: String) {
        self.init()
        self.usrnm = title
        self.msg = subtitle
        self.senderid = senderId
        self.msgUrl = msgUrl
    }
    
}
