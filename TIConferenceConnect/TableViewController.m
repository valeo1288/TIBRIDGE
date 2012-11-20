//
//  TableViewController.m
//  TIConferenceConnect
//
//  Created by Jessi Cardoso on 11/14/12.
//  Copyright (c) 2012 TI. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController()

@end

@implementation TableViewController
@synthesize eventList,eventStore,defaultCalendar,detailViewController;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Conference List";
    
    self.eventStore = [[EKEventStore alloc] init];
    self.eventList =[[NSMutableArray alloc] initWithArray:0];
    
    self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.navigationController.delegate = self;
    
    [self.eventList addObjectsFromArray:[self fetchEvents]];
    
    [self.tableView reloadData];
    
    
    
}

#pragma mark -
#pragma mark Add a new event

-(IBAction)callPhone:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4699555108"]];
}

#pragma mark -
#pragma mark Add a new event

-(IBAction) addEvent:(id)sender
{
      EKEventEditViewController *addcontroller = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    
      addcontroller.eventStore = self.eventStore;
    
      [self presentViewController:addcontroller animated:YES completion:NULL];
    
     addcontroller.editViewDelegate = self;
//   [addcontroller reloadInputViews];
    
    
}



#pragma mark -
#pragma mark Table view data source

// Get events from calender
-(NSArray *)fetchEvents
{
    NSDate *startDate = [NSDate date];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:2592000];
    
    NSArray *calendarArray =[NSArray arrayWithObject:defaultCalendar];
    
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendarArray];
    
    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    
    return events;
}


#pragma mark -
#pragma mark EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action;
{
    NSError *anError =nil;
    
    EKEvent *thisEvent = controller.event;
    
    switch (action)
    {
        case EKEventEditViewActionCanceled:
            if (self.defaultCalendar =thisEvent.calendar)
            {
                [self.eventList addObject:thisEvent];
            }
            [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:& anError];
            [self.tableView reloadData];
            break;
            
        case EKEventEditViewActionDeleted:
            if (self.defaultCalendar == thisEvent.calendar)
            {
                [self.eventList removeObject:thisEvent];
            }
            [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:& anError];
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
}

-(EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller
{
    EKCalendar *calendarForEdit =self.defaultCalendar;
    return calendarForEdit;
}

#pragma mark -
#pragma mark Navigation Controller delegate

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self && self.detailViewController.event.title == NULL)
    {
        [self.eventList removeObject:self.detailViewController.event];
        [self.tableView reloadData];
    }
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return eventList.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCellAccessoryType editableCellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];//autorelease];
        
    }
    cell.accessoryType = editableCellAccessoryType;
    
    cell.textLabel.text = [[self.eventList objectAtIndex:indexPath.row] title];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailViewController = [[EKEventViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.event = [self.eventList objectAtIndex:indexPath.row];
    
    detailViewController.allowsEditing = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.eventList = nil;
    self.eventStore =nil;
    self.defaultCalendar = nil;
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)dealloc
{
    //[self.eventList release];
    //[self.eventStore release];
    //[self.defaultCalendar release];
    
    // [super dealloc];
}

@end

