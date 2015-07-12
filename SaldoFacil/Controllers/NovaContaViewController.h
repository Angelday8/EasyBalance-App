//
//  NovaContaViewController.h
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/2/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class Conta;

@interface NovaContaViewController : UIViewController

@property (nonatomic, strong) MasterViewController *masterView;
@property (nonatomic, strong) Conta *conta;


@end
