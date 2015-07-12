//
//  UIButton+DBAwesomeIconized.h
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/1/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DBAwesomeIconized)
@property (nonatomic, strong) UIView *normalBackgroundView;
@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) UILabel *textoLabel;

+ (UIButton *)buttonWithLabel:(NSDictionary *)labelInfo withFrame:(CGRect)frame bgWithColor:(UIColor *)bgColor highLightColor:(UIColor *)highlightColor labelColor:(UIColor *)labelColor alinhado:(BOOL)alinhado iconFontSize:(float)iconFontSize;


- (void)configureButtonWithBackgroundColor:(UIColor *)bgColor andLabelColor:(UIColor *)labelColor enabled:(BOOL)enabled;

- (void)setVisualEnabled:(BOOL)enabled;

- (void)setIcon:(NSString *)iconString;

- (void)setTitle:(NSString *)titleString;

- (void)addUpperIcon:(NSString *)icon withColor:(UIColor *)color fontSize:(float)fontSize;

@end
