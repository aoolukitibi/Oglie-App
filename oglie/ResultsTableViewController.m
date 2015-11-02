//
//  ResultsTableViewController.m
//  Oglie
//
//  Created by Anthony Olukitibi on 1/15/15.
//  Copyright (c) 2015 Anthony Olukitibi All rights reserved.
//

#import "ResultsTableViewController.h"
#import "Result.h"
#import "DataGrabber.h"
#import "CustomTableViewCell.h"

@interface ResultsTableViewController() <DataGrabberDelegate>  {
    DataGrabber *dataGrabber;
    NSMutableArray *dataArray;
    NSArray *colorArray;
}

@end

@implementation ResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    [dataArray addObjectsFromArray:self.passedDataArray];
    colorArray = @[[[UIColor redColor] colorWithAlphaComponent:0.1], [[UIColor greenColor]colorWithAlphaComponent:0.1], [[UIColor blueColor]colorWithAlphaComponent:0.1]];
    checkScroll = YES;
    dataGrabber = [[DataGrabber alloc] init];
    dataGrabber.dataGrabberDelegate = self;
    self.title = [self.what capitalizedString];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(!checkScroll) {
        return dataArray.count+1;
    }
    return dataArray.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if(indexPath.row == dataArray.count ) {
         UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
         cell.backgroundColor = [UIColor whiteColor];
         UIActivityIndicatorView *aSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         aSpinner.center = cell.center;
         [cell addSubview:aSpinner];
         [aSpinner startAnimating];
         return cell;
     }
     CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell" forIndexPath:indexPath];
     Result *result = [dataArray objectAtIndex:indexPath.row];
     [cell setData:result];
     int colorIndex = indexPath.row % 3;
     cell.backgroundColor = [colorArray objectAtIndex:colorIndex];

     
     return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == dataArray.count ) {
        return 50;
    }
    return 150;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //Check if teh user scrolls to bottom - Get latest feed
    if(checkScroll){
        
        NSInteger currentOffset = scrollView.contentOffset.y;
        NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if ((maximumOffset - currentOffset <= 1.0) && (maximumOffset >0)) {
            checkScroll = NO;
            [self.tableView reloadData];
            [dataGrabber getDataWithType:self.what atLocation:self.where atCount:self.theQueryCount];
        }
    }
}

-(void) provide:(NSArray *)freshData{
    [dataArray addObjectsFromArray:freshData];
    [self.tableView reloadData];
    self.theQueryCount += 10;
    checkScroll = YES;
}

-(void) sameData {
    checkScroll = YES;

}

 

@end
