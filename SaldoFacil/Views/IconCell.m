//
//  IconCell.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/2/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "IconCell.h"

#define iconFontSize 18.0

@interface IconCell ()
@property(nonatomic, strong) UILabel *iconLabel;
@end

@implementation IconCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildBasic];
    }
    return self;
}

- (void)buildBasic
{
    
    self.contentView.backgroundColor = [UIColor dbMarinho];
    UIFont *iconFont = [UIFont fontWithName:@"fontawesome" size:iconFontSize];
    
    self.iconLabel = [[UILabel alloc] init];
    self.iconLabel.textAlignment = NSTextAlignmentCenter;
    self.iconLabel.font = iconFont;
    self.iconLabel.textColor = [UIColor dbBranco];
    self.iconLabel.backgroundColor = [UIColor clearColor];
    self.iconLabel.text = @"\uf0fe";
    
    [self.contentView addSubview:self.iconLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect iconFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.iconLabel.frame = iconFrame;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
//        DDLogInfo(@"selecionei");
        self.iconLabel.textColor = [UIColor dbGray];
    }
    else
    {
//        DDLogInfo(@"DEselecionei");
        self.iconLabel.textColor = [UIColor dbBranco];
    }
    
    [self layoutIfNeeded];
    
}



@end
