//
//  StatusbarView.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 8/31/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "StatusbarView.h"

@interface StatusbarView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) BOOL panelOpened;
@end

@implementation StatusbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        DDLogInfo(@"inicializando statusbar bg...");
        self.bgView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundColor = [UIColor dbBranco];
        self.panelOpened = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(panelStateChanged:) name:@"panelStateChange" object:nil];
    }
    return self;
}

- (void)panelStateChanged:(NSNotification *)notification
{
    if (!self.panelOpened) {
        [self fadeToMarinho];
    }
    else {
        [self fadeToWhite];
    }
    
    self.panelOpened = !self.panelOpened;
}

- (void)fadeToMarinho
{
    [UIView animateWithDuration:0.20 animations:^{
        self.backgroundColor = [UIColor dbMarinho];
    }];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)fadeToWhite
{
    [UIView animateWithDuration:0.20 animations:^{
        self.backgroundColor = [UIColor dbBranco];
    }];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

@end
