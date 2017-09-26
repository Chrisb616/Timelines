//
//  TimelineGridCollectionViewDelegate.swift
//  Timeline
//
//  Created by Christopher Boynton on 9/25/17.
//  Copyright © 2017 Self. All rights reserved.
//

import Cocoa

class TimelineGridCollectionViewDelegate: NSObject, NSCollectionViewDelegate {
    
    var isInternalDrag = false

    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt index: Int) -> NSPasteboardWriting? {
        guard let timelineItem = (collectionView.item(at: index) as? TimelineGridCollectionViewItem)?.timelineItem else {
            Debugger.log(string: "Could not find timelineItem in collection view item during drag and drop", logType: .failure, logLevel: .minimal)
            return nil
        }
        
        return NSString(string: timelineItem.uniqueID)
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexes: IndexSet) {
        isInternalDrag = true
    }
    
    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {
        if isInternalDrag {
            if proposedDropOperation.pointee == .before {
                proposedDropOperation.pointee = .on
            }
            return NSDragOperation.every
        } else {
            return NSDragOperation.copy
        }
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        print("ended")
    }
    
    func collectionView(collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAtPoint screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        isInternalDrag = false
    }
    
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
        
        draggingInfo.enumerateDraggingItems(options: .clearNonenumeratedImages, for: collectionView, classes: [NSString.self, NSURL.self], searchOptions: [:]) { (item, index, stop) in
            
            if let url = item.item as? URL {
                ImageManager.instance.importImage(from: url, completion: { (image) in
                    let moment = Moment.new(fromImage: image)
                    DataStore.instance.timelineItems.updateValue(moment, forKey: moment.uniqueID)
                })
            }
            
            if let from = item.item as? String, let to = (collectionView.item(at: indexPath.item) as? TimelineGridCollectionViewItem)?.timelineItem.uniqueID {
                
                NotificationManager.instance.postMergeEventNotification(mergeEventWithUniqueID: from, intoEventWithUniqueID: to)
            }
        }
        
        NotificationManager.instance.postMainTimelineUpdateNotification()
        return true
    }
}
