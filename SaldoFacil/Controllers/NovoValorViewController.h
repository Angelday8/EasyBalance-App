//
//  NovoValorViewController.h
//  SaldoFacil
//
//  Created by Daniel Bonates on 8/28/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@class Valor;


@interface NovoValorViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, strong) Valor *valor;

@property (nonatomic, strong) ContentViewController *parent;

@end
