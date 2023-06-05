//
//  ChatResponseModel.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 16/01/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

class ChatResponseModel: Decodable {
    var usrid:  String?
    var msg: String?
    var file:  String?
    var usrnm :  String?
    var time : String?
    var jobId : String?
    var jobCode : String?
    var type : String?
    
    init(usrid:  String, msg: String , file:  String, usrnm :  String, time : String, jobId : String, jobCode : String, type : String) {
         self.usrid = usrid
         self.msg = msg
         self.file =  file
         self.usrnm =  usrnm
         self.time =  time
         self.jobId =  jobId
         self.jobCode =  jobCode
         self.type =  type
    }
}

class ChatResponseModel1: Decodable {
    var usrId:  String?
    var msg: String?
    var file:  String?
    var usrNm :  String?
    var time : String?
    var jobId : String?
    var jobCode : String?
    var type : String?
    
    init(usrid:  String, msg: String , file:  String, usrnm :  String, time : String, jobId : String, jobCode : String, type : String) {
         self.usrId = usrid
         self.msg = msg
         self.file =  file
         self.usrNm =  usrnm
         self.time =  time
         self.jobId =  jobId
         self.jobCode =  jobCode
         self.type =  type
    }
}
