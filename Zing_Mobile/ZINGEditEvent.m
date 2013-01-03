//
//  ZINGEditEvent.m
//  Zing_Mobile
//
//  Created by Anuthiga Sriskanthan on 12/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZINGEditEvent.h"

@implementation ZINGEditEvent

@synthesize proposalData;
@synthesize opp_title;
@synthesize opp_name;
@synthesize artist_name;
@synthesize offer;
@synthesize event_name;
@synthesize offer_err;
@synthesize btnUpdate;

NSString *user_id, *user_type, *proposal_id, *opp;
NSUserDefaults *defaults;
UIButton *doneButton;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Edit Event Details";
    
    proposal_id = [proposalData valueForKey:@"proposal_id"];
    defaults = [NSUserDefaults standardUserDefaults];
    user_id = [defaults objectForKey:@"user_id"];  
    user_type = [defaults objectForKey:@"user_type"]; 
    
    if([user_type isEqualToString:@"Promoter"])
    {
        opp_title.text = @"Booking Agent";
        opp = @"booking_agent";
    }
    else
    {
        opp_title.text = @"Promoter";
        opp = @"promoter";
    }
    
    NSString *opposite = [proposalData valueForKey:opp];
    NSString *artist = [proposalData valueForKey:@"artist_name"];
    NSString *event = [proposalData valueForKey:@"event_name"];
    NSString *off = [proposalData valueForKey:@"offer"]; 
    
    if(opposite == (id)[NSNull null] || opposite.length == 0){
        opposite = @"";
    }
    if(artist == (id)[NSNull null] || artist.length == 0){
        artist = @"";
    }
    if (event == (id)[NSNull null] || event.length == 0) {
        event = @"";
    }
    if (off == (id)[NSNull null] || off.length == 0) {
        off = @"";
    }    

    opp_name.text = opposite;
    artist_name.text = artist;
    event_name.text = event;
    offer.text = off;   
    
    [event_name setDelegate:self];
    [offer setDelegate:self];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL) doneButton
{    
    if (offer.isFirstResponder) {
        [offer resignFirstResponder];
    }
    return YES;    
}

- (BOOL) findKeyboard:(UIView *) superView; 
{
    UIView *currentView;
    if ([superView.subviews count] > 0) {
        for(int i = 0; i < [superView.subviews count]; i++)
        {
            
            currentView = [superView.subviews objectAtIndex:i];
//            NSLog(@"%@",[currentView description]);
            if([[currentView description] hasPrefix:@"<UIKeyboard"] == YES)
            {
                
//                NSLog(@"Find it");
                //add toolbar here
                
                doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
                doneButton.frame = CGRectMake(0, 163, 106, 53);
                doneButton.adjustsImageWhenHighlighted = NO;
                [doneButton setImage:[UIImage imageNamed:@"doneup"] forState:UIControlStateNormal];
                [doneButton setImage:[UIImage imageNamed:@"donedown"] forState:UIControlStateHighlighted];
                [doneButton addTarget:self action:@selector(doneButton) forControlEvents:UIControlEventTouchUpInside];
                [currentView addSubview:doneButton];
                return YES;
            }
            if ([self findKeyboard:currentView]) return YES;
        }
    }    
    return NO;    
}

-(void) checkKeyBoard {
    UIWindow* tempWindow;
    
    for(int c = 0; c < [[[UIApplication sharedApplication] windows] count]; c ++)
    {
        tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
        if ([self findKeyboard:tempWindow])
            NSLog(@"Finally, I found it");  
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == offer) {
        [self performSelector:(@selector(checkKeyBoard)) withObject:nil afterDelay:0];
    }
    else        
    {
        [doneButton removeFromSuperview];
    }
} 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

-(IBAction)update:(id)sender{
    
    NSString *eve_nme = event_name.text;
    NSString *off = offer.text;    
    
    NSString *addIpAddress = [ipaddress stringByAppendingString:@"events/update/"];
    NSURL *url = [NSURL URLWithString:addIpAddress];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:user_id forKey:@"token"];
    [request setPostValue:proposal_id forKey:@"proposal_id"];
    [request setPostValue:eve_nme forKey:@"event_name"];
    [request setPostValue:off forKey:@"offer"];
    [request setDelegate:self];
    [request startAsynchronous];    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{ 
    if (event_name.isFirstResponder) {
        [event_name resignFirstResponder];
    }
    if (offer.isFirstResponder) {
        [offer resignFirstResponder];
    }
    return YES;    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
    NSLog(@"Request Finished");   
    if (request.responseStatusCode == 400) 
    {
        [self.view removeFromSuperview];
        NSLog(@"You need to login again");        
    } 
    else if(request.responseStatusCode == 304)
    {
        [self.view removeFromSuperview];
        NSLog(@"Invalid Proposal");   
    }
    else if(request.responseStatusCode == 500)
    {
        [self.view removeFromSuperview];
        NSLog(@"Update Failed");   
    }
    else if(request.responseStatusCode == 204)
    {
        [self.view removeFromSuperview];
        NSLog(@"No Records");   
    }
    else if (request.responseStatusCode == 200) {
        NSString *responseString = [request responseString];
        NSDictionary *responseDict = [responseString JSONValue];
        NSString *unlockCode = [responseDict objectForKey:@"session_token"];
        //        NSLog(@"%@",unlockCode);
        NSString *type = [responseDict objectForKey:@"type"];
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:unlockCode forKey:@"user_id"];
        [defaults setObject:type forKey:@"user_type"];
        [defaults synchronize];
        NSLog(@"Going to call Parent");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"%@", request.responseString);
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request
{    
    NSError *error = [request error];
    NSLog(@"%@", error.localizedDescription);
}

@end
