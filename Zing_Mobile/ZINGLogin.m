//
//  ZINGLogin.m
//  Zing_Mobile
//
//  Created by Anuthiga Sriskanthan on 12/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ZINGLogin.h"
#import "ZINGManageEvents.h"

@implementation ZINGLogin

@synthesize manageEvents;
@synthesize usernameText;
@synthesize passwordText;
@synthesize resultView;
@synthesize btnLogin;

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
    if(self.view.superview==nil)
    {
        self.view = nil;
    }
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) presentStartUpModal 
{
    if(self.manageEvents==nil)
    { 
        self.manageEvents = [[ZINGManageEvents alloc] initWithNibName:@"ManageEventsView" bundle:[NSBundle mainBundle]];       
    }         
    
    [self.navigationController pushViewController:manageEvents animated:NO];
}

#pragma mark - View lifecycle


//Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [usernameText setDelegate:self];
    [passwordText setDelegate:self];
    
    defaults = [NSUserDefaults standardUserDefaults];
    user_id = [defaults objectForKey:@"user_id"];
    user_type = [defaults objectForKey:@"user_type"];
    
//    user_id = nil;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (user_id != nil) {
        [self performSelector:@selector(presentStartUpModal) withObject:nil afterDelay:0.0f];
    }           
}


- (void)viewDidUnload
{
    [self setUsernameText:nil];
    [self setPasswordText:nil];
    [self setResultView:nil];
    [self setBtnLogin:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if (usernameText.isFirstResponder) {
        [usernameText resignFirstResponder];
    }
    if (passwordText.isFirstResponder) {
        [passwordText resignFirstResponder];
    }   
    return YES;    
}

static NSString* md5( NSString *str )
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
} 

- (IBAction)login:(id)sender {
    
    NSString *username = usernameText.text;
    NSString *password = md5(passwordText.text);
    NSString *addIpAddress = [ipaddress stringByAppendingString:@"auth/login/"];
    NSURL *url = [NSURL URLWithString:addIpAddress];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    
    [request setDelegate:self];
    [request startAsynchronous];    
    
    [usernameText resignFirstResponder];
    [passwordText resignFirstResponder];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
    [usernameText resignFirstResponder];
    [passwordText resignFirstResponder];
    
    if (request.responseStatusCode == 400) {
        resultView.text = @"Invalid User";        
    } 
    else if (request.responseStatusCode == 200) 
    {
        NSString *responseString = [request responseString];
        NSDictionary *responseDict = [responseString JSONValue];
        NSString *unlockCode = [responseDict objectForKey:@"session_token"];
        NSString *type = [responseDict objectForKey:@"type"];
        defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:unlockCode forKey:@"user_id"];
        [defaults setObject:type forKey:@"user_type"];
        [defaults synchronize];
        
        if (unlockCode != nil) 
        {
            [self performSelector:@selector(presentStartUpModal) withObject:nil afterDelay:0.0f];
        }     
    } 
    else 
    {
        resultView.text = request.responseString;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{    
    NSError *error = [request error];
    resultView.text = error.localizedDescription;
}


@end
