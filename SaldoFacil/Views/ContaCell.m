//
//  ContasCell.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/2/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "ContaCell.h"
#import "Conta.h"

#define titleFontSize 18.0
#define dateFontSize 12.0
#define iconFontSize 18.0
#define margemLeft 15
#define margemRight 15
#define margemTop 10
#define indicatorWidth 10.0
#define indicatorGap 10.0

#define DEFAULT_TITLE_FONT [UIFont titilliumW_regular:titleFontSize]
#define DEFAULT_DATE_FONT [UIFont titilliumW_regular:dateFontSize]

#define iPad [self isPad]

@interface ContaCell ()
@end

@implementation ContaCell


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
    
//    DDLogInfo(@"cell frame: %@", NSStringFromCGSize(self.frame.size));
    UIFont *titleFont = DEFAULT_TITLE_FONT;
    UIFont *dateFont = DEFAULT_DATE_FONT;
    UIFont *iconFont = [UIFont fontWithName:@"fontawesome" size:iconFontSize];

//    DDLogInfo(@"FONT: %@", dateFont);
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = titleFont;
    self.titleLabel.textColor = [UIColor dbBranco];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    self.dateLabel.font = dateFont;
    self.dateLabel.textColor = [UIColor dbGray];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    
    
    self.acessoryLabel = [[UILabel alloc] init];
    self.acessoryLabel.textAlignment = NSTextAlignmentRight;
    self.acessoryLabel.font = iconFont;
    self.acessoryLabel.textColor = [UIColor dbBranco];
    self.acessoryLabel.backgroundColor = [UIColor clearColor];
    self.acessoryLabel.text = @"\uf105";
    
    
    self.selectedIndicator = [[UIView alloc] init];
    
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.acessoryLabel];
    [self.contentView addSubview:self.selectedIndicator];
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    DDLogInfo(@"LAYOUT SUBVIEWS");
    self.selectedIndicator.frame = CGRectMake(0, 0, indicatorWidth, self.frame.size.height);
    [self configuraSelecao];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:YES];
    // DDLogInfo(@"SET SELECTED: %d", selected);
    
//    self.ativa = selected;
    
    [self configuraSelecao];
}



- (void)configuraSelecao
{
    if (self.selected) {
//        DDLogInfo(@"SET SELECTED: %@", self.conta.nome);
        self.titleLabel.textColor =  iPad ? [UIColor dbAzul] : [UIColor dbGray];
        CGRect titleFrame = CGRectMake(25, margemTop, LATERAL_MENU_WIDTH_IPHONE-margemRight-margemLeft-indicatorGap, 34);
        CGRect dateFrame = CGRectMake(25, 39, LATERAL_MENU_WIDTH_IPHONE-margemLeft-10, 15);
        
         if ([self isPad]) {
             titleFrame = CGRectMake(25, margemTop+8, LATERAL_MENU_WIDTH_IPAD-margemRight-margemLeft-indicatorGap, 34);
             dateFrame = CGRectMake(25, 47, LATERAL_MENU_WIDTH_IPAD-margemLeft-10, 15);
         }
        
        
        [UIView animateWithDuration:TRANSITION_TIME animations:^{
            self.titleLabel.frame = titleFrame;
            self.dateLabel.frame = dateFrame;
            self.contentView.backgroundColor = iPad ? [UIColor dbMarinho] : [UIColor dbBranco];
            self.selectedIndicator.backgroundColor = [UIColor dbVermelho];
        }];
        
    } else {
//        DDLogInfo(@"NAO SELECIONADA: %@", self.conta.nome);
        self.titleLabel.textColor = [UIColor dbBranco];
        CGRect titleFrame = CGRectMake(margemLeft, margemTop, LATERAL_MENU_WIDTH_IPHONE-margemRight-margemLeft-indicatorGap, 34);
        CGRect dateFrame = CGRectMake(margemLeft, 39, LATERAL_MENU_WIDTH_IPHONE-margemLeft, 15);

        if ([self isPad]) {
            titleFrame = CGRectMake(margemLeft, margemTop+8, LATERAL_MENU_WIDTH_IPAD-margemRight-margemLeft-indicatorGap, 34);
            dateFrame = CGRectMake(margemLeft, 47, LATERAL_MENU_WIDTH_IPAD-margemLeft, 15);
        }
        
        [UIView animateWithDuration:TRANSITION_TIME animations:^{
            self.titleLabel.frame = titleFrame;
            self.dateLabel.frame = dateFrame;
            
            self.contentView.backgroundColor = [UIColor dbMarinho];
            self.selectedIndicator.backgroundColor = [UIColor dbMarinho];
        }];
    }
}

- (BOOL)isPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

@end
