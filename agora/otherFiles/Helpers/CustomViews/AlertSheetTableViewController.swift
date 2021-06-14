//
//  AlertSheetTableViewController.swift
//  Sader
//
//  Created by Adnan Majeed on 5/8/18.
//  Copyright © 2018 TimeLine. All rights reserved.
//

import UIKit
import SwiftyJSON
//class AlertSheetTableViewController: UITableViewController {
// MARK: - TableViewProject

class AlertSheetTableViewController : UITableViewController
{
    var onComplete: ((_ key:Int , _ title:String)->())?
    
    var objSelected = Int()
    
    var arrTaskStatus:[FilterData] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var selectedTag = Int()
    let cellReuseIdentifier = "cell"
    var obj3:String = String()
    var obj4:Int = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        tableView.tableFooterView = UIView()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTaskStatus.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        let obj =  arrTaskStatus[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = obj.title
        cell.textLabel?.textColor = obj.TextColor
        
        if arrTaskStatus[indexPath.row].selectedIndex == objSelected
        {
            cell.isSelected = true
            cell.accessoryType = .checkmark
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected",objSelected)
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        obj3 = arrTaskStatus[indexPath.row].title
        obj4 = arrTaskStatus[indexPath.row].selectedIndex
        self.onComplete!(obj4,obj3)
        
    }
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func selectAll(){
        let totalRows = tableView.numberOfRows(inSection: 0)
        for row in 0..<totalRows {
            tableView.selectRow(at: NSIndexPath(row: row, section: 0) as IndexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
    }
    
    func resetAccessoryType(){
        for section in 0..<self.tableView.numberOfSections{
            for row in 0..<self.tableView.numberOfRows(inSection: section){
                let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section))
                cell?.accessoryType = .none
                self.tableView.deselectRow(at: IndexPath(row: row, section: section), animated: true)
            }
        }
    }
}

struct FilterData {
    var title:String!
    var selectedIndex:Int!
    var TextColor:UIColor!
    
    init(title:String,selectedIndex:Int,TextColor:UIColor = .black ) {
        self.title = title
        self.selectedIndex = selectedIndex
        self.TextColor = TextColor
    }
}
