//
//  EventHelper.swift
//  Recta
//
//  Created by Adnan Majeed on 7/11/20.
//  Copyright © 2020 Adnan Majeed. All rights reserved.
//

import Foundation
import EventKit

class EventHelper
{
    var title:String!
    var notes:String!
    var startDate:Date!
    var endDate:Date!
    var location:String!
    
    private let appleEventStore = EKEventStore()
    private var calendars: [EKCalendar]?
    
    func generateEvent() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)

        switch (status)
        {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // User has access
            print("User has access to calendar")
            self.addAppleEvents()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            noPermission()
        @unknown default:
            Functions.showToast(message: "Error", type: .failure, duration: 1.0, position: .center)
        }
    }
   private  func noPermission()
    {
        Functions.showToast(message: "User has to change settings...goto settings to view access")
    }
    private func requestAccessToCalendar() {
        appleEventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                DispatchQueue.main.async {
                    print("User has access to calendar")
                    self.addAppleEvents()
                }
            } else {
                DispatchQueue.main.async{
                    self.noPermission()
                }
            }
        })
    }
    
    private func addAppleEvents()
    {
        let alarm = EKAlarm(relativeOffset: -3600.0)
        
        let event:EKEvent = EKEvent(eventStore: appleEventStore)
        event.title = self.title
        event.startDate = self.startDate
        event.endDate = self.endDate
        event.notes = self.notes
        event.location = self.location
        event.alarms = [alarm]
        event.calendar = appleEventStore.defaultCalendarForNewEvents

        do {
            try appleEventStore.save(event, span: .thisEvent)
            print("events added with dates:")
        } catch let e as NSError {
            print(e.description)
            return
        }
        print("Saved Event")
    }
}
