//
//  ViewController.swift
//  TableViewIndentSample
//
//  Created by 能登 要 on 2016/01/28.
//  Copyright © 2016年 Irimasu Densan Planning. All rights reserved.
//

import UIKit

enum CellMode:NSInteger {
    case Basic = 0
    case Custom = 1
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    var cellMode:CellMode = .Basic
    var initialized:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentController.selectedSegmentIndex = cellMode.rawValue;
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.toolbarItems = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),self.editButtonItem(),UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)]
        self.navigationController?.setToolbarHidden(false, animated:true)
    }

    override func viewDidAppear(animated: Bool) {
        if initialized != true {
            initialized = true;
            tableView.reloadData()
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView .setEditing(editing, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func onChange(sender: AnyObject){
        if( cellMode.rawValue != segmentController.selectedSegmentIndex ){
            switch segmentController.selectedSegmentIndex {
            case 0:
                cellMode = .Basic
            case 1:
                cellMode = .Custom
            default:
                break
            }
            
            tableView.reloadData();
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier:String;
        switch cellMode {
        case .Basic:
            cellIdentifier = "basicCell"
        case .Custom:
            cellIdentifier = "customCell"
        }
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        if let customCell:CustomCell = cell as? CustomCell {
            customCell.customLabel.text = "\(indexPath.row)番目"
        }else{
            cell.textLabel?.text = "\(indexPath.row)番目"
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let indentationWidth:CGFloat = max(tableView.separatorInset.left,cell.indentationWidth)
        
        var separatorInset:UIEdgeInsets = cell.separatorInset;
        separatorInset.left = indentationWidth;
        cell.separatorInset = separatorInset;
        cell.preservesSuperviewLayoutMargins = false;
        
        var layoutMargins:UIEdgeInsets = cell.layoutMargins;
        layoutMargins.left = indentationWidth;
        cell.layoutMargins = layoutMargins;
        
        if let customCell:CustomCell = cell as? CustomCell {
            customCell.leadingConstraint.constant = indentationWidth;
        }
        
    }
    
}

