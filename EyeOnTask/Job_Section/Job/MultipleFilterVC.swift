//
//  MultipleFilterVC.swift
//  EyeOnTask
//
//  Created by mac on 26/07/18.
//  Copyright © 2018 Hemant. All rights reserved.
// jugal ==

import UIKit

class MultipleFilterVC: UIViewController,OptionViewDelegate {
    var optionalVw : OptionalView?
    var sltBtn : Int!
    var arrOfShowData = [Any]()
    let cellReuseIdentifier = "cell"
    let arrOfPriroty : [taskPriorities] = [ .Low , .Medium , .High]
    

   // var arrTypeStatus : [taskStatusType] = [.New, .Accepted, .Travelling, .Break, .InProgress, .JobBreak, .OnHold, .Completed]
 
    var callbackOfMultipleFilter: (( [[String : String]] ) -> Void)?
    var selectedStatus = [Int]()
    var selectedPrty = [Int]()
    var selectedtag = [Int]()
    var arrTypeStatusDemo = [JobStatusListResData]()
    var arrTypeStatus = [JobStatusList]()
    var arrTypeStatus1 = [JobStatusList]()
    
    
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var txtIndustry: FloatLabelTextField!
    @IBOutlet var txtFld_Tags: FloatLabelTextField!
    @IBOutlet var txtFld_JobCode: FloatLabelTextField!
    @IBOutlet var txtFld_JobStatus: FloatLabelTextField!
    @IBOutlet var txtfld_Priority: FloatLabelTextField!
    
    var iD66 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrTypeStatus.removeAll()
        getJobStatusList()

        var arrlocal = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]

       
        for job in arrlocal{
            
        if(job.id == "3") {
          
            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
        }else if(job.id == "10") {
            
            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
        }else if(job.id == "9") {
            
            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
        }else  if(job.id == "7") {
            
            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
        }else  if(job.id == "4") {
            
            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
        }else  if(job.id == "11") {
            
            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
        }else  if(job.id == "100") {
                
            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
        }else  if(job.id == "101") {
            
            DatabaseClass.shared.deleteEntity(object: job, callback: { (_) in})
        }

        }
        
        self.arrTypeStatus = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: nil) as! [JobStatusList]
               let arrRemovStatusType = ["Revisit", "Reschedule"]
               self.arrTypeStatus = self.arrTypeStatus.filter( {arrRemovStatusType.contains($0.id ?? "") == false} )
             
               getTagListService()
               setLocalization()
               ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobsFilter)
    }
    
    func setLocalization() -> Void {
        
        self.navigationItem.title = LanguageKey.filter
        txtFld_JobStatus.placeholder = LanguageKey.job_status
        txtfld_Priority.placeholder = LanguageKey.job_priority
        txtFld_Tags.placeholder = LanguageKey.tags
        btnReset.setTitle(LanguageKey.reset , for: .normal)
        btnFilter.setTitle(LanguageKey.filter , for: .normal)
        
    }
    
    //==========================
    //MARK:- Open OptionalView
    //==========================
    func openDwopDown(txtField : UITextField , arr : [Any]) {
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height ), width: self.view.frame.size.width - 20, height: CGFloat(arr.count > 5 ? 150 : 38*arr.count)))
            self.optionalVw?.delegate = self
            self.view.addSubview( self.optionalVw!)
            //self.scroll_View.isScrollEnabled = false
            self.optionalVw?.removeOptionVwCallback = {(isRemove : Bool) -> Void in
                self.removeOptionalView()
            }
         
        }else{
            DispatchQueue.main.async {
                self.removeOptionalView()
            }
        }
    }
    func removeOptionalView(){
        if optionalVw != nil {
            self.optionalVw?.removeFromSuperview()
            self.optionalVw = nil
            // self.scroll_View.isScrollEnabled = true
           // self.arrOfShowData.removeAll()
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.txtFld_JobStatus.text = ""
        self.txtfld_Priority.text = ""
        self.txtFld_Tags.text = ""
        selectedStatus.removeAll()
        selectedPrty.removeAll()
        selectedtag.removeAll()
    }
    
    @IBAction func filterBtnAction(_ sender: Any) {

        if (self.callbackOfMultipleFilter != nil) && (selectedStatus .count>0 || selectedPrty .count>0 || (selectedtag.count >  0))  {
            
            var arry = [[String : String]]()

            //For add status value in selectedStatus
            for element in selectedStatus{
                let  statusNo1 = arrTypeStatus[element].text
                let  statusNo = arrTypeStatus[element].id
                //let status = taskStatus(taskType: taskStatusType(rawValue: statusNo)!)
              //  let statusString = status.0.replacingOccurrences(of: " Task", with: "")
                arry.append( [ "String" : "status = \(statusNo ?? "")" , "Status" : "\(statusNo1 ?? "")" ] )
                //arry.append( [ "String1" : "status = \(statusNo ?? "")" , "Status1" : "\(statusNo1 ?? "")" ] )
            }
            
            
            //For add Priority value in selectedPriority
            for element in selectedPrty{
                let  prirotyNo = arrOfPriroty[element].rawValue
                let priorityDetail = taskPriorityImage(Priority: taskPriorities(rawValue: prirotyNo)!)
                arry.append(["String" : "prty = \(prirotyNo)","Status" : priorityDetail.0])
            }
            
            
             //For add Tag value in selectedTag
            for element in selectedtag{
                let tag : String = ((self.arrOfShowData[element] as? TagsList)?.tnm!)!
                arry.append(["Tag" : tag])
            }
            
            
            if self.callbackOfMultipleFilter != nil {
               self.callbackOfMultipleFilter!(arry)
            }
    
            self.navigationController?.popViewController(animated: true)
        }else{
            ShowError(message: AlertMessage.filterButton, controller: windowController)
        }
        
    }
    
    @IBAction func btnActionMethod(_ sender: UIButton) {
        sltBtn = sender.tag
        switch sender.tag {
        case 1: //Job Status
            self.openDwopDown( txtField: self.txtFld_JobStatus, arr: arrTypeStatus)
            break
        case 2: // Job Priority
            self.openDwopDown( txtField: self.txtfld_Priority, arr: arrOfPriroty)
            break
        case 3: // Tags
            self.arrOfShowData = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TagsList", query: nil) as! [TagsList]
            self.openDwopDown( txtField: self.txtFld_Tags, arr: self.arrOfShowData)
            break
        default:
            
            break
        }
        
    }
    
    func getSelectedArr() -> [Any]{
        switch self.sltBtn {
        case 1:
           return arrTypeStatus
        case 2:
            return arrOfPriroty
        case 3:
            return arrOfShowData
        
        default: break
            
        }
        
        return []
    }
    
    //=====================================
    // MARK:- Option view Detegate
    //=====================================
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSelectedArr().count
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        
        
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        //cell?.textLabel?.textColor = UIColor.init(red: 0.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1)
        cell?.textLabel?.textColor = UIColor.darkGray
        
    
        switch self.sltBtn {
        case 1:// Status
            showCheckMark(arry: selectedStatus, cell: cell!, row: indexPath.row)
            let status : String = String(describing: arrTypeStatus[indexPath.row].text ?? "")
            cell?.textLabel?.text = status.capitalizingFirstLetter()
            break
        
        case 2: //Priority
            showCheckMark(arry: selectedPrty, cell: cell!, row: indexPath.row)
            let priroity : String = String(describing: arrOfPriroty[indexPath.row])
            cell?.textLabel?.text = priroity.capitalizingFirstLetter()
            break
      
        case 3: //Tag
            showCheckMark(arry: selectedtag, cell: cell!, row: indexPath.row)
            let tag : String =  (self.arrOfShowData[indexPath.row] as? TagsList)!.tnm!
            cell?.textLabel?.text = tag
            //cell?.textLabel?.text = self.sltTagName.capitalizingFirstLetter()
            break

        default: break

        }
        return cell!
        
    }
    
    func showCheckMark(arry : [Int], cell : UITableViewCell, row : Int ) -> Void {
        //Check if current indexpath row exist in  array , so we can show checkmark for this row
        if arry.contains(row){
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        
        
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        //cell?.textLabel?.textColor = UIColor.init(red: 0.0/255.0, green: 132.0/255.0, blue: 141.0/255.0, alpha: 1)
        cell?.textLabel?.textColor = UIColor.darkGray
        
        switch self.sltBtn {
            
        case 1:
            //            addRemoveRowNumber(row: indexPath.row, array: &selectedStatus) // old
            //            self.txtFld_JobStatus.text  = String(describing: arrTypeStatus[indexPath.row].text ?? "") // old
                        
                        let status = String(describing: arrTypeStatus[indexPath.row].id ?? "")
                        if (status == "Revisit") || (status == "Reschedule") {
                        }else {
                            addRemoveRowNumber(row: indexPath.row, array: &selectedStatus)
                            self.txtFld_JobStatus.text  = String(describing: arrTypeStatus[indexPath.row].text ?? "") 
                        }
                  
                      //  showStatusOnTextField(arry: selectedStatus, textField: txtFld_JobStatus, arryName: arrTypeStatus[indexPath.row].text)
                        self.removeOptionalView()
                        break
        
        case 2:
            addRemoveRowNumber(row: indexPath.row, array: &selectedPrty)
             showStatusOnTextField(arry: selectedPrty, textField: txtfld_Priority, arryName: arrOfPriroty)
            self.removeOptionalView()
            break
       
        case 3:
            addRemoveRowNumber(row: indexPath.row, array: &selectedtag)
             showStatusOnTextField(arry: selectedtag, textField: txtFld_Tags, arryName: arrOfShowData)
            self.removeOptionalView()
            break

        default:
            break
        }
    }
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
    }
    
    func addRemoveRowNumber(row: Int, array : inout [Int]) -> Void {
        //If indexpath row exist in this array so remove this index otherwise add this row in the array
        if array.contains(row)
        {
            if let index = array.firstIndex(of: row) {
                array.remove(at: index)
            }
        }else{
            array.append(row)
        }
    }
    
    func showStatusOnTextField(arry : [Int], textField : UITextField, arryName : [Any]) -> Void {
        var appendString = ""
        if arry.count <= 3{
            for item in arry{
                
               if  arry ==  selectedtag{
                let  tagname = ((self.arrOfShowData[item] as? TagsList)?.tnm!)!
                    let status = tagname.capitalizingFirstLetter()
                    if appendString == ""{
                        appendString = status
                    }else{
                        appendString = appendString + ", \(status)"
                    }
                }else{
                    let status : String = String(describing: arryName[item])
                    if appendString == ""{
                        appendString = status
                    }else{
                        appendString = appendString + ", \(status)"
                    }
                }
             }
            textField.text = appendString
        }else{
            textField.text = "\(arry.count) items selected"
        }
    }
    
    
    
    //=====================================
    // MARK:- get All Added Tags
    //=====================================
    
    func getTagListService(){
        
        if !isHaveNetowork() {
            return
        }
        
        /*
         "compId -> Company id
         limit -> limit
         index -> index value
         search -> search value"
         */
        let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.jobTagList) as? String
        
        let param = Params()
        param.compId = getUserDetails()?.compId
        param.limit = ContentLimit
        param.index = "0"
        param.search = ""
        param.dateTime = ""//lastRequestTime ?? ""
        
        serverCommunicator(url: Service.jobTagList, param: param.toDictionary) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(tagListResponse.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        UserDefaults.standard.set(CurrentDateTime(), forKey: Service.jobTagList)
                        DispatchQueue.main.async{
                            if decodedData.data?.count != 0 {
                                self.saveTagsNmInDataBase(data: decodedData.data!)
                            }
                        }
                    }else{
                        //ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                ShowAlert(title: errorString, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: { (cancelButton, okButton) in
                    if cancelButton {
                        showLoader()
                        //  self.getTagListService()
                    }
                })
            }
        }
    }
    
    func saveTagsNmInDataBase( data : [tagElements]) -> Void {
        
        for jobs in data{
            let query = "tagId = '\(jobs.tagId!)'"
            let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "TagsList", query: query) as! [TagsList]
            if isExist.count > 0 {
                let existingJob = isExist[0]
                existingJob.setValuesForKeys(jobs.toDictionary!)
                //DatabaseClass.shared.saveEntity()
            }else{
                let userJobs = DatabaseClass.shared.createEntity(entityName: "TagsList")
                userJobs?.setValuesForKeys(jobs.toDictionary!)
                //DatabaseClass.shared.saveEntity()
            }
        }
          DatabaseClass.shared.saveEntity(callback: {_ in})
    }
    


//==========================================
// MARK:- Get getJobStatusList List Service
//==========================================

 func getJobStatusList(){

        let param = Params()
        param.index = "0"
        param.search = ""
        param.limit = "120"
  
        serverCommunicator(url: Service.getJobStatusList, param: param.toDictionary) { (response, success) in
            killLoader()
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(JobStatusListRes.self, from: response as! Data) {

                    if decodedData.success == true{
                      
                        self.saveJobStatusList(data: decodedData.data! )
                      //  self.jobStatusArr = decodedData.data as! [JobStatusListResData]
                       
                    }else{
                        ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{

                    ShowError(message: AlertMessage.formatProblem, controller: windowController)
                }
            }else{
                //ShowError(message: "Please try again!", controller: windowController)
            }
        }
        
    }


//===================================================
// MARK:- Save getJobStatusList data in DataBase
//===================================================

func saveJobStatusList( data : [JobStatusListResData]) -> Void {
for jobs in data{
 let query = "id = '\(String(describing: jobs.id ?? ""))'"
    let isExist = DatabaseClass.shared.fetchDataFromDatabse(entityName: "JobStatusList", query: query) as! [JobStatusList]
    if isExist.count > 0 {
        let existingJob = isExist[0]
        existingJob.setValuesForKeys(jobs.toDictionary!)
       // DatabaseClass.shared.saveEntity()
    }else{
        let userJobs = DatabaseClass.shared.createEntity(entityName: "JobStatusList")
        userJobs?.setValuesForKeys(jobs.toDictionary!)
       // DatabaseClass.shared.saveEntity()
    }
}

 DatabaseClass.shared.saveEntity(callback: { _ in })

}

}


