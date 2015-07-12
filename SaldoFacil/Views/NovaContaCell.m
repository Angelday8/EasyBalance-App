//
//  NovaContaCell.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/13/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "NovaContaCell.h"

#define BACKGROUND_COLOR [UIColor whiteColor]

#define margemLeft 15


@implementation NovaContaCell

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
    
    self.contentView.backgroundColor = BACKGROUND_COLOR;
    
    UIFont *infoFont = [UIFont titilliumW_regular:18.0];
    
    
    //nomeFont
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.textAlignment = NSTextAlignmentLeft;
    self.infoLabel.font = infoFont;
    self.infoLabel.textColor = [UIColor dbGray];
    self.infoLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.infoLabel];
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //    DDLogInfo(@"Width da cell: %f", tableWidth);
    
    CGRect infoFrame = self.bounds;
    infoFrame.origin.x = margemLeft;
    infoFrame.size.width -= (margemLeft*2);
    self.infoLabel.frame = infoFrame;
    

    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
