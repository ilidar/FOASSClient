//
//  DKViewController.m
//  FOASSClientExample
//
//  Created by Denys Kotelovych on 28.07.13.
//  Copyright (c) 2013 DKSoftware. All rights reserved.
//

#import "DKViewController.h"

@interface DKViewController ()

@end

@implementation DKViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[FOASSClient sharedInstance] getMessageWithDoubleType:DKFOASSMessageDoubleTypeLinus
                                            receiverName:@"K"
                                              senderName:@"D"success:^(FOASSMessage *message) {
                                                  NSLog(@"%@ %@", message.message, message.subtitle);
                                              } failure:^(NSError *error) {
                                                  NSLog(@"%@", error);
                                              }];
}

@end
