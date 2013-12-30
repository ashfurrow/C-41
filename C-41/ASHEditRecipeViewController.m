//
//  ASHEditRecipeViewController.m
//  C-41
//
//  Created by Ash Furrow on 12/22/2013.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

// View Controllers
#import "ASHEditRecipeViewController.h"
#import "ASHEditStepViewController.h"

// View Model
#import "ASHEditRecipeViewModel.h"
#import "ASHEditStepViewModel.h"

// Views
#import "ASHTextFieldCell.h"

enum {
    ASHEditRecipeViewControllerMetadataSection = 0,
    ASHEditRecipeViewControllerFilmTypeSection,
    ASHEditRecipeViewControllerStepsSection,
    ASHEditRecipeViewControllerNumberOfSections
};

@interface ASHEditRecipeViewController ()

@end

@implementation ASHEditRecipeViewController

static NSString *TitleCellIdentifier = @"title";
static NSString *DescriptionCellIdentifier = @"description";
static NSString *StepCellIdentifier = @"step";
static NSString *AddStepCellIdentifier = @"addStep";
static NSString *FilmTypeCellIdentifier = @"filmType";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.editing = YES;
    
    if ([self.viewModel shouldShowCancelButton] == NO) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    // ReactiveCocoa Bindings
    RAC(self, title) = RACObserve(self.viewModel, name);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Need to reload since steps may have changed.
    [self.tableView reloadData];
}

#pragma mark - User Interaction

-(IBAction)cancelWasPressed:(id)sender {
    [self.viewModel cancel];
    [self dismissSelf];
}

-(IBAction)doneWasPressed:(id)sender {
    [self dismissSelf];
}

#pragma mark - Private Methods

-(void)dismissSelf {
    [self.viewModel willDismiss];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editStep"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ASHEditStepViewModel *viewModel = [self.viewModel editStepViewModelAtIndex:indexPath.row];
        
        ASHEditStepViewController *viewController = segue.destinationViewController;
        viewController.viewModel = viewModel;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return ASHEditRecipeViewControllerNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == ASHEditRecipeViewControllerMetadataSection) {
        return 2;
    } else if (section == ASHEditRecipeViewControllerFilmTypeSection) {
        return 3;
    } else if (section == ASHEditRecipeViewControllerStepsSection) {
        return [self.viewModel numberOfSteps] + 1; //+1 for "add" row
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    if (indexPath.section == ASHEditRecipeViewControllerMetadataSection) {
        if (indexPath.row == 0) {
            cellIdentifier = TitleCellIdentifier;
        } else {
            cellIdentifier = DescriptionCellIdentifier;
        }
    } else if (indexPath.section == ASHEditRecipeViewControllerFilmTypeSection) {
        cellIdentifier = FilmTypeCellIdentifier;
    } else {
        if (indexPath.row == [self.viewModel numberOfSteps]) {
            cellIdentifier = AddStepCellIdentifier;
        } else {
            cellIdentifier = StepCellIdentifier;
        }
    }
    
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == ASHEditRecipeViewControllerMetadataSection) {
        if (indexPath.row == 0) {
            [self configureTitleCell:cell forIndexPath:indexPath];
        } else {
            [self configureDescriptionCell:cell forIndexPath:indexPath];
        }
    } else if (indexPath.section == ASHEditRecipeViewControllerFilmTypeSection) {
        [self configureFilmTypeCell:cell forIndexPath:indexPath];
    } else {
        if (indexPath.row < [self.viewModel numberOfSteps]) {
            [self configureStepCell:cell forIndexPath:indexPath];
        } else {
            // nop – configured in storyboard
        }
    }
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == ASHEditRecipeViewControllerFilmTypeSection ||
           indexPath.section == ASHEditRecipeViewControllerStepsSection;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == ASHEditRecipeViewControllerFilmTypeSection) {
        int32_t oldFilmType = self.viewModel.filmType;
        self.viewModel.filmType = [self.viewModel filmTypeForSection:indexPath.row];
        if (oldFilmType != self.viewModel.filmType) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:[self.viewModel sectionForFilmTpe:oldFilmType] inSection:ASHEditRecipeViewControllerFilmTypeSection]] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (indexPath.section == ASHEditRecipeViewControllerStepsSection) {
        if (indexPath.row < [self.viewModel numberOfSteps]) {
            // will be taken care of by storyboard
        } else {
            [self.viewModel addStep];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:ASHEditRecipeViewControllerStepsSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == ASHEditRecipeViewControllerMetadataSection) {
        return nil;
    } else if (section == ASHEditRecipeViewControllerFilmTypeSection) {
        return NSLocalizedString(@"Film Type", @"Edit View Controller section title");
    } else if (section == ASHEditRecipeViewControllerStepsSection) {
        return NSLocalizedString(@"Steps", @"Edit View Controller section title");
    } else {
        return nil;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == ASHEditRecipeViewControllerStepsSection) {
        return YES;
    } else {
        return NO;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ASHEditRecipeViewControllerStepsSection) {
        if (indexPath.row == [self.viewModel numberOfSteps]) {
            return UITableViewCellEditingStyleInsert;
        } else {
            return UITableViewCellEditingStyleDelete;
        }
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.viewModel removeStepAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        [self.viewModel addStep];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:ASHEditRecipeViewControllerStepsSection] withRowAnimation:UITableViewRowAnimationAutomatic];
    }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.viewModel moveStepFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return indexPath.section == ASHEditRecipeViewControllerStepsSection && indexPath.row < [self.viewModel numberOfSteps];
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.section == ASHEditRecipeViewControllerStepsSection && proposedDestinationIndexPath.row < [self.viewModel numberOfSteps]) {
        return proposedDestinationIndexPath;
    } else {
        return sourceIndexPath;
    }
}

#pragma mark - Cell Configuration

-(void)configureStepCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [self.viewModel stepTitleAtIndex:indexPath.row];
}

-(void)configureDescriptionCell:(ASHTextFieldCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.textField.text = self.viewModel.blurb;
    RAC(self.viewModel, blurb) = [cell.textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
}

-(void)configureTitleCell:(ASHTextFieldCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.textField.text = self.viewModel.name;
    RAC(self.viewModel, name) = [cell.textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
}

-(void)configureFilmTypeCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    int32_t filmType = [self.viewModel filmTypeForSection:indexPath.row];
    NSString *title = [self.viewModel titleForFilmTyle:filmType];
    cell.textLabel.text = title;
    
    BOOL isFilmType = filmType == self.viewModel.filmType;
    cell.accessoryType = isFilmType ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
}

@end
