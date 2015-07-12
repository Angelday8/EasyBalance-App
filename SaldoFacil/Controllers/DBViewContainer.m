//
//  MainViewController.m
//  Containers
//
//  Created by Daniel Bonates on 7/12/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "DBViewContainer.h"
//#import "MasterViewController.h"
//#import "DetailManagerViewController.h"



// categoria para viewContainer property on subViews

@interface UIViewController (DBViewContainerAddOn)
@property (nonatomic, strong) DBViewContainer *viewContainer;
@end


@interface DBViewContainer ()


    


@end

@implementation DBViewContainer


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (void)addMasterViewController:(UIViewController *)mvc
{
    self.masterViewController = mvc;
    CGRect masterFrame = mvc.view.frame;
    masterFrame.size.width = LATERAL_MENU_WIDTH_IPAD;
    masterFrame.origin.x = 0;
    masterFrame.origin.y = 0;
//    self.masterViewController.viewContainer = self;
    self.masterViewController.view.frame = masterFrame;
    self.masterViewController.view.clipsToBounds = YES;
    [self.view addSubview:self.masterViewController.view];
}


- (void)addContentViewController:(UIViewController *)mvc
{
    self.contentViewController = mvc;
    CGRect contentFrame = mvc.view.frame;
    contentFrame.size.width = 548.0;
    contentFrame.origin.x = LATERAL_MENU_WIDTH_IPAD;
    contentFrame.origin.y = 0;
//    self.contentViewController.viewContainer = self;
    self.contentViewController.view.frame = contentFrame;
    self.contentViewController.view.clipsToBounds = YES;
    [self.view addSubview:self.contentViewController.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
