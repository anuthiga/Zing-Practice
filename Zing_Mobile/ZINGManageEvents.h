//
//  ZINGManageEvents.h
//  Zing_Mobile
//
//  Created by Anuthiga Sriskanthan on 12/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZINGEditEvent;

@interface ZINGManageEvents : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *proposalsData;
@property (retain, nonatomic) IBOutlet ZINGEditEvent *editEvent;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
