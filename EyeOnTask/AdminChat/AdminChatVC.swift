//
//  AdminChatVC.swift
//  EyeOnTask
//
//  Created by Jugal Shaktawat on 25/03/20.
//  Copyright © 2020 Hemant. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos
import MBProgressHUD
import SDWebImage
import IQKeyboardManagerSwift
import MobileCoreServices

class AdminChatVC: UIViewController, UITextViewDelegate,OptionViewDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var containerVw_H: NSLayoutConstraint!
    
    @IBOutlet weak var usersTxtFld: UITextField!
    var isRemove = true
    var arrOFData = [ChatUserMessageModel]() // before ChatResponseModel
    var filterDict = [String : [ChatUserMessageModel]]() // before ChatResponseModel
    var arrOfFilterDict  = [[String : [ChatUserMessageModel]]]() // before ChatResponseModel
    var bottomSafeArea:CGFloat = 0.0
    var userData  : UserModel!
    var imagePicker = UIImagePickerController()
    let selfName = trimString(string: "\(getUserDetails()?.fnm ?? "") \(getUserDetails()?.lnm ?? "")")
    var sltDropDownTag : Int!
    var optionalVw : OptionalView?
    var groupArr = [String]()
    var groupNameArr = [String]()
    let cellReuseIdentifier = "cell"
    deinit {
        print("is not Chatting user")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dd = userData.yourArray
        //                let userArry = (dd["usrId"] as! Array<String>)
        //                for i in dd["usrId"] as! Array<String>)  {
        //                    print(i)
        //                    let UsrId = i.usrId
        //                        print(UsrId)
        //
        //                }
        
        let window = UIApplication.shared.keyWindow
        if #available(iOS 11.0, *) {
            bottomSafeArea = (window?.safeAreaInsets.bottom)!
        }
        
        SetBackBarButtonCustom()
        
        tblView.estimatedRowHeight = 80.0
        tblView.rowHeight = UITableView.automaticDimension
        //saveUserDetailsusrId(userDetails : self.userData.usrIdvelue!)
        let usrId = self.userData.usrIdvelue
        // print(usrId)
        UserDefaults.standard.set(usrId, forKey: "usrId")
        let on = self.userData.isTeam
        UserDefaults.standard.set(on, forKey: "isTeam")
        
        if self.userData.isTeam == "0" {
            if userData.documentID == nil { // first time jane par nill ayegi ID
                ChatManager.shared.createNewChatMessagesNode(userid: userData.user!.usrId!)
            }
        }else{
            if userData.user?.teamMemId != nil {
                for kprData in (userData.user?.teamMemId as! [AnyObject]) {
                    if ((kprData as! [String:String])["usrNm"] != nil){
                        let dicts = (kprData as! [String:String])["usrNm"]
                        
                        groupNameArr.append(dicts as! String)
                        
                    }
                    
                }
            }
            /////////////////////////////////////////////////////////////FOR GROUP///////////////////////////////////
            if userData.documentID == nil {
                
                if userData.user?.teamMemId != nil {
                    for kprData in (userData.user?.teamMemId as! [AnyObject]) {
                        if ((kprData as! [String:String])["usrId"] != nil){
                            let dicts = (kprData as! [String:String])["usrId"]
                            
                            groupArr.append(dicts as! String)
                            
                        }
                        
                    }
                    
                }
                ChatManager.shared.createNewChatMessagesNodeforGroup(userid: userData.user!.usrId!,arrGrp:groupArr )
            }
            /////////////////////////////////////////////////////FOR GROUP////////////////////
        }
        
        userData.callbackForUserInactive = {
            windowController.showToast(message: "\(self.userData.fullName ?? "This user") is inactive from admin side")
            self.onClcikBack()
        }
        
        
        
        if (userData.unreadCount != nil) && Int(userData.unreadCount!)! > 0 {
            userData.user?.readcount = "\(userData.messages.count)"  // set count value nil for badge count
            userData.unreadCount = "0"
        }
        
        userData.isChatting = true
        userData.callbackForNewSnapshotDocument = {
            self.createSection()
        }
        
        
        self.createSection()
        setLocalization()
    }
    
    func setLocalization() -> Void {
        self.navigationItem.title = userData.fullName?.capitalizingFirstLetter() //LanguageKey.client_fw_chat
    }
    
    
    func SetBackBarButtonCustom(){
        let button = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action:#selector(AuditVC.onClcikBack))
        self.navigationItem.leftBarButtonItem  = button
    }
    
    @objc func onClcikBack(){
        
        userData.isChatting = false
        userData.callbackForUserInactive = nil
        userData.callbackForNewSnapshotDocument = nil
        
        
        _ = self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = LanguageKey.client_fw_chat
        self.registorKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.removeKeyboardNotification()
    }
    
    
    func scrollTolastIndexPath(){
        
        if arrOfFilterDict.count == 0 {
            return
        }
        // First figure out how many sections there are
        let lastSectionIndex = self.tblView!.numberOfSections - 1
        
        // Then grab the number of rows in the last section
        let lastRowIndex = self.tblView!.numberOfRows(inSection: lastSectionIndex) - 1
        
        // Now just construct the index path
        let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        // Make the last row visible
        self.tblView?.scrollToRow(at: pathToLastRow, at: UITableView.ScrollPosition.none, animated: true)
    }
    
    
    @IBAction func showUsersList(_ sender: UIButton) {
        
        self.sltDropDownTag = sender.tag
        switch  sender.tag {
        case 0:
            
            if(self.optionalVw == nil){
                
                //  arrOfShowData = getJson(fileName: "location")["Server_location"] as! [Any]
                self.openDwopDown( txtField: self.usersTxtFld, arr: groupNameArr)
                
            }else{
                self.removeOptionalView()
            }
            
            break
            
            
        default:
            print("Defalt")
            break
            
        }
        
    }
    
    @IBAction func btnAttachment(_ sender: Any) {
        openGallery()
    }
    
    
    @IBAction func btnSend(_ sender: Any) {
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
    //    func createUsersModelsWithFirestoreListner() -> Void {
    //        let userList = DatabaseClass.shared.fetchDataFromDatabse(entityName: "Users", query: nil) as? [Users]
    //    }
    func sendImageOnFireStore(textMsg:String , imgUrl:String, contentType: String) -> Void {
        let message = ChatUserMessageModel() //Create message
        message.content = textMsg
        message.createdAt = getCurrentTimeStamp()
        message.senderId = (getUserDetails()!.usrId ?? "")
        if self.userData.isTeam == "1" {
            message.senderNm = self.userData.fullName ?? "This user"
        }
        if self.userData.isTeam == "0" {
            
            if let documentId = userData.documentID {
                ChatManager.shared.sendUsersMessage(documentId: documentId, messageDict: message)
                self.sendPushNotification(model: message)
            }
        }else{
            //                    var isSwitchOff = ""
            //                    isSwitchOff =   UserDefaults.standard.value(forKey: "documentID") as? String ?? ""
            //                    print("FOR chat-----------\(isSwitchOff)")
            //                    var jj = isSwitchOff
            //                    userData.documentID = jj
            if let documentId = userData.documentID {
                ChatManager.shared.sendUsersMessage(documentId: documentId, messageDict: message)
                
                // self.sendPushNotification(model: message)
            }
        }
        
    }
    
    
    func sendPushNotification(model: ChatUserMessageModel)  {
        if userData.isOnline == false {
            if let recieverId = userData.user?.usrId{
                
                var subtitle = ""
                if let document = model.doc {
                    if isPngJpgJpegImage(fileExtention: URL(string: document)!.fileExtention()) {
                        subtitle = "📷  Photo"
                    }else{
                        subtitle = "📎  Attachment"}
                }else{
                    subtitle = model.content ?? ""
                }
                let notificationModel = ChatNotificationModel(title: selfName, subtitle: subtitle, senderId: (getUserDetails()?.usrId)!, msgUrl: model.doc ?? "")
                ChatManager.shared.sendFirebaseNotificationFromServer(offlineUsers: [recieverId], message: notificationModel, notificationType: "one2one")
            }
        }
    }
    
    
    //=====================================
    //MARK:- Remove Keyboard Notification
    //=====================================
    func removeKeyboardNotification(){
        
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    func registorKeyboardNotification(){
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
                self.containerVw_H.constant = keyboardSize.height - 1 - self.bottomSafeArea
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
        
        for  objOfuserData in userData.messages {
            let strDate = dayDifference(unixTimestamp: (objOfuserData.createdAt!))
            if(self.arrOfFilterDict.count > 0){
                if let index = (self.arrOfFilterDict.firstIndex { (dict) -> Bool in    dict[strDate] != nil }){
                    var dictObj = self.arrOfFilterDict[index]
                    dictObj[strDate]?.append(objOfuserData)
                    self.arrOfFilterDict[index] = dictObj
                }else{
                    self.arrOFData.removeAll()
                    self.filterDict.removeAll()
                    self.arrOFData.append(objOfuserData)
                    self.filterDict[strDate] = self.arrOFData
                    self.arrOfFilterDict.append(self.filterDict)
                }
                
            }else{
                self.arrOFData.append(objOfuserData)
                self.filterDict[strDate] = self.arrOFData
                self.arrOfFilterDict.append(self.filterDict)
            }
        }
        
        
        DispatchQueue.main.async {
            
            
            self.tblView.reloadData()
            self.scrollTolastIndexPath()
        }
        
    }
    
    
    
    //=====================================
    // MARK:- Upload image file
    //=====================================
    
    func uploadDocuments(imgName : String, imageDes : String,imageFile : UIImage, completion : @escaping (()->(Void))) -> Void {
        
        if !isHaveNetowork() {
            DispatchQueue.main.async {
                ShowError(message: AlertMessage.checkNetwork, controller: windowController)
            }
            return
        }
        
        showLoader()
        
        serverCommunicatorUplaodImage(url: Service.uploadChatDocument, param: nil, image: imageFile, imagePath: "cd", imageName: imgName) { (response, success) in
            if(success){
                let decoder = JSONDecoder()
                
                completion()
                
                if let decodedData = try? decoder.decode(UserUploadChatDocRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        DispatchQueue.main.async{
                            killLoader()
                            if (decodedData.data?.count ?? 0) > 0 {
                                let message = ChatUserMessageModel() //Create message
                                message.doc = decodedData.data![0].attachFileName!
                                message.createdAt = getCurrentTimeStamp()
                                message.senderId = (getUserDetails()!.usrId ?? "")
                                
                                if let documentId = self.userData.documentID {
                                    ChatManager.shared.sendUsersMessage(documentId: documentId, messageDict: message)
                                    self.sendPushNotification(model: message)
                                }
                                
                            }
                            self.showToast(message: getServerMsgFromLanguageJson(key: decodedData.message!)!)
                        }
                    }else{
                        killLoader()
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                killLoader()
                ShowError(message: errorString, controller: windowController)
            }
        }
    }
    
    
    
    //=====================================
    // MARK:- Upload Documents
    //=====================================
    
    func uploadMediaDocuments(fileUrl : URL ,fileName : String, description : String, completion : @escaping (()->(Void))) -> Void {
        
        showLoader()
        serverCommunicatorUplaodDocuments(url: Service.uploadChatDocument, param: nil, docUrl: fileUrl, DocPathOnServer: "cd", docName: fileName) { (response, success) in
            
            completion()
            
            if(success){
                
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(UserUploadChatDocRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        DispatchQueue.main.async{
                            killLoader()
                            if (decodedData.data?.count ?? 0) > 0 {
                                let message = ChatUserMessageModel() //Create message
                                message.doc = decodedData.data![0].attachFileName!
                                message.createdAt = getCurrentTimeStamp()
                                message.senderId = (getUserDetails()!.usrId ?? "")
                                
                                if let documentId = self.userData.documentID {
                                    ChatManager.shared.sendUsersMessage(documentId: documentId, messageDict: message)
                                    self.sendPushNotification(model: message)
                                }
                            }
                            self.showToast(message: getServerMsgFromLanguageJson(key: decodedData.message!)!)
                        }
                    }else{
                        killLoader()
                        ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                    }
                }else{
                    killLoader()
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton:  LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                killLoader()
                ShowError(message: errorString, controller: windowController)
            }
        }
        
    }
    
    
    
    
    ///////////////////////////////////////////////////
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        let tappedImage = sender!.view as! UIImageView
        EXPhotoViewer.showImage(from: tappedImage)
    }
    //==========================
    //MARK:- Open OptionalView
    //==========================
    
    func optionView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    func optionView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupNameArr.count
    }
    
    
    func optionView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if(cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 13.0)
        cell?.backgroundColor = .clear
        
        cell?.textLabel?.textColor = UIColor.darkGray
        //  print(arrOfTaxLocation[indexPath.row].location ?? "")
        
        //        if isSelect == true {
        //            cell?.accessoryType = UITableViewCell.AccessoryType.none
        //        }else{
        
        //            if isdidSelect == true {
        //                var locId = ""
        //                locId = UserDefaults.standard.value(forKey: "isLocId") as? String ?? ""
        //                if locId == arrOfTaxLocation[indexPath.row].locId{
        //                    cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
        //                    // return true
        //                }else{
        //                    cell?.accessoryType = UITableViewCell.AccessoryType.none
        //                    //  return false
        //                }
        //            }else
        //            {
        //                if objOfUserJobListInDetail.locId == arrOfTaxLocation[indexPath.row].locId{
        //                    cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
        //                    // return true
        //                }else{
        //                    cell?.accessoryType = UITableViewCell.AccessoryType.none
        //                    //  return false
        //                }
        //            }
        //
        // }
        
        
        
        cell?.textLabel?.text = groupNameArr[indexPath.row]
        // let language = locationArr[indexPath.row]
        //                 switch self.sltDropDownTag {
        //                      case 0:
        //                        cell?.textLabel?.text = arrOfTaxLocation[indexPath.row].location
        //                          break
        //
        //                      default: break
        //
        //                      }
        
        
        
        return cell!
    }
    
    func optionView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //             if (sltDropDownTag == 0) {
        //                self.removeBtnText.isHidden = false
        //                self.isdidSelect = true
        //                isSelect = false
        //                self.txtLocation.text = arrOfTaxLocation[indexPath.row].location
        //                print(arrOfTaxLocation[indexPath.row].locId)
        //                print(arrOfTaxLocation[indexPath.row].stateId)
        //                              // getLocation = countryID!
        //                locId = arrOfTaxLocation[indexPath.row].locId!
        //                var locId = arrOfTaxLocation[indexPath.row].locId
        //                UserDefaults.standard.set(locId, forKey: "isLocId")
        //
        //              }
        //              self.removeOptionalView()
    }
    
    
    func openDwopDown(txtField : UITextField , arr : [Any]) {
        
        if (optionalVw == nil){
            self.optionalVw = OptionalView.instanceFromNib() as? OptionalView
            self.optionalVw?.delegate = self
            let sltTxtfldFrm = txtField.convert(txtField.bounds, from: self.view)
            self.optionalVw?.removeOptionVwCallback = {(isRemove : Bool) -> Void in
                self.removeOptionalView()
            }
            self.optionalVw?.setUpMethod(frame: CGRect(x: 10, y: ((-sltTxtfldFrm.origin.y) + sltTxtfldFrm.size.height), width: self.view.frame.size.width - 20, height: CGFloat(arr.count > 5 ? 150 : 38*arr.count)))
            self.view.addSubview( self.optionalVw!)
        }
        
    }
    
    func removeOptionalView(){
        if optionalVw != nil {
            DispatchQueue.main.async {
                self.optionalVw?.removeFromSuperview()
                self.optionalVw = nil
            }
        }
    }
}




extension AdminChatVC: UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
        
        if let _ = message.doc, (message.doc != ""), isPngJpgJpegImage(fileExtention: (URL(string: message.doc!)?.fileExtention())!) == false  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatAttach") as! ChatAttachmentCell
            
            if message.senderId == getUserDetails()?.usrId {
                cell.rightTralling.priority = UILayoutPriority(rawValue: 999)
                cell.leftTralling.priority = UILayoutPriority(rawValue: 998)
                cell.rightTralling.constant = 5.0
                cell.lblName.text = "me"
                
            }else{
                cell.rightTralling.priority = UILayoutPriority(rawValue: 998)
                cell.leftTralling.priority = UILayoutPriority(rawValue: 999)
                cell.leftTralling.constant = 5.0
                cell.lblName.text = (userData.fullName ?? "Unknown").capitalized
            }
            
            if let time = message.createdAt { // Time Check
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
            
        }else if message.senderId == getUserDetails()?.usrId {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell") as! senderCell
            
            //  cell.lblUser.text = "me"
            if self.userData.isTeam == "1" {
                cell.lblUser.text = message.senderNm?.capitalized
            }
            print(cell.lblUser.text)
            
            if let msg = message.content { // Message check
                cell.txtView.text = (msg )
            }else{
                cell.txtView.text = ""
            }
            
            cell.txtView.textContainer.maximumNumberOfLines = 0
            cell.txtView.textContainer.lineBreakMode = .byWordWrapping
            cell.txtView.textContainerInset = .zero  // // Remove all padding
            cell.txtView.contentInset = UIEdgeInsets.init(top: 0, left: -5, bottom: 0, right: 0)
            cell.txtView.sizeToFit()
         
            if let time = message.createdAt { // Time Check
                cell.lblTime.text = convertTimestampToDateString(timeInterval: (time ))
            }else{
                cell.lblTime.text = ""
            }
            
            if ((message.doc != nil) && message.doc != "") { // Check if File available
                cell.imgHeight.constant = 150
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                cell.imgView.addGestureRecognizer(tap)
                let imageUrl = Service.BaseUrl + message.doc!
                cell.imgView.sd_setImage(with: URL(string: imageUrl) , placeholderImage: UIImage(named: "default-thumbnail"))
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
            if self.userData.isTeam == "1" {
                cell.lblUser.text = message.senderNm?.capitalized
            }else{
                cell.lblUser.text = userData.fullName?.capitalized
            }
            if let msg = message.content { // Message check
                cell.txtView.text = msg
            }else{
                cell.txtView.text = ""
            }
            cell.txtView.textContainer.maximumNumberOfLines = 0
            cell.txtView.textContainer.lineBreakMode = .byWordWrapping
            cell.txtView.textContainerInset = .zero // // Remove all padding
            cell.txtView.contentInset = UIEdgeInsets.init(top: 0, left: -5, bottom: 0, right: 0)
            cell.txtView.sizeToFit()
            
            
            if let time = message.createdAt {  // Time Check
                cell.lblTime.text = convertTimestampToDateString(timeInterval: time )
            }else{
                cell.lblTime.text = ""
            }
            
            if ((message.doc != nil) && message.doc != ""){ // Check if File available
                cell.imgHeight.constant = 150
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                cell.imgView.addGestureRecognizer(tap)
                let imageUrl = Service.BaseUrl + message.doc!
                cell.imgView.sd_setImage(with: URL(string: imageUrl) , placeholderImage: UIImage(named: "default-thumbnail"))
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
        
        if message.doc != nil && message.doc != "" {
            //  UIApplication.shared.open(URL(string: message.file!)!)
            
            if let url = URL(string: Service.BaseUrl + message.doc!){
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

extension AdminChatVC: UIDocumentPickerDelegate , PhotoEditorDelegate{
    
    
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
        
        self.uploadDocuments(imgName: imageName, imageDes: "", imageFile: image) { () -> (Void) in
            print("uploaded image successfully")
        }
    
    }
  
    func canceledEditing() {
        DispatchQueue.main.async {
            APP_Delegate.hideBackButtonText()
        }
       
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
        // let splitName = filename.split(separator: ".")
        let name = url.filename()
        let filetype = url.fileExtention()
        isRemove = true
        APP_Delegate.hideBackButtonText()
        
        //'jpg','png','jpeg'
        if isPngJpgJpegImage(fileExtention: filetype) {
            
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
            vc.imageName = name
            vc.callback = {(imageName,description) in
                
                self.uploadMediaDocuments(fileUrl: url, fileName: name, description: "") { () -> (Void) in
                    print("Docmuent uploaded successfully")
                }
            }
            DispatchQueue.main.async {
                self.navigationController!.present(navController, animated: true, completion: nil)
            }
            
            //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:nil, style: .plain, target: nil, action: nil)
        }
    }
}



