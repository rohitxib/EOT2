//
//  ItemModel.swift
//  EyeOnTask
//
//  Created by Hemant-Aplite on 10/04/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation


class ItemModel: Codable {
    var success: Bool?
    var message: String?
    var data: [itemInfo]?
    var count: String?
}

class itemInfo: Codable {
     var itemId: String?
     var inm: String?
     var ides: String?
     var pno: String?
     var qty: String?
     var rate: String?
     var discount: String?
     var type: String?
     var isactive: String?
     var show_Invoice: String?
     var lowStock: String?
     var image: String?
     var hsncode: String?
     var unit: String?
     var supplierCost : String?
     var searchKey : String?
     var serialNo : String?
     var tax : [tax]?
    
}


class tax: Codable {
    var taxId : String?
    var label : String?
    var rate : String?
}

