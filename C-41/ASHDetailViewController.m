//
//  ASHDetailViewController.m
//  C-41
//
//  Created by Ash Furrow on 12/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "ASHDetailViewController.h"

// View Model
#import "ASHDetailViewModel.h"

@interface ASHDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ASHDetailViewController

static NSString *CellIdentifier = @"cell";

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = @"blah blah blah";
    
    return cell;
}

@end
