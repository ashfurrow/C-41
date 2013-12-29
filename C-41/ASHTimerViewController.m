//
//  ASHTimerViewController.m
//  C-41
//
//  Created by Ash Furrow on 12/28/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "ASHTimerViewController.h"

// View Model
#import "ASHTimerViewModel.h"

@interface ASHTimerViewController ()

@end

@implementation ASHTimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Configure Self
    self.title = [self.viewModel recipeName];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    // Reactive Bindings
    @weakify(self);
    RAC(self.navigationItem, rightBarButtonItem) = [[RACObserve(self.viewModel, running) distinctUntilChanged] map:^id(NSNumber *running) {
        @strongify(self);
        if ([running boolValue] == YES) {
            return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pause)];
        } else {
            return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(resume)];
        }
    }];
}

#pragma mark - Private Methods

-(void)pause {
    [self.viewModel pause];
}

-(void)resume {
    [self.viewModel resume];
}

-(void)cancel {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
