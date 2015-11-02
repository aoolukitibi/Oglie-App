//
//  ResultsTableViewController.h
//  Oglie
//
//  Created by Anthony Olukitibi on 1/15/15.
//  Copyright (c) 2015 Anthony Olukitibi All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsTableViewController : UITableViewController {
    BOOL checkScroll;
}

@property (nonatomic, strong) NSArray *passedDataArray;
@property (nonatomic, assign) int theQueryCount;
@property (nonatomic, strong) NSString *what;
@property (nonatomic, strong) NSString *where;

@end
