//
//  ViewController.swift
//  Free Time
//
//  Created by Kyle Wybranowski on 12/14/16.
//  Copyright © 2016 com.Wybro. All rights reserved.
//

import UIKit
import EventKit

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


    func getCalendars(){
//        var titles : [String] = []
//        var startDates : [NSDate] = []
//        var endDates : [NSDate] = []
        
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            print(calendar)
//            if calendar.title == "Work" {
//                
//                let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
//                let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
//                
//                let predicate = eventStore.predicateForEventsWithStartDate(oneMonthAgo, endDate: oneMonthAfter, calendars: [calendar])
//                
//                var events = eventStore.eventsMatchingPredicate(predicate)
//                
//                for event in events {
//                    titles.append(event.title)
//                    startDates.append(event.startDate)
//                    endDates.append(event.endDate)
//                }
//            }
        }

    }
    
}

