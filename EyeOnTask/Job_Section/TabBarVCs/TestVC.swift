//
//  TestVC.swift
//  EyeOnTask
//
//  Created by mac on 07/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class TestVC: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet var table_View: UITableView!
    
    var arrOfShowData = [TestDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFormName()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOfShowData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TestCell
        
        let contact = self.arrOfShowData[indexPath.row]
        cell.lbl_FormNm.text = contact.frmnm
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //performSegue(withIdentifier: "clientTabs", sender: indexPath)
    }
    
    
    //===============================
    // MARK:- Data - Passing method
    //===============================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.table_View.indexPathForSelectedRow {
            let customFormVC = segue.destination as! CustomFormVC
            customFormVC.objOFTestVC = self.arrOfShowData[indexPath.row]
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
 
    func getFormName(){
        
        //        if !isHaveNetowork() {
        //            if self.refreshControl.isRefreshing {
        //                self.refreshControl.endRefreshing()
        //            }
        //            return
        //        }
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getCustomFormNmList) as? String
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = "120"
        param.index = "0"
        param.search = ""
        param.dateTime = currentDateTime24HrsFormate()
        
        serverCommunicator(url: Service.getCustomFormNmList, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                
                if let decodedData = try? decoder.decode(TestRes.self, from: response as! Data) {
                    
                    if decodedData.success == true{
                        
                        if decodedData.data.count > 0 {
                            //
                            DispatchQueue.main.async {
                                
                                self.arrOfShowData = decodedData.data
                                self.table_View.reloadData()
                            }
                            
                        }else{
                            if self.arrOfShowData.count == 0{
                                DispatchQueue.main.async {
                                    self.table_View.isHidden = true
                                }
                            }
                        }
                    }else{
                        ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
    }
    
}
