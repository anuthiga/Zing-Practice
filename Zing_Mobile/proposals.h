//
//  proposals.h
//  Zing_Mobile
//
//  Created by Anuthiga Sriskanthan on 12/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface proposals : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel; 
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *oppositeLabel;

@property (copy, nonatomic) NSString *name; 
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *opposite;

@end
