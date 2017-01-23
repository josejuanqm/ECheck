//
//  OutputView.swift
//  EPUB Checker
//
//  Created by Jose Quintero on 1/22/17.
//  Copyright © 2017 Jose Quintero. All rights reserved.
//

import Cocoa

class OutputView: NSViewController {

    @IBOutlet var textView: NSTextView!
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        textView.insertText(text, replacementRange: textView.rangeForUserTextChange)
        textView.isEditable = false
    }
    
}
