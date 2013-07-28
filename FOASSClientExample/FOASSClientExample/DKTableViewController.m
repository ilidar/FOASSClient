//
//  DKTableViewController.m
//  FOASSClientExample
//
//  Created by Denys Kotelovych on 28.07.13.
//  Copyright (c) 2013 DKSoftware. All rights reserved.
//

#import "DKTableViewController.h"

static NSString * const sSenderName   = @"User_1";
static NSString * const sReceiverName = @"User_2";

@interface DKTableViewController ()

@property (nonatomic, strong) NSArray *sections;

@end

@implementation DKTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.sections = @[FOASSGetAllSingleTypes(), FOASSGetAllDoubleTypes()];
  }
  return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.sections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell_ID" forIndexPath:indexPath];
  
  NSNumber *type = self.sections[indexPath.section][indexPath.row];
  
  if (indexPath.section == 0) {
    cell.textLabel.text = FOASSStringTypeFromSingleType([type integerValue]);
  } else {
    cell.textLabel.text = FOASSStringTypeFromDoubleType([type integerValue]);
  }
  
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return section == 0 ? @"Single" : @"Double";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
  id success = ^(FOASSMessage *message) {
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Message"
                                                   message:[NSString stringWithFormat:@"%@ %@",
                                                            message.message,
                                                            message.subtitle]
                                                  delegate:nil
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:nil, nil];
      [av show];
  };
  
  id failure = ^(NSError *error) {
      NSLog(@"%@", error);
  };
  
  
  NSNumber *type = self.sections[indexPath.section][indexPath.row];
  
  if (indexPath.section == 0) {
    [[FOASSClient sharedInstance] getMessageWithSingleType:[type integerValue]
                                                senderName:sSenderName
                                                   success:success
                                                   failure:failure];
  } else {
    [[FOASSClient sharedInstance] getMessageWithDoubleType:[type integerValue]
                                              receiverName:sReceiverName
                                                senderName:sSenderName
                                                   success:success
                                                   failure:failure];
  }
}

#pragma mark - Private Methods

@end
