//
//  ZINGLogin.h
//  Zing_Mobile
//
//  Created by Anuthiga Sriskanthan on 12/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZINGManageEvents;

@interface ZINGLogin : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *usernameText; 
@property (retain, nonatomic) IBOutlet UITextField *passwordText;
@property (retain, nonatomic) IBOutlet UITextView *resultView;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;
@property (retain, nonatomic) IBOutlet ZINGManageEvents *manageEvents;

- (IBAction)login:(id)sender;

@end
