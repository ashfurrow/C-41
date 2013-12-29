//
//  ASHTimerViewController.m
//  C-41
//
//  Created by Ash Furrow on 12/28/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "ASHTimerViewController.h"

@interface ASHTimerViewController ()

@end

@implementation ASHTimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Configure Self
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
}

#pragma mark - Private Methods

-(void)cancel {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
