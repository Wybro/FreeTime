//
//  ViewController.swift
//  Free Time
//
//  Created by Kyle Wybranowski on 12/14/16.
//  Copyright © 2016 com.Wybro. All rights reserved.
//

import UIKit
import EventKit

struct FreeTime {
    var startDate: Date
    var endDate: Date
    
    var duration: TimeInterval {
        return endDate.timeIntervalSince(startDate)
    }
    
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let hours = duration / 3600
        return "Free time: \(hours) hours from \(dateFormatter.string(from: startDate)) to \(dateFormatter.string(from: endDate))"
    }
    
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calendarAuth()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calendarAuth() {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            getCalendars()
        case .denied:
            print("Access denied")
        case .notDetermined:
            let eventStore = EKEventStore()
            eventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                if granted {
                    self.getCalendars()
                    
                }else{
                    print("Access denied")
                }
            })
        default:
            print("Case Default")
        }
    }
    
    func getCalendars() {
//        var titles : [String] = []
//        var startDates : [NSDate] = []
//        var endDates : [NSDate] = []
        
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
//            print(calendar)
            //            if calendar.title == "Work" {
            //
//            let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
//            let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
            
            let today = Date()
            let tomorrow = today.addingTimeInterval(24*60*60)
            
           
            let predicate = eventStore.predicateForEvents(withStart: today.startOfDay, end: today.endOfDay!, calendars: [calendar])
            
            let tomorrowPredicate = eventStore.predicateForEvents(withStart: tomorrow.startOfDay, end: tomorrow.endOfDay!, calendars: [calendar])
            
            let events = eventStore.events(matching: predicate)
            let tomorrowEvents = eventStore.events(matching: tomorrowPredicate)
            var eventsToCheck = [EKEvent]()
            
//            print("Events today")
            for event in events {
//                titles.append(event.title)
//                startDates.append(event.startDate as NSDate)
//                endDates.append(event.endDate as NSDate)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                if !event.isAllDay {
                    print("Event: \(event.title) -- Start Date: \(dateFormatter.string(from: event.startDate)) -- End Date: \(dateFormatter.string(from: event.endDate))")
                }
            }
            
//            print("Events tomorrow")
            for event in tomorrowEvents {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                if !event.isAllDay {
                    print("Event: \(event.title) -- Start Date: \(dateFormatter.string(from: event.startDate)) -- End Date: \(dateFormatter.string(from: event.endDate))")
                    eventsToCheck.append(event)
                }
            }
            
//            findFreeTime(events: events)
            if !eventsToCheck.isEmpty {
                let freeTime = findFreeTime(events: eventsToCheck)
                print("----FREE TIME FINAL----")
                for time in freeTime {
                    print(time.description)
                }
            }
            
        }
        
    }
    
    func findFreeTime(events: [EKEvent]) -> [FreeTime] {
        
        var freeTime = [FreeTime]()
        
        let startOfDay = events.first?.startDate.startOfDay
        let endOfDay = startOfDay?.endOfDay
        
        print(events.count)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        print("Events count: \(events.count)")
        print("REFERENCE EVENT: \(events.first?.title)")
        print("START OF DAY: \(dateFormatter.string(from: startOfDay!))")
        print("END OF DAY: \(dateFormatter.string(from: endOfDay!))")
        //print("End of Last Event: \(dateFormatter.string(from: endOfLastEvent))")
        
        // Iterate through events & calculate regions of time between
        var endOfLastEvent = startOfDay
        for (index,event) in events.enumerated() {
            // Only allow events with defined timeframes (within single day)
            if !event.isAllDay {
                
                let openInterval = FreeTime(startDate: endOfLastEvent!, endDate: event.startDate)
                
                endOfLastEvent = event.endDate
                
                freeTime.append(openInterval)
                
                // Add final interval after last event
                if event == events.last {
                    let finalOpenInterval = FreeTime(startDate: event.endDate, endDate: endOfDay!)
                    freeTime.append(finalOpenInterval)
                }
                
                
//                let interval = event.startDate.timeIntervalSince(endOfLastEvent!)
//                print("Event: \(event.title) -- Interval: \(interval) seconds -- \(interval / 3600) hours -- End of Last Event: \(dateFormatter.string(from: endOfLastEvent!))")
//                // need to use index to check the start time of the next event
//                
//                
//                print("End of Last Event: \(dateFormatter.string(from: endOfLastEvent!))")
//                if index + 1 < events.count {
//                    let nextEvent = ("Start time of Next Event \(dateFormatter.string(from: events[index+1].startDate))")
//                    print("You have \(interval / 3600) hours of Free Time from \(dateFormatter.string(from: endOfLastEvent!)) to \(dateFormatter.string(from: events[index+1].startDate)) ")
//
//                }
//                endOfLastEvent = event.endDate
            }
        }
        return freeTime
    }
    
}

