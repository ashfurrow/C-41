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

@property (weak, nonatomic) IBOutlet UILabel *timeRemainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextStepLabel;

@end

@implementation ASHTimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Configure Self
    self.title = [self.viewModel recipeName];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    // Configure subviews
    self.timeRemainingLabel.layer.cornerRadius = CGRectGetHeight(self.timeRemainingLabel.frame) / 2.0f;
    self.timeRemainingLabel.layer.borderWidth = 5.0f;
    self.timeRemainingLabel.layer.borderColor = [[UIColor colorWithHexString:@"DE9726"] CGColor];
    self.timeRemainingLabel.textColor = [UIColor colorWithHexString:@"522404"];
    
    // Reactive Bindings
    @weakify(self);
    RAC(self.stepNameLabel, text) = RACObserve(self.viewModel, currentStepString);
    RAC(self.timeRemainingLabel, text) = RACObserve(self.viewModel, timeRemainingString);
    RAC(self.nextStepLabel, text) = RACObserve(self.viewModel, nextStepString);
    RAC(self.navigationItem, rightBarButtonItem) = [[RACObserve(self.viewModel, running) distinctUntilChanged] map:^id(NSNumber *running) {
        @strongify(self);
        if ([running boolValue] == YES) {
            return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pause)];
        } else {
            return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(resume)];
        }
    }];
    [RACObserve(self.viewModel, complete) subscribeNext:^(NSNumber *complete) {
        if (complete.boolValue == YES) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Recipe Complete", @"Recipe complete dialogue title") message:NSLocalizedString(@"Your film has been developed.", @"Recipe complete dialogue text") delegate:Nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", @"Recipe complete dialogue OK button"), nil];
            [alertView.rac_buttonClickedSignal subscribeNext:^(id _) {
                @strongify(self);
                [self dismiss];
            }];
            [alertView show];
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
    [self dismiss];
}

-(void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
