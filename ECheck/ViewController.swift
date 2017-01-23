//
//  ViewController.swift
//  EPUB Checker
//
//  Created by Jose Quintero on 1/22/17.
//  Copyright © 2017 Jose Quintero. All rights reserved.
//

import Cocoa

var controller: ViewController? = nil

class ViewController: NSViewController, NSOpenSavePanelDelegate {

    @IBOutlet var path: NSTextField!
    
    override func viewDidAppear() {
        self.title = "EPUB Check"
        controller = self
    }
    
    func open(sender: NSButton? = nil, fileName filePath: String? = nil) {
        sender?.isEnabled = false
        
        if sender?.tag == 10 || sender == nil {
            
            let bundle = Bundle.main
            let jarPath = "\(bundle.bundlePath)/Contents/Resources/epubcheck.jar"
            
            let javaTool = runCommand(cmd: "/usr/bin/which", args: "java").output.first ?? "/usr/bin/java"
            
            var commandOutput: (output: [String], error: [String], exitCode: Int32)
            
            if path != nil {
                commandOutput = runCommand(cmd: javaTool, args: "-jar", "\(jarPath)", "\(filePath?.replacingOccurrences(of: "file://", with: "") ?? "")")
            }else {
                commandOutput = runCommand(cmd: javaTool, args: "-jar", "\(jarPath)", "\(path.stringValue.replacingOccurrences(of: "file://", with: ""))")
            }
            
            self.performSegue(withIdentifier: "showOutput", sender: commandOutput)
            
            sender?.tag = 0
            
            if path == nil {
                path.stringValue = ""
            }
            
            sender?.isEnabled = true
            sender?.title = "Open"
            
            return
        }
        
        let dialog = NSOpenPanel()
        
        dialog.title                   = "Choose a .epub file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = true
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes        = ["epub"]
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url?.absoluteString ?? "Failed to extract path" // Pathname of the file
            
            if (result != "Failed to extract path") {
                path.stringValue = result
                
                sender?.title = "Validate"
                sender?.isEnabled = true
                sender?.tag = 10
            }
        } else {
            // User clicked on "Cancel"
            sender?.isEnabled = true
            return
        }
    }
    
    @IBAction func open(_ sender: NSButton) {
        self.open(sender: sender, fileName: nil)
    }
    
    override func viewDidDisappear() {
        NSApplication.shared().terminate(nil)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let output = sender as! ([String], [String], Int32)
        var string = ""
        let array: [String] = { if output.1.count == 0 { return output.0 } else { return output.1 } }()
        for str in array {
            string = string + "\n\n\n" + str
        }
        let destination = segue.destinationController as! OutputView
        
        destination.text = string
    }
    
    func runCommand(cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {
        
        var output : [String] = []
        var error : [String] = []
        
        let task = Process()
        task.launchPath = cmd
        task.arguments = args
        
        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe
        
        task.launch()
        
        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
        }
        
        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
        }
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return (output, error, status)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
