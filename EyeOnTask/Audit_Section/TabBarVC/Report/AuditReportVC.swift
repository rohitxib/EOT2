//
//  AuditReportVC.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 14/11/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class AuditReportVC: UIViewController, YPSignatureDelegate {
    
    
    
   
    
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var lblSignature: UILabel!
    
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var auditReportSingn: UILabel!
    @IBOutlet weak var btnCleat_Audit: UIButton!
    @IBOutlet var auditSignaturePadView: YPDrawSignatureView!
    @IBOutlet var signautrePadView: YPDrawSignatureView!
    
    @IBOutlet weak var auditPadHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var signaturePadHeight: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: NSLayoutConstraint!
    
   // var arrOfShowData = [TestDetails]()/////////////////////// For Coustom Form : -
//    var  auditDetail : AuditListData?
    var  auditDetail : AuditOfflineList?
    var objOfUserJobListInDetail : UserJobList?
    var moodSelection = Int()
    
    var pressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getFormName()
        moodSelection = 3
        auditSignaturePadView.delegate = self
        signautrePadView.delegate = self
        self.signautrePadView.layer.zPosition = 1
        //swipe()
        
        setLocalization()
        
        ActivityLog(module:Modules.reports.rawValue , message: ActivityMessages.auditReport)
    }
    
    func setLocalization() -> Void {
        self.navigationItem.title = LanguageKey.detail_report
        
        remark.text = LanguageKey.detail_report
        auditReportSingn.text = LanguageKey.auditor_signature
        lblSignature.text = LanguageKey.customer_signature
        btnClear.setTitle(LanguageKey.clear , for: .normal)
        btnSubmit.setTitle(LanguageKey.submit_btn , for: .normal)
        btnCleat_Audit.setTitle(LanguageKey.clear , for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // self.parent?.title = "Feedback"
        
        self.tabBarController?.navigationItem.title = LanguageKey.detail_report
        
        if let button = self.parent?.navigationItem.rightBarButtonItem {
            button.isEnabled = false
            button.tintColor = UIColor.clear
            
        }
        resetView()
        
        if UIScreen.main.sizeType == .iPhone5 {
            self.descriptionHeight.constant = 70
            self.signaturePadHeight.constant = 100
            self.auditPadHeight.constant = 100
            self.submitBtn.constant = 25
            
        }
        
        if UIScreen.main.sizeType == .iPhone6 {
            self.descriptionHeight.constant = 70
            self.signaturePadHeight.constant = 120
            self.auditPadHeight.constant = 130
            self.submitBtn.constant = 30
            
        }
        
        
       // if UIScreen.main.sizeType == .iPhoneX {
//            self.descriptionHeight.constant = 50
//            self.signaturePadHeight.constant = 70
//            self.auditPadHeight.constant = 100
   //     }
    }
    
    
    
    //=====================================
    // MARK: Feedback Button Functionality
    //=====================================
    
    
    @IBAction func feedbackBtn(_ sender: UIButton) {
        moodSelection = sender.tag
        feedbackEmoji(moodSelection: moodSelection )
    }
    
    func feedbackEmoji(moodSelection : Int) -> Void {
        // switch moodSelection {
        //        case 1:
        //            self.sadImage.image = UIImage(named: "sad_face_2.png")
        //            self.smilyImage.image = UIImage(named: "smily_face.png")
        //            self.muteImage.image = UIImage(named: "mute_face.png")
        //            break
        //
        //        case 2:
        //            self.muteImage.image = UIImage(named: "mute_face_2.png")
        //            self.smilyImage.image = UIImage(named: "smily_face.png")
        //            self.sadImage.image = UIImage(named: "sad_face.png")
        //            break
        //        default:
        //            self.smilyImage.image = UIImage(named: "smily_face_2.png")
        //            self.muteImage.image = UIImage(named: "mute_face.png")
        //            self.sadImage.image = UIImage(named: "sad_face.png")
        //   }
    }
    
    
    //==================================
    // MARK: Signaure_Pad Functionality
    //===================================
    
    @IBAction func submitBtn(_ sender: Any) {
        
        let feedbackString = trimString(string: txtDescription.text!)
        if signautrePadView.doesContainSignature || feedbackString.count > 0 || auditSignaturePadView.doesContainSignature {
            self.feedbackService(feebBackTxt: feedbackString)
        }
//        if auditSignaturePadView.doesContainSignature || feedbackString.count > 0 {
//            self.feedbackService(feebBackTxt: feedbackString)
//        }
        
    }
    
    @IBAction func cleBtn_Audit(_ sender: Any) {
        self.auditSignaturePadView.clear()
    }
    
    
    @IBAction func clrBtn(_ sender: Any) {
        self.signautrePadView.clear()
    }
    
    //===========================
    // MARK: Swipe Functionality
    //===========================
    
    func swipe(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 5 { // set your total tabs here
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
    
    
    func feedbackService(feebBackTxt : String) -> Void {
        
        /*
         usrId -> User id
         jobId -> Job id
         des -> Description
         rating -> 1 - Poor , 2 - Happy , 3 - Very happy
         sign -> File object
         */
        
        //        var image = UIImage()
        
        showLoader()
        
        var custSign : UIImage? = nil
        if let signatureImage = self.signautrePadView.getSignature(scale: 1) {
            custSign = signatureImage
            // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
            self.signautrePadView.clear()
        }
        
        var audSign : UIImage? = nil
        if let auditsignatureImage = self.auditSignaturePadView.getSignature(scale: 1) {
            audSign = auditsignatureImage
            // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
            self.auditSignaturePadView.clear()
        }
        
        let param = Params()
        param.usrId = getUserDetails()?.usrId
        param.des = feebBackTxt
        param.audId = auditDetail?.audId
        
        var dict = param.toDictionary
        dict?["custSign"] = custSign
        dict?["audSign"] = audSign
        
        
        txtDescription.resignFirstResponder()
        self.txtDescription.text = ""
        self.signautrePadView.clear()
        
        
        serverCommunicatorUplaodMultipalImage(url: Service.addAuditFeedback, param: dict, imageName:  "image") { (response, success) in
            //        serverCommunicatorUplaodImage(url: Service.addAuditFeedback, param: param.toDictionary, image: image, imagePath: "sign", imageName: "image") { (response, success) in
            
            killLoader()
            
            if(success){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(FeedBackRes.self, from: response as! Data) {
                    if decodedData.success == true{
                        
                        DispatchQueue.main.async{
                            if( decodedData.data.count > 0){
                                let obj = decodedData.data[0]
                                if (obj.jobid != nil && obj.jobid != ""){ //Only For Remove job when Admin Unassign job for FW
                                    var dict = [String : Any]()
                                    dict["data"] = [ "status_code" : obj.status_code! ,
                                                     "jobid" : obj.jobid!]
                                    NotiyCenterClass.fireJobRemoveNotifier(dict: (dict))
                                    self.tabBarController?.navigationController?.popToRootViewController(animated: true)
                                    
                                }
                            }else{
                                
                                self.showToast(message:getServerMsgFromLanguageJson(key: decodedData.message!)!)
                                //ShowAlert(title: LanguageKey.success, message:getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                                
                            }
                        }
                        
                    }else{
                        if let code =  decodedData.statusCode{
                            if(code == "401"){
                                ShowAlert(title: getServerMsgFromLanguageJson(key: decodedData.message!), message:"" , controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: .alert, callback: { (Ok, Cancel) in
                                    if (Ok){
                                        DispatchQueue.main.async {
                                            (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).popViewController(animated: true)
                                        }
                                    }
                                })
                            }
                        }else{
                            ShowError(message: getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
                        }
                    }
                }else{
                    ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
                }
            }else{
                ShowError(message: errorString, controller: windowController)
            }
        }
    }
    
    func resetView() -> Void {
        txtDescription.resignFirstResponder()
        self.txtDescription.text = ""
        // self.feedbackEmoji(moodSelection : 3)
        self.signautrePadView.clear()
        self.auditSignaturePadView.clear()
    }
    
    //======================================================
    // MARK: Signature delegate methods
    //======================================================
    
    
    func didStart() {
        print("Start Signature")
    }
    
    func didFinish() {
        print("Finish Signature")
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
//
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return self.arrOfShowData.count;
//        }
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TestCellCoustomAudit
//
//            let contact = self.arrOfShowData[indexPath.row]
//            cell.costumFormLbl.text = contact.frmnm
//
//            return cell
//        }
//
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//            //performSegue(withIdentifier: "clientTabs", sender: indexPath)
//        }
//
//
//        //===============================
//        // MARK:- Data - Passing method
//        //===============================
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if let indexPath = self.tableview.indexPathForSelectedRow {
//              let customFormVC = segue.destination as! CustomFormVC
//                customFormVC.objOFTestVC = self.arrOfShowData[indexPath.row]
//               }
//
//        }
//
//
//
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 70
//        }
//
//        /*
//         compId -> Company id
//         limit -> limit
//         index -> index value
//         search -> search value
//         dateTime -> date time
//     */
//
//        func getFormName(){
//
//    //        if !isHaveNetowork() {
//    //            if self.refreshControl.isRefreshing {
//    //                self.refreshControl.endRefreshing()
//    //            }
//    //            return
//    //        }
//            let lastRequestTime : String? = UserDefaults.standard.value(forKey: Service.getCustomFormNmList) as? String
//
//            let param = Params()
//            param.compId = getUserDetails()?.compId
//            param.limit = "120"
//            param.index = "0"
//            param.search = ""
//            param.dateTime = lastRequestTime ?? ""
//
//            serverCommunicator(url: Service.getCustomFormNmList, param: param.toDictionary) { (response, success) in
//                if(success){
//                    let decoder = JSONDecoder()
//
//    //                DispatchQueue.main.async {
//    //                    if self.refreshControl.isRefreshing {
//    //                        self.refreshControl.endRefreshing()
//    //                    }
//    //                }
//
//                    if let decodedData = try? decoder.decode(TestRes.self, from: response as! Data) {
//
//                        if decodedData.success == true{
//
//                            if decodedData.data.count > 0 {
//                                //
//                                DispatchQueue.main.async {
//
//                                self.arrOfShowData = decodedData.data
//                                self.tableview.reloadData()
//                                }
//
//                            }else{
//                                if self.arrOfShowData.count == 0{
//                                    DispatchQueue.main.async {
//                                        self.tableview.isHidden = true
//                                    }
//                                }
//                            }
//                        }else{
//                            ShowError(message:  getServerMsgFromLanguageJson(key: decodedData.message!)!, controller: windowController)
//                        }
//                    }else{
//                        ShowAlert(title: AlertMessage.formatProblem, message: "", controller: windowController, cancelButton: LanguageKey.ok as NSString, okButton: nil, style: UIAlertController.Style.alert, callback: {_,_ in})
//                    }
//                }else{
//                    //ShowError(message: "Please try again!", controller: windowController)
//                }
//            }
//        }
//
    
}

