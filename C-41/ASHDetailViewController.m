//
//  ASHDetailViewController.m
//  C-41
//
//  Created by Ash Furrow on 12/21/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

// View Controllers
#import "ASHDetailViewController.h"
#import "ASHTimerViewController.h"

// View Model
#import "ASHDetailViewModel.h"

enum {
    ASHDetailViewControllerInfoSection = 0,
    ASHDetailViewControllerStepsSection,
    ASHDetailViewControllerNumberOfSections
};

enum {
    ASHDetailViewControllerInfoNameRow = 0,
    ASHDetailViewControllerInfoDescriptionRow,
    ASHDetailViewControllerInfoFilmTypeRow,
    ASHDetailViewControllerInfoNumberOfRows
};

@interface ASHDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *startButton;

@end

@implementation ASHDetailViewController

static NSString *CellIdentifier = @"cell";

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = self.viewModel.recipeName;
    
    // Reactive Bindings
    RAC(self.startButton, enabled) = RACObserve(self.viewModel, canStartTimer);
}

#pragma mark - Navigation Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"start"]) {
        ASHTimerViewController *viewController = (ASHTimerViewController *)[segue.destinationViewController topViewController];
        viewController.viewModel = [self.viewModel timerViewModel];
    }
}

#pragma mark - UITableViewDataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ASHDetailViewControllerNumberOfSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == ASHDetailViewControllerInfoSection) {
        return ASHDetailViewControllerInfoNumberOfRows;
    } else if (section == ASHDetailViewControllerStepsSection) {
        return [self.viewModel numberOfSteps];
    }
    
    // silence compiler warning
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == ASHDetailViewControllerInfoSection) {
        return NSLocalizedString(@"Info", @"Detail info section title");
    } else {
        return NSLocalizedString(@"Steps", @"Detail steps section title");
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.section == ASHDetailViewControllerInfoSection) {
        cell.detailTextLabel.text = nil;
        if (indexPath.row == ASHDetailViewControllerInfoNameRow) {
            cell.textLabel.text = [self.viewModel recipeName];
        } else if (indexPath.row ==  ASHDetailViewControllerInfoDescriptionRow) {
            cell.textLabel.text = [self.viewModel recipeDescription];
        } else if (indexPath.row ==  ASHDetailViewControllerInfoFilmTypeRow) {
            cell.textLabel.text = [self.viewModel recipeFilmTypeString];
        }
    } else if (indexPath.section == ASHDetailViewControllerStepsSection) {
        cell.textLabel.text = [self.viewModel titleForStepAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.viewModel subtitleForStepAtIndex:indexPath.row];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ASHDetailViewControllerInfoSection && indexPath.row == ASHDetailViewControllerInfoDescriptionRow) {
        NSString *description = self.viewModel.recipeDescription;
        
        CGRect rect = [description boundingRectWithSize:CGSizeMake(290, 9000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
        
        return MAX(44.0f, CGRectGetHeight(rect) + 23);
    } else {
        return 44.0f;
    }
}

@end
