//
//  AppDelegate.swift
//  EPUB Checker
//
//  Created by Jose Quintero on 1/22/17.
//  Copyright © 2017 Jose Quintero. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        controller?.open(sender: nil, fileName: filename)
        
        return true
    }

}

