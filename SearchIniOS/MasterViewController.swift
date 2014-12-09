//
//  MasterViewController.swift
//  SearchIniOS
//
//  Created by Masayuki Ikeda on 2014/11/15.
//  Copyright (c) 2014年 Masayuki Ikeda. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var objects = NSMutableArray()
    var textChecker: UITextChecker?
    
    @IBOutlet weak var tableView: UITableView!
    var searchBar: UISearchBar?

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            //self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTableView()
        configureNavigationController()
        self.searchBar?.becomeFirstResponder()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            //self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchBar?.becomeFirstResponder()
    }
    
    func configureModel() {
        self.textChecker = UITextChecker()
    }
    
    func configureNavigationController() {
        let bounds = self.view.bounds
        self.searchBar = UISearchBar(frame: CGRectMake(0, 0, bounds.size.width - 40, bounds.size.height - 8))
        self.searchBar?.delegate = self
        self.searchBar?.placeholder = "調べたい語句を入力"
        self.navigationItem.titleView = self.searchBar
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        let cell: UINib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        self.tableView.registerNib(cell, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insertObject(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.objects.count == 0 {
            return nil
        } else {
            return "履歴"
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = objects[indexPath.row] as NSString
        cell.textLabel?.text = object
        return cell
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // MARK: TableView Navigation
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let difinition = objects[indexPath.row] as NSString
        let referenceLibraryViewController: UIReferenceLibraryViewController = UIReferenceLibraryViewController(term: difinition)
        self.navigationController?.presentViewController(referenceLibraryViewController, animated: true, completion: {
            let selectedIndexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            self.tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true);
        })
    }

    
    // MARK: - UISearchBar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let hasDifinition: Bool = UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(searchBar.text)
        if hasDifinition == false {
            
            let width: CGFloat = 180.0
            let height: CGFloat = 120.0
            let boundsCenter: CGPoint = self.view.center
            let resultView: NoResultView = NoResultView(frame: CGRectMake(boundsCenter.x - (width / 2), boundsCenter.y - (height / 2), width, height))
            
            self.view.addSubview(resultView)
            
            let duration: NSTimeInterval = 0.3
            let delay: NSTimeInterval = 0.0
            UIView.animateWithDuration(1.0, delay: 0.3, options: UIViewAnimationOptions.LayoutSubviews, animations: {() -> Void in
                resultView.alpha = 0.0
                
                }, completion: {(Bool) -> Void in
                    resultView.removeFromSuperview()
            })
            
            return
        }
        
        objects.insertObject(searchBar.text, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
        
        let referenceLibraryViewController: UIReferenceLibraryViewController = UIReferenceLibraryViewController(term: searchBar.text)
        self.navigationController?.presentViewController(referenceLibraryViewController, animated: true, completion: nil)
    }
    /*
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text.utf16Count == 0 {
            return
        }
    
        let tagger: NSLinguisticTagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeLanguage], options: 0)
        tagger.string = searchBar.text
        let language = tagger.tagAtIndex(0, scheme: NSLinguisticTagSchemeLanguage, tokenRange: nil, sentenceRange: nil)
        let range: NSRange = NSString().rangeOfString(searchBar.text)
        let availableLanguages: [String] = self.textChecker.completionsForPartialWordRange(NSMakeRange(0, searchBar.text.utf16Count), inString: searchBar.text, language: language!)
        
        self.objects.removeAllObjects()
        self.objects.addObjectsFromArray(self.textChecker?.completionsForPartialWordRange(NSMakeRange(0, searchBar.text.utf16Count), inString: searchBar.text, language: language)!)
        self.tableView.reloadData()
    }*/
}

