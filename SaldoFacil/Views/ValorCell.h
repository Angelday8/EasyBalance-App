//
//  ValorCell.h
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/4/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Valor;

@interface ValorCell : UITableViewCell
@property (nonatomic, strong) Valor *valor;
- (void)configurarValor:(Valor *)novoValor;
@end
