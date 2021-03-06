//
//  TimelineGridCollectionView.swift
//  Timeline
//
//  Created by Christopher Boynton on 9/23/17.
//  Copyright © 2017 Self. All rights reserved.
//

import Cocoa

class TimelineGridCollectionView: NSCollectionView {
    
    var customLayout: TimelineGridCollectionViewFlowLayout!
    var customDataSource: TimelineGridCollectionViewDataSource!
    var customDelegate: TimelineGridCollectionViewDelegate!
    
    var timeline: Timeline!
    
    func configure(forTimeline timeline: Timeline) {
        
        self.timeline = timeline
        
        self.isSelectable = true
        self.allowsMultipleSelection = true
        
        configureDragAndDrop()
        configureDelegate()
        configureFlowLayout()
        configureDataSource()
    }
    
    private func configureDragAndDrop() {
        let urlType = NSPasteboard.PasteboardType(rawValue: kUTTypeFileURL as String)
        self.registerForDraggedTypes([.string, urlType])
        self.setDraggingSourceOperationMask(.every, forLocal: true)
        self.setDraggingSourceOperationMask(.every, forLocal: false)
    }
    
    private func configureDelegate() {
        self.customDelegate = TimelineGridCollectionViewDelegate()
        
        customDelegate.customCollectionView = self
        delegate = customDelegate
    }
    
    private func configureFlowLayout() {
        customLayout = TimelineGridCollectionViewFlowLayout()
        customLayout.configure()
        collectionViewLayout = customLayout
        
    }
    private func configureDataSource() {
        customDataSource = TimelineGridCollectionViewDataSource()
        customDataSource.timeline = timeline
        dataSource = customDataSource
    }
    
    override func reloadData() {
        customDataSource.reloadChronlogicalItems()
        super.reloadData()
    }
    
}
