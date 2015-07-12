//
//  AppDelegate.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 8/25/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "AppDelegate.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "Conta.h"
#import "StatusbarView.h"
#import "MMExampleDrawerVisualStateManager.h"
//#import "ICSyncManager.h"
#import "DBViewContainer.h"
#import "MasterViewController.h"
#import "ContentViewController.h"

#define iPad [self isPad]


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // lumberjack logs
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    
    // Magical record setup
    [MagicalRecord setupAutoMigratingCoreDataStack];
//    [MagicalRecord setupCoreDataStackWithiCloudContainer:@"56N7W5W933.com.bonates.SaldoFacil" localStoreNamed:@"swl.ds"];
    
    
//    [[ICSyncManager sharedManager] checkCloudToken];
    
    // choose storyboard and their views for correct device
    
    
    
    
    UIStoryboard *storyboard = [self storyboard];
    
    
    MasterViewController * leftSideDrawerViewController = [storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
   
    ContentViewController * centerViewController = [storyboard instantiateViewControllerWithIdentifier:@"centerViewController"];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];

    
    if (iPad) {
        
        DBViewContainer *viewContainer = [[DBViewContainer alloc] init];
        
        leftSideDrawerViewController.viewContainer = viewContainer;
        centerViewController.viewContainer = viewContainer;
        
        [viewContainer addMasterViewController:leftSideDrawerViewController];
        [viewContainer addContentViewController:navigationController];
        
//        [viewContainer addViewControllers:@[leftSideDrawerViewController, centerViewController]];
        
        [self.window setRootViewController:viewContainer];
        
    } else {
        
        
        MMDrawerController * drawerController = [[MMDrawerController alloc]
                                                 initWithCenterViewController:navigationController
                                                 leftDrawerViewController:leftSideDrawerViewController];
        
        
        [drawerController setMaximumLeftDrawerWidth:LATERAL_MENU_WIDTH_IPHONE];
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        
        
        [drawerController setShouldStretchDrawer:NO];
        
        
      
        [drawerController
         setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
             MMDrawerControllerDrawerVisualStateBlock block;
             block = [[MMExampleDrawerVisualStateManager sharedManager]
                      drawerVisualStateBlockForDrawerSide:drawerSide];
             if(block){
                 block(drawerController, drawerSide, percentVisible);
             }
         }];
    
        [self.window setRootViewController:drawerController];
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (UIStoryboard *)storyboard
{
    NSString *sbName = @"Storyboard_";
    if ([self isPad]) {
        sbName = [sbName stringByAppendingString:@"iPad"];
    }
    else
    {
        sbName = [sbName stringByAppendingString:@"iPhone"];
    }
    
    return [UIStoryboard storyboardWithName:sbName bundle:nil];
}

- (BOOL)isPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
