//
//  ViewController.swift
//  AgeInlineRowSample
//
//  Created by keta on 2016/05/20.
//  Copyright © 2016年 Keisuke Ueda. All rights reserved.
//

import UIKit
import Eureka

class ViewController: FormViewController {
    
    var navigationOptionsBackup: RowNavigationOptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initializeForm()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func initializeForm() {
        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        navigationOptionsBackup = navigationOptions
        
        form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
        
        // Do any additional setup after loading the view.
        form
            
            +++ Section("Section1")
            
            <<< DateInlineRow("Date") {
                $0.value = NSDate()
                $0.title = "Date"
            }
            
            
            <<< AgeInlineRow("AgePicker") { (row: AgeInlineRow) -> Void in
                
                row.title = row.tag
                
                for i in 0...18 {
                    row.year_options.append(i)
                }
                
                for i in 0...11 {
                    row.month_options.append(i)
                }
                
                row.value?.year = row.year_options[0]
                row.value?.month = row.month_options[0]
                
                let age = Age()
                age.year = 0
                age.month = 0
                
                row.value = age
                }.onChange{row in
        }
    }
}
