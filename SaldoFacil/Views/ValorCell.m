//
//  ValorCell.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/4/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "ValorCell.h"
#import "Valor.h"

#define infoFontSize 20.0
#define dateFontSize 12.0
#define valorFontSize 22.0
#define iconFontSize 18.0
#define margemLeft 15
#define margemRight 15
#define margemTop 10
#define SIGNAL_WIDTH 30

#define STR_PLUS @"\uf067"
#define STR_MINUS @"\uf068"

//#define BACKGROUND_COLOR [UIColor dbBranco]
#define BACKGROUND_COLOR [UIColor whiteColor]

@interface ValorCell()
@property(nonatomic, strong) UILabel *infoLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *valorLabel;
@property(nonatomic, strong) UILabel *sinalLabel;
@end

@implementation ValorCell

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
    
    UIFont *infoFont = [UIFont titilliumW_regular:infoFontSize];
    UIFont *valorFont = [UIFont titilliumW_medium:valorFontSize];
    UIFont *dateFont = [UIFont titilliumW_light: dateFontSize];
    UIFont *iconFont = [UIFont fontWithName:@"fontawesome" size:iconFontSize];
    
    
    //nomeFont
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.textAlignment = NSTextAlignmentLeft;
    self.infoLabel.font = infoFont;
    self.infoLabel.textColor = [UIColor dbGray];
    self.infoLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.infoLabel];
    
    //dateLabel
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    self.dateLabel.font = dateFont;
    self.dateLabel.textColor = [UIColor dbGray];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.dateLabel];
    
    //valorLabel
    self.valorLabel = [[UILabel alloc] init];
    self.valorLabel.textAlignment = NSTextAlignmentRight;
    self.valorLabel.font = valorFont;
    self.valorLabel.textColor = [UIColor dbMarinho];
    self.valorLabel.backgroundColor = [UIColor clearColor];
    self.valorLabel.text = @"";
    [self addSubview:self.valorLabel];
    
    //sinalLabel
    self.sinalLabel = [[UILabel alloc] init];
    self.sinalLabel.textAlignment = NSTextAlignmentRight;
    self.sinalLabel.font = iconFont;
    self.sinalLabel.textColor = [UIColor dbBranco];
    self.sinalLabel.backgroundColor = [UIColor clearColor];
    self.sinalLabel.text = STR_PLUS;
    [self addSubview:self.sinalLabel];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    float tableWidth = self.bounds.size.width;
//    DDLogInfo(@"Width da cell: %f", tableWidth);
    
    CGRect infoFrame = CGRectMake(margemLeft, 13, tableWidth*.6-margemLeft, 24);
    self.infoLabel.frame = infoFrame;
    
    CGRect dateFrame = CGRectMake(margemLeft, 40, tableWidth*.6-margemLeft, 15);
    self.dateLabel.frame = dateFrame;
    
    CGRect valorLabelFrame = CGRectMake(tableWidth-130.0-margemRight-SIGNAL_WIDTH, 3, 130.0, self.frame.size.height);
    self.valorLabel.frame = valorLabelFrame;
    
    self.sinalLabel.frame = CGRectMake(tableWidth-margemRight-SIGNAL_WIDTH, 0, SIGNAL_WIDTH, self.frame.size.height);

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self layoutIfNeeded];
}

- (void)configurarValor:(Valor *)novoValor
{
    if(![self.valor isEqual:novoValor])
    {
        self.valor = novoValor;
    }
    
    
//    DDLogInfo (@"configurar meu valor: %@", novoValor.valor);
    self.infoLabel.text = novoValor.info;
//    NSString *currencySymbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
//    self.valorLabel.text = [NSString stringWithFormat:@"%@ %@", currencySymbol, novoValor.valorString];
    self.valorLabel.text = [NSString currencyStringFromNumber:novoValor.valor];
    self.dateLabel.text = [NSDate shortStyle:novoValor.data];
    self.sinalLabel.textColor = [novoValor.receita boolValue] ? [UIColor dbVerde] : [UIColor dbVermelho];;
    self.sinalLabel.text = [novoValor.receita boolValue] ? STR_PLUS : STR_MINUS;
    
    return;
    
    
    
    
    if (![self.valor isEqual:novoValor]) {

        if(!self.valor)
        {
            self.valor = [[Valor alloc] init];
        }
        
        return;
        self.valorLabel.text = [novoValor.valor stringValue];
        self.infoLabel.text = self.valor.info;
        self.dateLabel.text = [NSDate shortStyle:self.valor.data];
        self.sinalLabel.text = self.valor.receita ? STR_PLUS : STR_MINUS;
    }
    
    [self setNeedsDisplay];
}

@end
