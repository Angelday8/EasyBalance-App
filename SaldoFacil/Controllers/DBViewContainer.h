//
//  MasterViewController.h
//  Containers
//
//  Created by Daniel Bonates on 7/12/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBViewContainer : UIViewController

@property (nonatomic, assign) id delegate;

@property (strong, nonatomic) UIViewController *masterViewController;
@property (strong, nonatomic) UIViewController *contentViewController;

- (void)addMasterViewController:(UIViewController *)mvc;
- (void)addContentViewController:(UIViewController *)mvc;


@end
