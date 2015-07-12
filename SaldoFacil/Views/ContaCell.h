//
//  ContasCell.h
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/2/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Conta;

@interface ContaCell : UITableViewCell

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *acessoryLabel;
@property(nonatomic, strong) UIView *selectedIndicator;

@property(nonatomic, strong) Conta *conta;
//@property(nonatomic, assign) BOOL ativa;




@end
