//
//  ZINGEditEvent.h
//  Zing_Mobile
//
//  Created by Anuthiga Sriskanthan on 12/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZINGEditEvent : UIViewController

@property (strong, nonatomic) NSArray *proposalData;

@property (retain, nonatomic) IBOutlet UILabel *opp_title;
@property (retain, nonatomic) IBOutlet UILabel *opp_name; 
@property (retain, nonatomic) IBOutlet UILabel *artist_name; 

@property (retain, nonatomic) IBOutlet UITextField *offer;
@property (retain, nonatomic) IBOutlet UITextField *event_name;

@property (retain, nonatomic) IBOutlet UITextView *offer_err;
@property (retain, nonatomic) IBOutlet UIButton *btnUpdate;

- (IBAction)update:(id)sender;
- (IBAction)keyboardWillShow:(id)sender;

@end
