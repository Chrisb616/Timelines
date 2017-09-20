//
//  Event.swift
//  Timeline
//
//  Created by Christopher Boynton on 9/6/17.
//  Copyright © 2017 Self. All rights reserved.
//

import Foundation

class Event: TimelineItem {
    
    //MARK: - Properties
    //MARK: -
    
    //MARK: - UniqueID
    var uniqueID: UniqueID
    
    //MARK: - Date
    var date: Date
    
    var startDate: Date { return date }
    var endDate: Date
    
    var dateRange: DateRange { return DateRange(start: date, end: endDate)}
    
    //MARK: - Strings
    private var _name: String?
    var name: String { return _name ?? date.formatted(as: "MMMM dd, yyyy")}
    
    var narrative: String?
    
    //MARK: - Pictures
    var pictureID: UniqueID?
    
    var pictureIDs = [UniqueID:Bool]()
    
    //MARK: - Initialization
    init(uniqueID: UniqueID, startDate: Date, endDate: Date) {
        self.uniqueID = uniqueID
        
        self.date = startDate
        self.endDate = endDate
        
    }
    
    //MARK: - Methods
    //MARK: -
    
    //MARK: - Private variable accessors
    func setName(_ name: String?) {
        self._name = name
    }
    
    func clearName() {
        self._name = nil
    }
    
}
 
