//
//  AppDelegate.swift
//  Timeline
//
//  Created by Christopher Boynton on 9/6/17.
//  Copyright © 2017 Self. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        Debugger.log(string: "App launched", logType: .process, logLevel: .full)
        SaveDataManager.instance.loadAllInfo()
        
        MainWindowController.instance.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
       SaveDataManager.instance.saveAllInfo()
    }

}