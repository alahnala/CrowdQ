//
//  SuggestGenreViewController.swift
//  Sphere
//
//  Created by Xinrui Yang on 3/27/17.
//  Copyright © 2017 EECS441. All rights reserved.
//

import Foundation
import UIKit
import ModernSearchBar

class SuggestGenreViewController : UIViewController, UITextFieldDelegate, UITableViewDelegate, ModernSearchBarDelegate {
    // UITableViewDataSource, ModernSearchBarDelegate {
    
    // var suggestGenreView : SuggestGenreView
    
    // var autoCompletePossibilities = ["Pop", "Rock", "Family Friendly"]
    // var autoComplete = [String]()
    
    var modernSearchBar : ModernSearchBar
    
    init() {
        // self.suggestGenreView = SuggestGenreView()
        
        self.modernSearchBar = ModernSearchBar()
        
        super.init(nibName: nil, bundle: nil)
        
        self.modernSearchBar.delegateModernSearchBar = self
        
        self.title = "Suggest"
        
       // self.view = self.suggestGenreView
        
        let suggestionList = Array(MusicManager.sharedInstance.genresToColors.keys)
        
        self.modernSearchBar.setDatas(datas: suggestionList)
        
        styleSearchBar()
        
        
        self.view = self.modernSearchBar
        
        print("zzz: init finished")
    }
    
    
    func onClickItemSuggestionsView(item: String) {
        print("User touched this item: "+item)
        self.modernSearchBar.text = item
    }
    
    func styleSearchBar() {
        
        //Modify shadows alpha
        self.modernSearchBar.shadowView_alpha = 0.8
        
        //Modify the default icon of suggestionsView's rows
        //self.modernSearchBar.searchImage = ModernSearchBarIcon.Icon.none.image
        
        //Modify properties of the searchLabel
        self.modernSearchBar.searchLabel_font = UIFont(name: "Avenir-Light", size: 30)
        self.modernSearchBar.searchLabel_textColor = UIColor.red
        self.modernSearchBar.searchLabel_backgroundColor = UIColor.white
        
        //Modify properties of the searchIcon
        self.modernSearchBar.suggestionsView_searchIcon_height = 40
        self.modernSearchBar.suggestionsView_searchIcon_width = 40
        self.modernSearchBar.suggestionsView_searchIcon_isRound = false
        
        //Modify properties of suggestionsView
        ///Modify the max height of the suggestionsView
        self.modernSearchBar.suggestionsView_maxHeight = 1000
        ///Modify properties of the suggestionsView
        self.modernSearchBar.suggestionsView_backgroundColor = UIColor.brown
        self.modernSearchBar.suggestionsView_contentViewColor = UIColor.yellow
        self.modernSearchBar.suggestionsView_separatorStyle = .singleLine
        self.modernSearchBar.suggestionsView_selectionStyle = UITableViewCellSelectionStyle.gray
        self.modernSearchBar.suggestionsView_verticalSpaceWithSearchBar = 10
        self.modernSearchBar.suggestionsView_spaceWithKeyboard = 20
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tap
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.suggestGenreView, action: #selector(SuggestGenreViewController.dismissKeyboard))
//        self.view.addGestureRecognizer(tap)
        
        print("zzz: view loaded")
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//        searchAutocompleteEntriesWithSubstring(substring)
//        
//        return true
//    }
//    
//    func searchAutocompleteEntriesWithSubstring(_ substring: String) {
//        print("Searching autcomplete entries with substring: ")
//        print(substring)
//        
//        self.suggestGenreView.autoComplete.removeAll(keepingCapacity: false)
//        
//        for key in self.suggestGenreView.autoCompletePossibilities {
//            
//            let myString:NSString! = key as NSString
//            
//            let substringRange :NSRange! = myString.range(of: substring)
//            
//            if (substringRange.location  == 0) {
//                self.suggestGenreView.autoComplete.append(key)
//            }
//        }
//        
//        self.suggestGenreView.tableView.reloadData()
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
//        
//        let index = indexPath.row as Int
//        
//        cell.textLabel!.text = self.suggestGenreView.autoComplete[index]
//        
//        return cell
//    
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return self.suggestGenreView.autoComplete.count
//        
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
//        print(selectedCell)
//        //self.suggestGenreView.textField.text? = selectedCell.text!
//        
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
