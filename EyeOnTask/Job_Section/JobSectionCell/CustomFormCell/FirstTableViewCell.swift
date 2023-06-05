//
//  FirstTableViewCell.swift
//  EyeOnTask
//
//  Created by Mac on 05/09/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import UIKit

class FirstTableViewCell: UITableViewCell {
    
    //  var sltIdx : Int?
    var arrOFShowData: [Any]?
    var alreadySltAns : [AnsDetals]?
    
    // MARK: UI
    @IBOutlet weak var lbl_Qust_B: NSLayoutConstraint!
    struct UI {
        static let rowHeight: CGFloat = 50
        static let insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let minimumInteritemSpacing: CGFloat = 6
        static let minimumLineSpacing: CGFloat = 6
        static let maxHeight: CGFloat = UIScreen.main.bounds.width / 2
        static let multiplier: CGFloat = 2
        static let animationDuration: TimeInterval = 0.3
    }
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = UI.rowHeight
        $0.separatorStyle = .none
        $0.backgroundColor = nil
        $0.bounces = false
        $0.isScrollEnabled = false
        //$0.tableHeaderView = collectionView
        $0.tableFooterView = UIView()
        $0.register(SubCellOFFirstCell.self, forCellReuseIdentifier: SubCellOFFirstCell.identifier)
        
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    var selection: ((Bool , Any , Int) -> Void)?
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var numberlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberlbl.text = "\u{2022} This is a list item!"
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
 
    func addTableView(frame : CGRect){
        
        let table_View = tableView
        table_View.frame = frame
        // tableView.backgroundColor = UIColor.green//
        self.addSubview(table_View)
    }
    
}

extension FirstTableViewCell {

    func addSubTblView(frame : CGRect , ShowData : [Any]?,alreadyGivnAns : [AnsDetals]? ,selection: @escaping (Bool , Any , Int) -> Void) {
        self.selection = selection
        self.arrOFShowData = ShowData!
        self.alreadySltAns = alreadyGivnAns
        self.addTableView(frame: frame)
        self.tableView.reloadData()

    }
}

// MARK: - TableViewDelegate

extension FirstTableViewCell: UITableViewDelegate {
    
    
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("indexPath = \(indexPath)")
//
////        let cell : SubCellOFFirstCell = (tableView.cellForRow(at: indexPath) as? SubCellOFFirstCell)!
////        if(  cell.imageView?.image == UIImage(named: "BoxOFCheck") ){
////            cell.imageView?.image = UIImage(named: "BoxOFUncheck")
////
////
////            if self.selection != nil {
////                let optDetals = arrOFShowData![indexPath.row] as? OptDetals
////                self.selection!(false, optDetals ?? "", (indexPath.row + 1))
////            }
////        }else{
////            cell.imageView?.image = UIImage(named: "BoxOFCheck")
////            if self.selection != nil {
////                let optDetals = arrOFShowData![indexPath.row] as? OptDetals
////                self.selection!(true, optDetals ?? "", (indexPath.row + 1))
////            }
////        }
//
//    }
}

// MARK: - TableViewDataSource

extension FirstTableViewCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOFShowData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubCellOFFirstCell.identifier) as! SubCellOFFirstCell
        cell.imageView?.image = UIImage(named: "unchecked24")
        let optDetals = arrOFShowData![indexPath.row] as? OptDetals
        cell.textLabel?.text =  optDetals?.value
        cell.backgroundColor = UIColor.clear
        
        if((self.alreadySltAns?.count)! > 0){
            let isExist  =  self.alreadySltAns?.contains(where: { (obj) -> Bool in
                if( obj.key == optDetals?.key){
                    return true
                }else{
                    return false
                }
            })
            if isExist! {
                cell.imageView?.image = UIImage(named: "checked24")
            }else{
                cell.imageView?.image = UIImage(named: "unchecked24")
            }
            
        }else{
            cell.imageView?.image = UIImage(named: "unchecked24")
        }
        
        
        cell.cellButton?.tag = indexPath.row
        cell.cellButton?.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }

    
    @objc func buttonSelected(sender: UIButton){
    
        let buttonPosition = sender.convert(CGPoint(), to:tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let cell : SubCellOFFirstCell = (tableView.cellForRow(at: indexPath!) as? SubCellOFFirstCell)!
        if(  cell.imageView?.image == UIImage(named: "checked24") ){
                    cell.imageView?.image = UIImage(named: "unchecked24")


                        if self.selection != nil {
                           let optDetals = arrOFShowData![(indexPath?.row)!] as? OptDetals
                           self.selection!(false, optDetals ?? "", (indexPath!.row + 1))
                      }
                   }else{
                        cell.imageView?.image = UIImage(named: "checked24")
                        if self.selection != nil {
                            let optDetals = arrOFShowData![(indexPath?.row)!] as? OptDetals
                            self.selection!(true, optDetals ?? "", ((indexPath?.row)! + 1))
                        }
                     }
                   }
                }

