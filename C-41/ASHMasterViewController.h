//
//  ASHMasterViewController.h
//  C-41
//
//  Created by Ash Furrow on 12/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASHMasterViewModel;

@interface ASHMasterViewController : UITableViewController

@property (nonatomic, strong) ASHMasterViewModel *viewModel;

@end
