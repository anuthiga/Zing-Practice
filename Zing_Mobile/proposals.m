//
//  proposals.m
//  Zing_Mobile
//
//  Created by Anuthiga Sriskanthan on 12/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "proposals.h"

@implementation proposals

@synthesize name;
@synthesize date;
@synthesize opposite;

@synthesize nameLabel;
@synthesize dateLabel;
@synthesize oppositeLabel;

- (void)setName:(NSString *)n 
{ 
    if (![n isEqualToString:name]) 
    {
        name = [n copy]; 
        nameLabel.text = name;
        
    }
}

- (void)setDate:(NSString *)d 
{ 
    if (![d isEqualToString:date]) 
    {
        date = [d copy]; 
        dateLabel.text = date;
        
    }
}

- (void)setOpposite:(NSString *)o 
{ 
    if (![o isEqualToString:opposite]) 
    {
        opposite = [o copy]; 
        oppositeLabel.text = opposite;
        
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
