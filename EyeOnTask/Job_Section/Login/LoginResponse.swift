//
//  LoginResponse.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 30/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation


class forgotPassResponse: Codable {
    var success: Bool?
    var message: String?
}

class forgotPasswordKeyResponse : Codable {
    var success: Bool?
    var message: String?
    var usrId: String?
}

class forgotPassResetRespponse : Codable {
    var success: Bool?
    var message: String?
    var usrId: String?
}


class changePasswordResponse : Codable {
    var success: Bool?
    var message: String?
}


class emailResponse: Codable {
    var success: Bool?
    var message: String?
    var data: emailData?
}

class emailData: Codable {
    var cCode: [String]?
    var apiurl: String?
    var country: String?
    var email: String?
    var region: String?
}

class companyData: Codable {
    var comp_code: String?
}


//Response Data
class loginResponse: Codable {
    var success: Bool?
    var message: String?
    var expiryMsg: String?
    var data: [LoginData]
}


class LoginData: Codable {
    var compId: String?
    var email: String?
    var fnm: String?
    var img: String?
    var lnm: String?
    var token: String?
    var udId: String?
    var usrId: String?
    var audId: String?
    var username : String?
    var cc : String?
    var forceupdate_version : String?
    var version : String?
    var staticLabelFwKeyVal :String?
 
}


class loginCmpnyResponse: Codable {
    var success: Bool?
    var message: String?
    var data: [companyData]
}


class LatLngResponse: Codable {
    var success: Bool?
    var message: String?
    var data: [addFwLatLng]
}


class addFwLatLng : Codable {
    var usrId: String?
    var lat: String?
    var lng: String?
    var btryStatus: String?
}




