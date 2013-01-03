//
//  ZINGManageEvents.m
//  Zing_Mobile
//
//  Created by Anuthiga Sriskanthan on 12/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZINGManageEvents.h"
#import "proposals.h"
#import "ZINGEditEvent.h"

@implementation ZINGManageEvents

@synthesize proposalsData;
@synthesize editEvent;
@synthesize tableView;

NSString *user_id, *user_type;
NSUserDefaults *defaults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) presentStartUpModal 
{
   
   [self.navigationController popViewControllerAnimated:NO];

}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Will Appear");
        
    NSString *addIpAddress = [ipaddress stringByAppendingString:@"events/view/"];
    NSURL *url = [NSURL URLWithString:addIpAddress];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:user_id forKey:@"token"];
    [request setDelegate:self];
    [request startSynchronous];  
    
    [super viewWillAppear:animated];  
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSLog(@"Did Load");
    [super viewDidLoad]; 
    self.title = @"Manage Events";
    
    defaults = [NSUserDefaults standardUserDefaults];
    user_id = [defaults objectForKey:@"user_id"];  
    user_type = [defaults objectForKey:@"user_type"]; 
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    
//    user_id = nil;

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.proposalsData = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{  
    NSLog(@"Request Finished");
    if (request.responseStatusCode == 400) {
        [self performSelector:@selector(presentStartUpModal) withObject:nil afterDelay:0.0f];        
        NSLog(@"You need to login again");
    } else if (request.responseStatusCode == 200) {
        NSString *responseString = [request responseString];
        NSDictionary *responseDict = [responseString JSONValue];
        NSString *user_id = [responseDict objectForKey:@"session_token"];
        
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:user_id forKey:@"user_id"];
        [defaults setObject:user_type forKey:@"user_type"];
        [defaults synchronize];

        NSArray *arrayProposals =  [NSArray arrayWithArray:[[[request responseString] JSONValue] valueForKey:@"proposals"]]; 
        self.proposalsData = arrayProposals;
      
    } else {
        NSLog(@"%@", request.responseString);
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{    
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

#pragma mark - 
#pragma mark Table View Data Source Methods 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    NSLog(@"numberOfRowsInSection");
    return [self.proposalsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    static BOOL nibsRegistered = NO; 
    if (!nibsRegistered) 
    {
        UINib *nib = [UINib nibWithNibName:@"proposals" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        nibsRegistered = YES;
    }
    proposals *cell = [tableView dequeueReusableCellWithIdentifier:
                              CellTableIdentifier];
    NSUInteger row = [indexPath row]; 

    NSString *artist_name = [[proposalsData valueForKey:@"artist_name"] objectAtIndex:row];
    NSString *event_name = [[proposalsData valueForKey:@"event_name"] objectAtIndex:row];
    
//    NSLog(@"%@", [[proposalsData valueForKey:@"offer"] objectAtIndex:row]);
    NSString *app_event = @" ";
    if (event_name != (id)[NSNull null] && event_name.length != 0) {
        app_event = [@" @ " stringByAppendingString:event_name];
    }
    NSString *name = [artist_name stringByAppendingString:app_event];    
    cell.name = name; 
    
    NSString *event_date = [[proposalsData valueForKey:@"event_date"] objectAtIndex:row];
    
    NSArray *listItems = [event_date componentsSeparatedByString:@"-"];    
    NSInteger day = [[listItems objectAtIndex:2]integerValue];
    NSInteger month = [[listItems objectAtIndex:1]integerValue];
    NSInteger year = [[listItems objectAtIndex:0]integerValue];

    NSDate *aDate = [NSDate dateWithYear:year month:month day:day+1];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MMM-dd-yyyy"];
    NSString *formattedDate = [formatter stringFromDate:aDate];
    
    NSString *event_time = [[proposalsData valueForKey:@"event_begin"] objectAtIndex:row];
    if (event_time != (id)[NSNull null] && event_time.length != 0) {
        int eve_tme = [event_time intValue];
        if (eve_tme<12) {
            event_time = [event_time stringByAppendingString:@" am"];
        }
        else{
            eve_tme = eve_tme-12;
            event_time = [NSString stringWithFormat:@"%d",eve_tme];
            event_time = [event_time stringByAppendingString:@" pm"];
        }
    }
    else
    {
        event_time = @"";
    }
    
    NSString *app_event_time = @"";
    if (event_time.length!=0) {
        app_event_time = [@" at " stringByAppendingString:event_time];
    }
    
    NSString *date = [formattedDate stringByAppendingString:app_event_time];
    
    cell.date = date;
//    NSLog(@"%@",user_type);
    NSString *opp_name = @"";
    if ([user_type isEqualToString:@"Promoter"]) 
    {
//        NSLog(@"Promoter");
        opp_name = [[proposalsData valueForKey:@"booking_agent"] objectAtIndex:row]; 
    }
    else
    {
//        NSLog(@"Booking");
        opp_name = [[proposalsData valueForKey:@"promoter"] objectAtIndex:row];    

                
    }
    
    NSString *opposite = @"";
    if (opp_name != (id)[NSNull null] && opp_name.length != 0) {
        opposite = opp_name;
    }
    
    cell.opposite = opposite;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0; // Same number we used in Interface Builder
}

#pragma mark - 
#pragma mark Table View Delegate Methods 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    NSUInteger row = [indexPath row]; 
    editEvent = [[ZINGEditEvent alloc] initWithNibName:@"EditEventView" bundle:[NSBundle mainBundle]]; 
    NSArray *proposal = [self.proposalsData objectAtIndex:row];
    editEvent.proposalData = proposal;
    [self.navigationController pushViewController:editEvent animated:YES];
}

@end
