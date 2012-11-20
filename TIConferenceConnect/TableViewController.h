//
//  TableViewController1.h
//  TIConferenceConnect
//
//  Created by Jessi Cardoso on 11/14/12.
//  Copyright (c) 2012 TI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface TableViewController : UITableViewController < UINavigationControllerDelegate, UITableViewDelegate,EKEventEditViewDelegate,UINavigationControllerDelegate > {

    EKEventViewController *detailViewController;
    EKEventStore *eventStore;   // event store lets us connect to database
    EKCalendar *defaultCalendar; //calender that is defined
    NSMutableArray *eventList;  //array store events from calender
    

    
}


@property (nonatomic, retain)EKEventStore *eventStore;
@property (nonatomic, retain)EKCalendar *defaultCalendar;
@property (nonatomic, retain)NSMutableArray *eventList;
@property (nonatomic, retain)EKEventViewController *detailViewController;

-(NSArray *)fetchEvents;
-(IBAction) addEvent:(id)sender;
-(IBAction)callPhone:(id)sender;

@end
