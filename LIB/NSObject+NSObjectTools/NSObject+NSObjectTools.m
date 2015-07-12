//
//  NSObject+NSObjectTools.m
//  Publicacoes
//
//  Created by Daniel Bonates on 6/15/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "NSObject+NSObjectTools.h"

@implementation NSObject (NSObjectTools)

- (BOOL)currentOrientationIsLandscape
{

    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (currentOrientation == UIInterfaceOrientationLandscapeLeft
        || currentOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else
    {
        return NO;
    }
}

// is iPad?
- (BOOL)isIpad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (CGRect)fullFrame
{
    if (self.isIpad) {
        if (self.currentOrientationIsLandscape)
        {
            return CGRectMake(0, 0, 1024, 768);
        }
        else
        {
            return CGRectMake(0, 0, 768, 1024);
        }
    }
    else
    {
        if (self.currentOrientationIsLandscape)
        {
            return CGRectMake(0, 0, 960, 640);
        }
        else
        {
            return CGRectMake(0, 0, 640, 960);
        }
    }
    return CGRectZero;
}
- (CGRect)frameForCurrentOrientation
{
    CGRect frame;

    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (self.isIpad) {
        if (currentOrientation == UIInterfaceOrientationLandscapeLeft
            || currentOrientation == UIInterfaceOrientationLandscapeRight) {
            frame = CGRectMake(0, 0, 1024, 768);
        }
        else
        {
            frame = CGRectMake(0, 0, 768, 1024);
        }
	
    }
    else
    {
		if (currentOrientation == UIInterfaceOrientationLandscapeLeft
		    || currentOrientation == UIInterfaceOrientationLandscapeRight) {
			frame = CGRectMake(0, 0, 960, 640);
		}
		else {
			frame = CGRectMake(0, 0, 640, 960);
		}
	}
	return frame;
}

//- (void)postNotification:(NSString *)name object:(NSDictionary *)object
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAreaAsked:) name:name object:object];
//
//}

@end
