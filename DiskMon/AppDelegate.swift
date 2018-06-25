//
//  AppDelegate.swift
//  DiskMon
//
//  Created by Rakesh Sinha on 13/05/16.
//  Copyright © 2016 Rakesh Sinha. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {

        updateUI()
        
        let menu = NSMenu()
        

        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.Quit(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            
            while true {
                sleep(120)
                // do something time consuming here
                
                dispatch_async(dispatch_get_main_queue()) {

                    self.updateUI()
                }
            }
        }
    }
    
    func updateUI (){
        // now update UI on main thread
        let freeSpace = self.freeSpaceInBytes()
         self.statusItem.title = freeSpace as String
        let newString = freeSpace.stringByReplacingOccurrencesOfString(" GB", withString: "")
        let myInt = Double(newString)
        if myInt < 15 {
            if let button = self.statusItem.button {
                button.image = NSImage(named: "alert")
                //button.action = Selector("togglePopover:")
            }
        } else {
            if let button = self.statusItem.button {
                button.image = NSImage(named: "normal")
                //button.action = Selector("togglePopover:")
            }
        }
        self.statusItem.title = freeSpace as String
    }
    
    func Quit(send: AnyObject?) {
        NSLog("Exit")
        NSApplication.sharedApplication().terminate(nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    
    func freeSpaceInBytes() -> NSString{
        
        var remainingSpace = NSLocalizedString("Unknown", comment: "The remaining free disk space on this device is unknown.")
        
        do {
            
            let dictionary =  try NSFileManager.defaultManager().attributesOfFileSystemForPath(NSHomeDirectory())
            let freeSpaceSize = (dictionary[NSFileSystemFreeSize]?.longLongValue)!
            remainingSpace = NSByteCountFormatter.stringFromByteCount(freeSpaceSize, countStyle: NSByteCountFormatterCountStyle.File)
            
        }
        catch let error as NSError {
            
            error.description
            NSLog(error.description)
            
        }
        
        return remainingSpace
        
    }
    


}

