//
//  ChatVC.swift
//  EyeOnTask
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos
import MBProgressHUD
import SDWebImage
import IQKeyboardManagerSwift
import MobileCoreServices

class ChatVC: UIViewController , UITextViewDelegate, OptionViewDelegate  {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var containerVw_H: NSLayoutConstraint!
    @IBOutlet weak var chat_view: UIView!
    
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet var backgoundView: UIView!
    @IBOutlet weak var DefaultJobCrdView: UIView!
    @IBOutlet weak var SelectSingnatureView: UIView!
    @IBOutlet weak var EmailJobCrdView: UIView!
    @IBOutlet weak var PrntJobCardView: UIView!
    @IBOutlet weak var EmailJobLbl: UILabel!
    @IBOutlet weak var SelectTemplatetxtfild: FloatLabelTextField!
    @IBOutlet weak var SelectSingnaturetxtfied: FloatLabelTextField!
    @IBOutlet weak var PrintJobLbl: UILabel!
    var optionalVw : OptionalView?
    var arrayTypes =  ""
    var templatId = ""
    var jobIdPrint11  = ""
    var templateVelues = ""
    var demoArr11 = ["1","2","3"]
    var fwAr = [Any]()
    var jobIdPrints  = [Any]()
    var JobCardTemplatAr = [JobCardTemplat]()
    var query : String = ""
    
     var dd = Bool ()
     var objOfUserJobListInDetail : UserJobList?
     var img : UIImage?
     var imgName : String?
     var isRemove = true
     var loadingNotification : MBProgressHUD?
     var arrOFData = [ChatResponseModel]()
     var filterDict = [String : [ChatResponseModel]]()
     var arrOfFilterDict  = [[String : [ChatResponseModel]]]()
     var bottomSafeArea:CGFloat = 0.0
    
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let window = UIApplication.shared.keyWindow
        
        if #available(iOS 11.0, *) {
            bottomSafeArea = (window?.safeAreaInsets.bottom)!
        }

       
        ChatManager.shared.chatList.removeAll()
        tblView.estimatedRowHeight = 80.0
        tblView.rowHeight = UITableView.automaticDimension
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        
        let isItem = isPermitForShow(permission: permissions.isItemVisible)
        if !isItem {
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.view.addGestureRecognizer(swipeLeft)
        }
        
        
        
        if getDefaultSettings()?.staticJobId != nil {
            ChatManager.shared.getMessages(companyID: (getUserDetails()?.compId)!, jobid: getJobCodeForFirebase()) { (success) in
                if success{
                    self.createSection()
                }
            }
        }
       
        
         setLocalization()
        
        ActivityLog(module:Modules.job.rawValue , message: ActivityMessages.jobAdminChat)
        
        getJobCardTemplates()
        
        self.EmailView.isHidden = true
        let kprVar = objOfUserJobListInDetail?.kpr
        let kprArr = kprVar?.components(separatedBy: ",")
        
        var count : Int = 0
        var query : String = ""
        for item in kprArr! {
            
            if  count == 0 {
                query = "(usrId = \(item))"
            }else{
                query = query + " OR (usrId = \(item))"
            }
            count = count + 1
        }
       
        let fildW = DatabaseClass.shared.fetchDataFromDatabse(entityName: "FieldWorkerDetails", query: query) as! [FieldWorkerDetails]
        for fw in fildW {
            fwAr.append(("\(String(describing: fw.fnm!)) \(String(describing: fw.lnm!))"))
            jobIdPrints.append(("\(String(describing: fw.usrId!))"))
            self.SelectSingnaturetxtfied.text = ("\(String(describing: fw.fnm!)) \(String(describing: fw.lnm!))")
            
        }

      
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationResive), name: Notification.Name ("ChatVC"), object: nil)
        
    }
    
    @objc func NotificationResive(){
       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChatVC") , object: nil)
        showBackgroundView()
        view.addSubview(EmailView)
        self.EmailView.isHidden = false
        EmailView.center = CGPoint(x: backgoundView.frame.width/2, y: backgoundView.frame.height/2)
        print("tep")
    }
    
    func showBackgroundView() {
        self.backgoundView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.backgoundView.backgroundColor = UIColor.black
            self.backgoundView.alpha = 0.5
        })
    }
    func removeOptionalView(){
        if optionalVw != nil {
            self.optionalVw?.removeFromSuperview()
            self.optionalVw = nil
        }
    }
    func hideBackgroundView() {
        if ((optionalVw) != nil){
            removeOptionalView()
        }
        if (EmailView != nil) {
            EmailView.removeFromSuperview()
        }
        
        self.backgoundView.isHidden = true
        self.backgoundView.backgroundColor = UIColor.clear
        self.backgoundView.alpha = 1
    }
    @IBAction func SelectTemplatebtn(_ sender: UIButton) {
        arrayTypes = "2"
        self.forDefaultJobCrdOpenDwopDown()

    }
    
    @IBAction func SelectSingnaturebtn(_ sender: UIButton) {
        
        arrayTypes = "1"
        self.foSelectSingnatureOpenDwopDown()
    }
    
    @IBAction func EmailJobBtn(_ sender: Any) {
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        self.backgoundView.isHidden = false
        self.EmailView.isHidden = true
        ActivityLog(module:Modules.invoice.rawValue , message: ActivityMessages.jobInvoiceEmail)
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EMAILINVOICE") as! EmailInvoiceVC
        vc.isJobDetail = true
        vc.jobIdDetail = objOfUserJobListInDetail?.jobId as! String
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func PrintJobBtn(_ sender: Any) {
        if !isHaveNetowork(){
            ShowError(message: AlertMessage.networkIssue, controller: windowController)
            return
        }
        
        self.backgoundView.isHidden = false
        self.EmailView.isHidden = true
        let storyboard = UIStoryboard(name: "Invoice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pdfvc") as! ShowPdfVC
        vc.pdfDetailJob = true
        vc.pdfDetailJobId =  objOfUserJobListInDetail?.jobId as! String
        vc.jobIdLabel = objOfUserJobListInDetail?.label as! String
        vc.templateIdPrint = templatId
        vc.jobIdForPrint = jobIdPrint11
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        self.navigationController!.pushViewController(vc, animated: true)
    
    }
    
    @IBAction func topOnbackgud(_ sender: Any) {
        hideBackgroundView()
       
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrayTypes == "1" {
            return fwAr.count
        }else if self.arrayTypes == "2" {
            return JobCardTemplatAr.count
        }
        return jobIdPrints.count
        
    }
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:"cell")
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier:"cell")
        }
        if self.arrayTypes == "1" {
            if demoArr11.count != 0 {
                var ar = jobIdPrints[indexPath.row] as! String
                cell?.textLabel?.text = fwAr[indexPath.row] as! String
            }
        }else if self.arrayTypes == "2" {
            if fwAr.count != 0 {
                cell?.textLabel?.text = JobCardTemplatAr[indexPath.row].tempJson1?.clientDetails![0].inputValue
            }
            
        }
        
        
        return cell!
    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrayTypes == "1" {
            self.SelectSingnaturetxtfied.text = fwAr[indexPath.row] as! String
            self.jobIdPrint11 = jobIdPrints[indexPath.row] as! String
            self.removeOptionalView()
         
           
        }else if self.arrayTypes == "2" {
            self.SelectTemplatetxtfild.text = JobCardTemplatAr[indexPath.row].tempJson1?.clientDetails![0].inputValue
            self.templatId = JobCardTemplatAr[indexPath.row].jcTempId ?? ""
            self.removeOptionalView()
          
        }
        
     
    }
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.0
    }
    // ================================
    //  MARK: Open Drop Down jobcard
    // ================================
    func foSelectSingnatureOpenDwopDown() {

        if (optionalVw == nil){
            self.backgoundView.isHidden = false
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = SelectSingnatureView.convert(SelectSingnatureView.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 20, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height-5), width: self.view.frame.size.width - 40, height: 150))
             self.optionalVw?.delegate = self
            self.view.addSubview( self.optionalVw!)
            self.optionalVw?.removeOptionVwCallback = {(isRemove : Bool) -> Void in
                self.removeOptionalView()
               
            }
        }else{
            DispatchQueue.main.async {
                self.removeOptionalView()
            }
        }
    }

    func forDefaultJobCrdOpenDwopDown() {

        if (optionalVw == nil){
            self.backgoundView.isHidden = false
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView;
            let sltTxtfldFrm = DefaultJobCrdView.convert(DefaultJobCrdView.bounds, from: self.view)
            self.optionalVw?.setUpMethod(frame: CGRect(x: 20, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height-5), width: self.view.frame.size.width - 40, height: 150))
            self.optionalVw?.delegate = self
            self.view.addSubview( self.optionalVw!)
            self.optionalVw?.removeOptionVwCallback = {(isRemove : Bool) -> Void in
                self.removeOptionalView()
            }
        }else{
            DispatchQueue.main.async {
                self.removeOptionalView()
            }
        }
    }
   
    func getJobCardTemplates(){

        let param = Params()
       
        param.limit = "120"
        
        serverCommunicator(url: Service.getJobCardTemplates, param: param.toDictionary) { (response, success) in
               killLoader()
               if(success){
                   let decoder = JSONDecoder()
                   if let decodedData = try? decoder.decode(JobCardTemplatesRs.self, from: response as! Data) {
                       
                       if decodedData.success == true{
                           
                           self.JobCardTemplatAr = decodedData.data as! [JobCardTemplat]
                           DispatchQueue.main.async {
                               let arr = self.JobCardTemplatAr[0]
                            //   print( "\(String(describing: arr.tempJson1?.clientDetails![0].inputValue ?? ""))")
                               
                               self.templateVelues = "\(String(describing: arr.tempJson1?.clientDetails![0].inputValue ?? ""))"
                               self.SelectTemplatetxtfild.text =  self.templateVelues
                             //  self.txtFldInvoiceTmplt.text = self.templateVelue
                               self.templatId = arr.jcTempId ?? ""
                           }
                       }else{
                           ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                       }
                   }else{
                       
                      // ShowError(message: AlertMessage.formatProblem, controller: windowController)
                   }
               }else{
                   //ShowError(message: "Please try again!", controller: windowController)
               }
           }
           
       }
   
  

    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.title_chat
    }

        
    
    override func viewWillAppear(_ animated: Bool) {
        
       
        self.EmailView.isHidden = true
        self.backgoundView.isHidden = true
        self.tabBarController?.navigationItem.title = LanguageKey.title_chat
        self.registorKeyboardNotification()
        ChatManager.shared.currentjobID = getJobCodeForFirebase()
        ChatManager.shared.unreadCountZero(jobid: getJobCodeForFirebase())
        
        if let button = self.parent?.navigationItem.rightBarButtonItem {
            button.isEnabled = true
            button.tintColor = UIColor.white
        }
        
       ChatManager.shared.callback = {(model) in
                         let strDate = dayDifference(unixTimestamp: (model.time!))
                         if(self.arrOfFilterDict.count > 0){
                             if let index = (self.arrOfFilterDict.firstIndex { (dict) -> Bool in    dict[strDate] != nil }){
                                 var dictObj = self.arrOfFilterDict[index]
                                 dictObj[strDate]?.append(model)
                                 self.arrOfFilterDict[index] = dictObj
                             }else{
                                 self.arrOFData.removeAll()
                                 self.filterDict.removeAll()
                                 self.arrOFData.append(model)
                                 self.filterDict[strDate] = self.arrOFData
                                 self.arrOfFilterDict.append(self.filterDict)
                             }
                         }else{
                             self.arrOFData.append(model)
                             self.filterDict[strDate] = self.arrOFData
                             self.arrOfFilterDict.append(self.filterDict)
                         }
                         
                         if let index = (self.arrOfFilterDict.firstIndex { (dict) -> Bool in    dict[strDate] != nil }){
                             let rowCount = self.arrOfFilterDict[index][strDate]!.count
                             let lastIndexPath = IndexPath(item: rowCount-1, section: index)
                             
                             if lastIndexPath.row == 0 {
                                 self.tblView.reloadData()
                             }else{
                                 self.tblView.insertRows(at: [lastIndexPath], with: .bottom)
                             }
                             self.scrollTolastIndexPath()
                         }
                     }
        
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ChatManager.shared.currentjobID = ""
        ChatManager.shared.unreadCountZero(jobid: getJobCodeForFirebase())
        self.removeKeyboardNotification()
   }

    
    func scrollTolastIndexPath(){
        
        if arrOfFilterDict.count == 0 {
            return
        }
            // First figure out how many sections there are
            let lastSectionIndex = self.tblView!.numberOfSections - 1

        
        if lastSectionIndex > -1 {
            
            // Then grab the number of rows in the last section
            let lastRowIndex = self.tblView!.numberOfRows(inSection: lastSectionIndex) - 1
            
            // Now just construct the index path
            let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
            // Make the last row visible
            self.tblView?.scrollToRow(at: pathToLastRow, at: UITableView.ScrollPosition.none, animated: true)
            
        }
        
    }

    
    
     @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 4 { // set your total tabs here
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }

    
    @IBAction func btnAttachment(_ sender: Any) {
        openGallery()
    }
    
    
    @IBAction func btnSend(_ sender: Any) {
        
       // getDefaultSettings()?.staticJobId = nil
        if getDefaultSettings()?.staticJobId != nil {
            let trimmedString = trimString(string: txtView.text!)
            txtView.text = ""
            if trimmedString.count > 0 {
                self.sendImageOnFireStore(textMsg: trimmedString, imgUrl: "", contentType: "1")
            }
        }else{
            ShowError(message: AlertMessage.formatProblem, controller: windowController)
        }
        
        
        
    }
    
    
    func sendImageOnFireStore(textMsg:String , imgUrl:String, contentType: String) -> Void {
        let message = ChatMessageModel()
        message.usrnm = trimString(string: "\(getUserDetails()?.fnm ?? "") \(getUserDetails()?.lnm ?? "")")
        message.file = imgUrl
        message.msg = textMsg
        message.time = getCurrentTimeStamp()
        message.usrid = (getUserDetails()!.usrId ?? "")
        message.jobId = objOfUserJobListInDetail?.jobId!
        message.jobCode = objOfUserJobListInDetail?.label ?? ""
        message.type = contentType
        ChatManager.shared.sendMessage(jobid: getJobCodeForFirebase(), messageDict: message)
    }
    
    
    //=====================================
    //MARK:- Remove Keyboard Notification
    //=====================================
    func removeKeyboardNotification(){
        
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    func registorKeyboardNotification(){
       // IQKeyboardManager.shared.enable = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //========================================
    //MARK:-  Key Board notification method
    //========================================
    @objc func keyboardWillShow(notification: NSNotification) {
        self.moveView(userInfo: notification.userInfo as! [String : Any], up: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.moveView(userInfo: notification.userInfo as! [String : Any], up: false)
    }
    
    func moveView(userInfo : [String : Any] , up : Bool){
        if up {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.containerVw_H.constant = keyboardSize.height - 50 - self.bottomSafeArea
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                self.scrollTolastIndexPath()
            }
        }else {
            self.containerVw_H.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            self.scrollTolastIndexPath()
        }
    }

    
    //=============================
    // MARK:- Open gallery methods
    //=============================
    func openGallery(){
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: LanguageKey.please_select, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: LanguageKey.cancel, style: .cancel) { _ in
            //print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: LanguageKey.gallery, style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary;
                self.imagePicker.allowsEditing = false
                APP_Delegate.showBackButtonText()
                self.isRemove = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: LanguageKey.camera, style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera;
                self.imagePicker.allowsEditing = true
                APP_Delegate.showBackButtonText()
                self.isRemove = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
   
        let docButton = UIAlertAction(title: LanguageKey.document, style: .default)
        { _ in
            
            let kUTTypeDOC = "com.microsoft.word.doc" // for Doc file
            let kUTTypeDOCX = "org.openxmlformats.wordprocessingml.document" // for Docx file
            let kUTTypeXls = "com.microsoft.excel.xls"
            let kUTTypeXlsx = "org.openxmlformats.spreadsheetml.sheet"
            
            //'jpg','png','jpeg','pdf','doc','docx','xlsx','csv','xls'
            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePNG),String(kUTTypeJPEG),String(kUTTypePDF),String(kUTTypeCommaSeparatedText),kUTTypeXls,kUTTypeXlsx,kUTTypeDOCX,kUTTypeDOC], in: .import)
            documentPicker.delegate = self
             APP_Delegate.showBackButtonTextForFileMan()
            self.present(documentPicker, animated: true, completion: nil)
           
        }
        actionSheetControllerIOS8.addAction(docButton)
        self.isRemove = false
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    //=====================================
    // MARK:- SECTIONS for JOBLIST
    //=====================================
    
    func createSection(){
        
            if(self.arrOfFilterDict.count != 0){
                self.arrOFData.removeAll()
                self.filterDict.removeAll()
                self.arrOfFilterDict.removeAll()
            }

            for objOfUserData in ChatManager.shared.chatList {
                let strDate = dayDifference(unixTimestamp: (objOfUserData.time!))
                if(self.arrOfFilterDict.count > 0){
                    if let index = (self.arrOfFilterDict.firstIndex { (dict) -> Bool in    dict[strDate] != nil }){
                        var dictObj = self.arrOfFilterDict[index]
                        dictObj[strDate]?.append(objOfUserData)
                        self.arrOfFilterDict[index] = dictObj
                    }else{
                        self.arrOFData.removeAll()
                        self.filterDict.removeAll()
                        self.arrOFData.append(objOfUserData)
                        self.filterDict[strDate] = self.arrOFData
                        self.arrOfFilterDict.append(self.filterDict)
                    }
                }else{
                    self.arrOFData.append(objOfUserData)
                    self.filterDict[strDate] = self.arrOFData
                    self.arrOfFilterDict.append(self.filterDict)
                }
            }
        
        
        DispatchQueue.main.async {
            self.tblView.reloadData()
            self.scrollTolastIndexPath()
        }
    }
    
    
    
    func uploadMedia(fileName : String ,uploadData : Data ,completion: @escaping (_ url: String?, _ contentType: String?) -> Void) {
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"

        
        let storageRef = Storage.storage().reference().child("\((getUserDetails()?.compId)!)/\(objOfUserJobListInDetail!.jobId!)/\(getCurrentTimeStamp())_\(fileName)")
        
        //let uploadTask =    storageRef.putData(uploadData, metadata: nil)
        
        let uploadTask =    storageRef.putData(uploadData, metadata: metaData){ (metadata, error) in
            if error != nil {
                //print("error")
               // completion(nil, nil)
            } else {
                let imageURL = Storage.storage().reference(forURL:  Storage.storage().reference().description).child((metadata?.path!)!)
                imageURL.downloadURL(completion: { (url, error) in
                    completion("\(url!)", metadata?.contentType)
                })
            }
        }
        
        
        //When uploading  is inprogress ....
        uploadTask.observe(.progress, handler: { (snapshot) in
            guard let progress = snapshot.progress else {
                return
            }
            
            let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                if self.loadingNotification == nil{
                    self.loadingNotification = MBProgressHUD.showAdded(to: windowController.view, animated: true)
                }
                self.loadingNotification!.mode = MBProgressHUDMode.determinateHorizontalBar
                self.loadingNotification!.label.text = "\(Int(percentage))%"
                self.loadingNotification?.detailsLabel.text = "Uploading..."
                self.loadingNotification!.progressObject = progress
        })
        
        //When uploading completed...
        uploadTask.observe(.success) { snapshot in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: windowController.view, animated: true)
                self.loadingNotification = nil
            }
        }
        
//        uploadTask.observe(.failure) { (snapshot) in
//            DispatchQueue.main.async {
//                MBProgressHUD.hide(for: windowController.view, animated: true)
//                self.loadingNotification = nil
//            }
//
//        }
    }
    
    
    
    ///////////////////// for pdf //////////////////////
    
    func uploadMedia_Pdf(fileName : String, mimeType : String ,uploadData : Data ,completion: @escaping (_ url: String?, _ contentType: String?) -> Void) {
        
        /// new code added for compatibility with android and web ///////////
        
        let metaData = StorageMetadata()
        metaData.contentType = mimeType // "pdf"
        
        /// ///////////////// ///////////
        
        
        let storageRef = Storage.storage().reference().child("\((getUserDetails()?.compId)!)/\(objOfUserJobListInDetail!.jobId!)/\(getCurrentTimeStamp())_\(fileName)")
        
        // let uploadTask =    storageRef.putData(uploadData, metadata: metaData){ (metadata, error) in
        let uploadTask =    storageRef.putData(uploadData, metadata: metaData){ (metadata, error) in
            if error != nil {
                //print("error")
                completion(nil, nil)
            } else {
                let imageURL = Storage.storage().reference(forURL:  Storage.storage().reference().description).child((metadata?.path!)!)
                imageURL.downloadURL(completion: { (url, error) in
                    completion("\(url!)", metadata?.contentType)
                })
            }
        }
        
        
        //When uploading  is inprogress ....
        uploadTask.observe(.progress, handler: { (snapshot) in
            guard let progress = snapshot.progress else {
                return
            }
            
            let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
            if self.loadingNotification == nil{
                self.loadingNotification = MBProgressHUD.showAdded(to: windowController.view, animated: true)
            }
            self.loadingNotification!.mode = MBProgressHUDMode.determinateHorizontalBar
            self.loadingNotification!.label.text = "\(Int(percentage))%"
            self.loadingNotification?.detailsLabel.text = "Uploading..."
            self.loadingNotification!.progressObject = progress
        })
        
        //When uploading completed...
        uploadTask.observe(.success) { snapshot in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: windowController.view, animated: true)
                self.loadingNotification = nil
            }
        }
        
//        uploadTask.observe(.failure) { snapshot in
//            DispatchQueue.main.async {
//                MBProgressHUD.hide(for: windowController.view, animated: true)
//                self.loadingNotification = nil
//            }
//        }
    }
    
    
    
    ///////////////////////////////////////////////////
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        let tappedImage = sender!.view as! UIImageView
        EXPhotoViewer.showImage(from: tappedImage)
    }
    
    
    func getJobCodeForFirebase() -> String {
        
        ////Check
        if let aar =  Int(self.objOfUserJobListInDetail?.jobId ?? "") {
            if Int(getDefaultSettings()!.staticJobId!)! > aar {
                return   "\((self.objOfUserJobListInDetail?.label)!)-\((self.objOfUserJobListInDetail?.jobId)!)"
            }else{
                return  (self.objOfUserJobListInDetail?.jobId)!
            }
        }else{
             return (self.objOfUserJobListInDetail?.jobId)!
        }
       
 
    }
    
}




extension ChatVC: UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {
            APP_Delegate.hideBackButtonText()
            self.isRemove = true
        })
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        

        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == .denied || status == .restricted) {
            ShowAlert(title: "", message: AlertMessage.photo_denied, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: {_,_ in})
            return
        }else{
            
            
            PHPhotoLibrary.requestAuthorization { (authStatus) in
                if authStatus == .authorized{
                    let imageAsset = PHAsset.fetchAssets(with: .image, options: nil)
                    // for index in 0..<imageAsset.count{
                    
                    if imageAsset.count > 0{
                        let asset = imageAsset.firstObject
                        let imgFullName = asset?.value(forKey: "filename") as! String
                        let arr = imgFullName.components(separatedBy: ".")
                        let imgExtension = arr.last
                        let imgName = imgFullName.replacingOccurrences(of: ".\(imgExtension!)", with: "")
                        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]{
                            self.showPhotoEditor(withImage:(image as! UIImage),andImageName: trimString(string: imgName))
                        }
                    }
                }
            }
        }
        
        
        dismiss(animated:true, completion: {
           // APP_Delegate.hideBackButtonText()
            self.isRemove = true
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrOfFilterDict.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: Int(self.tblView.frame.size.width), height: 30)
        headerView.backgroundColor = UIColor(red: 246.0/255.0, green: 242.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        
         let headerLabel = UILabel(frame: CGRect(x: 0, y: 10, width:
            headerView.bounds.size.width, height: 20))
        
        headerLabel.font = Font.ArimoBold(fontSize: 13.0)
        headerLabel.textColor = UIColor(red: 115.0/255.0, green: 125.0/255.0, blue: 126.0/255.0, alpha: 1.0)
        
        let dict = self.arrOfFilterDict[section]
        let firstKey = Array(dict.keys)[0]
        let arr = firstKey.components(separatedBy: ",")
        let att = changeColoreOFDate(main_string: firstKey, string_to_color: arr[0])
        
        if(arr[0] == "Today" || arr[0] == "Yesterday" || arr[0] == "Tomorrow" ) {
            headerLabel.attributedText = att
        }else{
            headerLabel.text = att.string
        }
        
        headerLabel.textAlignment = .center;
      //  DispatchQueue.main.async {
            headerView.addSubview(headerLabel)
      //  }
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        if(self.arrOfFilterDict.count != 0){
            let dict = self.arrOfFilterDict[section]
            let firstKey = Array(dict.keys)[0] // or .first
             let arr = dict[firstKey]!
            return arr.count
        }else{
            return arrOfFilterDict.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = self.arrOfFilterDict[indexPath.section]
        let firstKey = Array(dict.keys)[0] // or .first
        let arr = dict[firstKey]
        let message = arr![indexPath.row]
      //  let aaa =  arr![indexPath.row-1]

        if (((message.file != nil) && message.file != "" && (message.type?.hasPrefix("image"))!  == false)) || (message.type == "image/gif") {
             let cell = tableView.dequeueReusableCell(withIdentifier: "chatAttach") as! ChatAttachmentCell

            if message.usrid == getUserDetails()?.usrId {
                cell.rightTralling.priority = UILayoutPriority(rawValue: 999)
                cell.leftTralling.priority = UILayoutPriority(rawValue: 998)
                cell.rightTralling.constant = 5.0
                
                if message.usrnm != nil && message.usrnm != "" { // Username available or not
                    cell.lblName.text =  "me"
                }else{
                    cell.lblName.text = "Unknown"
                }
            }else{
                cell.rightTralling.priority = UILayoutPriority(rawValue: 998)
                cell.leftTralling.priority = UILayoutPriority(rawValue: 999)
                cell.leftTralling.constant = 5.0
                
                if message.usrnm != nil && message.usrnm != "" { // Username available or not
                    cell.lblName.text = message.usrnm!.capitalized
                }else{
                    cell.lblName.text = "Unknown"
                }
            }
            
                if let time = message.time { // Time Check
                    cell.lbltiME.text = convertTimestampToDateString(timeInterval: (time ))
                }else{
                    cell.lbltiME.text = ""
                }
            
      
             cell.lblDescription.text = "Open file"
             cell.lblDescription.textColor = UIColor(red: 0/255, green: 219/255, blue: 255/255, alpha: 1.0)
             cell.btnOpenLink.addTarget(self, action: #selector(openURLOnBtnClieck(sender:)), for: UIControl.Event.touchUpInside)
             cell.btnOpenLink.setTitle("\(indexPath.section)+\(indexPath.row)", for: .normal)
             cell.btnOpenLink.tag = indexPath.section*10 + indexPath.row
              return cell
        }else if message.usrid == getUserDetails()?.usrId {
                let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell") as! senderCell
                
                if message.usrnm != nil && message.usrnm != ""{ // Username available or not
                    cell.lblUser.text = "me"
                }else{
                    cell.lblUser.text = "Unknown"
                }
                
                if let msg = message.msg { // Message check
                    cell.txtView.text = (msg )
                }else{
                    cell.txtView.text = ""
                }
                
                cell.txtView.textContainer.maximumNumberOfLines = 0
                cell.txtView.textContainer.lineBreakMode = .byWordWrapping
                cell.txtView.textContainerInset = .zero  // // Remove all padding
                cell.txtView.contentInset = UIEdgeInsets.init(top: 0, left: -5, bottom: 0, right: 0)
                cell.txtView.sizeToFit()
                
            
            let timeVelue = convertTimestampToDateString(timeInterval: (message.time!))
            let arrs = timeVelue.components(separatedBy: " ")
            //print(arr[0])
           // print(arr[1])
            
            cell.lblTime.text = timeVelue
            if indexPath.row > 1 {
                
                let lastMessage = arr![indexPath.row-1]
                let lastTimeVelue = convertTimestampToDateString(timeInterval: (lastMessage.time!))
                if lastTimeVelue == timeVelue && lastMessage.usrid == message.usrid {
                    
                    cell.lblTime.text = ""
                }
                
            }
            
            
            
            
//            if let time = message.time {
//
//                // Time Check
//
//                cell.lblTime.text = convertTimestampToDateString(timeInterval: (time ))
//
//            }else{
//                cell.lblTime.text = ""
//            }
           
      
                
                if ((message.file != nil) && message.file != "") { // Check if File available
                    cell.imgHeight.constant = 150
                    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                    cell.imgView.addGestureRecognizer(tap)
                       if(message.type == "image/gif"){
                            let gifURL : String = message.file!
                            let imageURL = UIImage.gifImageWithURL(gifURL)
                            cell.imgView.image = imageURL
                       }else{
                            cell.imgView.sd_setImage(with: URL(string: message.file!) , placeholderImage: UIImage(named: "default-thumbnail"))
                    }
                }else{
                    cell.imgView.image = nil
                    cell.imgHeight.constant = 0
                    cell.setNeedsUpdateConstraints()
                    cell.updateConstraintsIfNeeded()
                }
                cell.sizeToFit()
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell
                
                if  message.usrnm != nil && message.usrnm != "" { //Check username
                    cell.lblUser.text = message.usrnm!.capitalized
                }else{
                    cell.lblUser.text = "Unknown"
                }
                
                if let msg = message.msg { // Message check
                    cell.txtView.text = msg
                }else{
                    cell.txtView.text = ""
                }
                cell.txtView.textContainer.maximumNumberOfLines = 0
                cell.txtView.textContainer.lineBreakMode = .byWordWrapping
                cell.txtView.textContainerInset = .zero // // Remove all padding
                cell.txtView.contentInset = UIEdgeInsets.init(top: 0, left: -5, bottom: 0, right: 0)
                cell.txtView.sizeToFit()
                
            let timeVelue = convertTimestampToDateString(timeInterval: (message.time!))
                     let arrs = timeVelue.components(separatedBy: " ")
                     //print(arr[0])
                    // print(arr[1])
                     
                     cell.lblTime.text = timeVelue
                     if indexPath.row > 1 {
                         
                         let lastMessage = arr![indexPath.row-1]
                         let lastTimeVelue = convertTimestampToDateString(timeInterval: (lastMessage.time!))
                         if lastTimeVelue == timeVelue && lastMessage.usrid == message.usrid {
                             
                             cell.lblTime.text = ""
                         }
                         
                     }
                
            
            
//                if let time = message.time {  // Time Check
//                    cell.lblTime.text = convertTimestampToDateString(timeInterval: time )
//                }else{
//                    cell.lblTime.text = ""
//                }
                
                if ((message.file != nil) && message.file != ""){ // Check if File available
                    cell.imgHeight.constant = 150
                    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                    cell.imgView.addGestureRecognizer(tap)
                    if(message.type == "image/gif"){
                        let gifURL : String = message.file!
                        let imageURL = UIImage.gifImageWithURL(gifURL)
                        cell.imgView.image = imageURL
                    
                    }else{

                        cell.imgView.sd_setImage(with: URL(string: message.file!) , placeholderImage: UIImage(named: "default-thumbnail"))
                    }

                }else{
                    cell.imgView.image = nil
                    cell.imgHeight.constant = 0
                    cell.setNeedsUpdateConstraints()
                    cell.updateConstraintsIfNeeded()
                }
                cell.sizeToFit()
                return cell
            }
    }
    
    
    
    @objc func openURLOnBtnClieck(sender: UIButton){
        
        let title =  sender.titleLabel?.text
        
        let myStringArr = title!.components(separatedBy: "+")

        let dict = self.arrOfFilterDict[Int(myStringArr[0])!]
        let firstKey = Array(dict.keys)[0] // or .first
        let arr = dict[firstKey]
        let message = arr![Int(myStringArr[1])!]
        
        if message.file != nil && message.file != "" {
            //  UIApplication.shared.open(URL(string: message.file!)!)
            
            if let url = URL(string: message.file!){
                let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "docViewVC") as! DocumentViewVC
                vc.fileUrl = url
                vc.isRename = false
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
                self.navigationController!.pushViewController(vc, animated: true)
                // UIApplication.shared.open(url)
            }else{
                ShowError(message: LanguageKey.format_problem, controller: windowController)
            }
            
            
            
        }else{
            ShowError(message: AlertMessage.cant_open_this_file, controller: windowController)
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

extension ChatVC: UIDocumentPickerDelegate , PhotoEditorDelegate{
    
    
    //=============================
    // MARK:- Image editor methods
    //=============================
    
    func showPhotoEditor(withImage:UIImage, andImageName:String) -> Void {
        DispatchQueue.main.async {
            let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
            photoEditor.photoEditorDelegate = self
            photoEditor.hiddenControls = [.sticker, .text, .save, .share]
            photoEditor.image = withImage
            photoEditor.imageName = andImageName
            photoEditor.imageNamePlaceholder = LanguageKey.enter_file_name
        
            photoEditor.modalPresentationStyle = .fullScreen
            self.present(photoEditor, animated: true, completion: nil)
        }
    }
    
    
    func doneEditing(image: UIImage, imageName: String) {
        DispatchQueue.main.async {
            APP_Delegate.hideBackButtonText()
        }
        
        if let imgData = image.jpegData(compressionQuality: 0.5) {
            self.uploadMedia(fileName: imageName, uploadData: imgData , completion: { (url, contentType)  in
                self.sendImageOnFireStore(textMsg: "", imgUrl: url!, contentType: contentType!)
            })
        }
        
    }
    
    
    func canceledEditing() {
        DispatchQueue.main.async {
            APP_Delegate.hideBackButtonText()
        }
        // print("Canceled")
    }

    //=============================
    // MARK:- Document picker methods
    //=============================
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        isRemove = true
        APP_Delegate.hideBackButtonText()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
       // print(url)
        
        let filename = url.lastPathComponent
        let splitName = filename.split(separator: ".")
        let name = splitName.first!
        let filetype = splitName.last!.lowercased()
        let mimeType = mimeTypeForPath(path: url)
        isRemove = true
        APP_Delegate.hideBackButtonText()
        
        //'jpg','png','jpeg'
        if filetype == "jpg" || filetype == "png" || filetype == "jpeg" {
            
            do {
                let imageData = try Data(contentsOf: url as URL)
                
                if let image = UIImage(data: imageData) {
                    APP_Delegate.showBackButtonText()
                    self.showPhotoEditor(withImage: image, andImageName: filename)
                }
            }
            catch {
                // can't load image data
            }
        }else{
            //openImageNameAlert(imgName: String(name), fileUrl: url)
            let storyboard = UIStoryboard(name: "MainJob", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "docViewVC") as! DocumentViewVC
            let navController = UINavigationController(rootViewController: vc)
            vc.fileUrl = url
            vc.isRename = true
            vc.imageName = String(name)
            vc.callback = {(imageName,description) in
               // self.uploadMediaDocuments(fileUrl: url, fileName: imageName)
                    do {
                        let imageData = try Data(contentsOf: url as URL)
                        self.uploadMedia_Pdf(fileName: imageName, mimeType: mimeType, uploadData: imageData , completion: { (url, contentType)  in
                            self.sendImageOnFireStore(textMsg: "", imgUrl: url!, contentType: contentType!)
                        })
                    } catch {
                       // print("Unable to load data: \(error)")
                    }
                
            }
            DispatchQueue.main.async {
                self.navigationController!.present(navController, animated: true, completion: nil)
            }
            
            //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        }

        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        do {
//            let imageData = try Data(contentsOf: url as URL)
//            self.uploadMedia_Pdf(fileName: fileName, uploadData: imageData , completion: { (url, contentType)  in
//                self.sendImageOnFireStore(textMsg: "", imgUrl: url!, contentType: contentType!)
//            })
//        } catch {
//           // print("Unable to load data: \(error)")
//        }
    }
}
