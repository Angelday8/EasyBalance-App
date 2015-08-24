//
//  UIButton+DBExtras.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/1/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "UIButton+DBAwesomeIconized.h"
#import <objc/runtime.h>

#define defaultIconFontSize 22.0
#define defaultLabelFontSize 18.0
#define iconSquareSize 48.0
//#define margem 25.0
#define gapBetweenIconAndText 15.0

#define DEFAULT_LABEL_FONT [UIFont titilliumW_regular:defaultLabelFontSize]

static char buttonTextKey;
static char buttonIconKey;
//static char backgroundColorsKey;
static char normalBackgroundViewKey;




@implementation UIButton (DBAwesomeIconized)

NSString *SETA_UP_STR = @"\uf077";
NSString *SETA_DOWN_STR = @"\uf078";

#pragma mark - buttonbuild


+ (UIButton *)buttonWithLabel:(NSDictionary *)labelInfo withFrame:(CGRect)frame bgWithColor:(UIColor *)bgColor highLightColor:(UIColor *)highlightColor labelColor:(UIColor *)labelColor alinhado:(BOOL)alinhado iconFontSize:(float)iconFontSize
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    

    float IconFontSizeToUse = (iconFontSize != 0) ? iconFontSize : defaultIconFontSize;
    
    UIFont *iconFont = [UIFont fontWithName:@"fontawesome" size:IconFontSizeToUse];
//    UIFont *labelFont = DEFAULT_LABEL_FONT;
    
    // default background color
    if (bgColor) {
        button.backgroundColor = bgColor;
    }
    else
    {
        button.backgroundColor = [UIColor dbMarinho];
    }

    
    // backgroundView
    CGRect fullFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [button addBackgroundViewWithFrame:fullFrame color:highlightColor];
    
    // icon and Label present
    if (!isEmpty([labelInfo objectForKey:@"icone"]) && !isEmpty([labelInfo objectForKey:@"texto"]))
    {
        
        NSDictionary *iconFontAttributes = @{NSFontAttributeName: iconFont};
        
    
        NSString *iconText = [labelInfo objectForKey:@"icone"];
        CGSize iconLabelSize = [iconText sizeWithAttributes:iconFontAttributes];
//        CGSize iconLabelSize = [iconText sizeWithFont:iconFont];
        CGRect iconLabelFrame = CGRectMake(0, 0, iconLabelSize.width, frame.size.height);
    
    
    
        NSDictionary *labelFontAttributes = @{NSFontAttributeName: DEFAULT_LABEL_FONT};
        NSString *labelText = [labelInfo objectForKey:@"texto"];
        CGSize labelSize = [labelText sizeWithAttributes:labelFontAttributes];
//        CGSize labelSize = [labelText sizeWithFont:labelFont];
        CGRect textLabelFrame = CGRectMake(0, 0, labelSize.width, frame.size.height);
    
    
        // reposiciona no centro
        float allWidthSize = iconLabelSize.width+gapBetweenIconAndText+labelSize.width;
        float margem = (frame.size.width - allWidthSize)/2;
    
        iconLabelFrame.origin.y -= 2;
        iconLabelFrame.origin.x = alinhado ? iconSquareSize-iconLabelFrame.size.width : margem;
        textLabelFrame.origin.x = alinhado ? iconSquareSize+gapBetweenIconAndText : iconLabelFrame.origin.x + iconLabelFrame.size.width+gapBetweenIconAndText;
    
        [button addIconLabelWithFrame:iconLabelFrame fontSize:defaultIconFontSize fontColor:labelColor text:iconText alone:NO];
        [button addTextLabelWithFrame:textLabelFrame fontSize:defaultLabelFontSize fontColor:labelColor text:labelText alone:NO];
    
    }
    
    // icon only
    else if (!isEmpty([labelInfo objectForKey:@"icone"]) && isEmpty([labelInfo objectForKey:@"texto"]))
    {
        CGRect iconLabelFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [button addIconLabelWithFrame:iconLabelFrame fontSize:IconFontSizeToUse fontColor:labelColor text:[labelInfo objectForKey:@"icone"] alone:YES];
    }
    
    // label only
    else if (isEmpty([labelInfo objectForKey:@"icone"]) && !isEmpty([labelInfo objectForKey:@"texto"]))
    {
        CGRect textLabelFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [button addTextLabelWithFrame:textLabelFrame fontSize:defaultLabelFontSize fontColor:labelColor text:[labelInfo objectForKey:@"texto"] alone:YES];
    }
    
    
    return button;
    
}



- (void)addIconLabelWithFrame:(CGRect)frame fontSize:(float)fontSize fontColor:(UIColor *)fontColor text:(NSString *)text alone:(BOOL)alone
{
    UIFont *iconFont = [UIFont fontWithName:@"fontawesome" size:fontSize];
    
    // icon
    self.iconLabel = [[UILabel alloc] initWithFrame:frame]; // ? 3 compensa diferença de baseline das fontes de icone e label
    self.iconLabel.font = iconFont;
    self.iconLabel.textColor = fontColor;
    self.iconLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.iconLabel.textAlignment = alone ? NSTextAlignmentCenter : NSTextAlignmentRight;
    self.iconLabel.backgroundColor = [UIColor clearColor];
    self.iconLabel.text = text;
    
    [self addSubview:self.iconLabel];
    
}

- (void)addTextLabelWithFrame:(CGRect)frame fontSize:(float)fontSize fontColor:(UIColor *)fontColor text:(NSString *)text alone:(BOOL)alone
{
    UIFont *labelFont = DEFAULT_LABEL_FONT;
    
    self.textoLabel = [[UILabel alloc] initWithFrame:frame];
    self.textoLabel.font = labelFont;
    self.textoLabel.textColor = fontColor;
    self.textoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textoLabel.textAlignment = alone ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    self.textoLabel.backgroundColor = [UIColor clearColor];
    self.textoLabel.text = text;
    
    [self addSubview:self.textoLabel];
}

// backGroundView
- (void)addBackgroundViewWithFrame:(CGRect)frame color:(UIColor *)color
{
    self.normalBackgroundView = [[UIView alloc] initWithFrame:frame];
    self.normalBackgroundView.backgroundColor = color;
    [self.normalBackgroundView setUserInteractionEnabled:NO];
    self.normalBackgroundView.hidden = YES;
    [self addSubview:self.normalBackgroundView];
}



# pragma mark - enable / disalbe

- (void)configureButtonWithBackgroundColor:(UIColor *)bgColor andLabelColor:(UIColor *)labelColor enabled:(BOOL)enabled
{
//    DDLogInfo(@"disableWithBackGroundColor");
    self.iconLabel.textColor = labelColor;
    self.textoLabel.textColor = labelColor;
    [UIView animateWithDuration:TRANSITION_TIME animations:^{
        self.backgroundColor = bgColor;
    }];
    [self setNeedsDisplay];
    self.enabled = enabled;
}


#pragma mark - object assossiations


// iconLabel
- (void)setIconLabel:(UILabel *)iconLabel
{
    objc_setAssociatedObject(self, &buttonIconKey, iconLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (UILabel *)iconLabel
{
    return objc_getAssociatedObject(self, &buttonIconKey);
}

// textoLabel
- (void)setTextoLabel:(UILabel *)textoLabel
{
    objc_setAssociatedObject(self, &buttonTextKey, textoLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (UILabel *)textoLabel
{
    return objc_getAssociatedObject(self, &buttonTextKey);
}


// normalBackgroundViewKey
- (void)setNormalBackgroundView:(UIView *)normalBackgroundView
{
    objc_setAssociatedObject(self, &normalBackgroundViewKey, normalBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (UIView *)normalBackgroundView
{
    return objc_getAssociatedObject(self, &normalBackgroundViewKey);
}


// bind alpha value with enable state
- (void)setVisualEnabled:(BOOL)enabled
{
    [self setEnabled:enabled];
    
    if (enabled) {
        self.alpha = 1.0;
    }
    else
    {
        self.alpha = 0.3;
    }
}


- (void)setIcon:(NSString *)iconString
{
    //self.iconLabel.text = iconString;
    CGAffineTransform rotation;
    
    if ([iconString isEqualToString:SETA_UP_STR]) {
        rotation = CGAffineTransformMakeRotation(0);
    } else {
        rotation = CGAffineTransformMakeRotation(3.14);
    }
    
    [UIView animateWithDuration:TRANSITION_TIME delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.iconLabel.transform = rotation;
    } completion:^(BOOL finished) {
        
        CGFloat duration = 1;
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
        animation.values = @[@0, @0.18, @-0.18, @0.18, @0];
        animation.keyTimes = @[@0, @0.2, @0.4, @0.6, @0.8, @1];
        animation.duration = duration;
        animation.additive = true;
        
        [self.iconLabel.layer addAnimation:animation forKey: @"wooble"];

    }];
}

- (void)setTitle:(NSString *)titleString
{
    self.textoLabel.text = titleString;
}

- (void)addUpperIcon:(NSString *)icon withColor:(UIColor *)color fontSize:(float)fontSize
{
    UIFont *iconFont = [UIFont fontWithName:@"fontawesome" size:fontSize];
    
    // icon
    UILabel *upperIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2+5, 0, 20.0, self.frame.size.height)];
    upperIconLabel.font = iconFont;
    upperIconLabel.textColor = color;
    upperIconLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    upperIconLabel.textAlignment = NSTextAlignmentRight;
    upperIconLabel.backgroundColor = [UIColor clearColor];
    upperIconLabel.text = icon;
    
    [self addSubview:upperIconLabel];
}


#pragma mark - touchEvents

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
//    self.alpha = .7;
    self.normalBackgroundView.hidden = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
//    self.alpha = 1.0;
    self.normalBackgroundView.hidden = YES;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.normalBackgroundView.hidden = YES;
//    self.alpha = 1.0;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    self.normalBackgroundView.hidden = YES;
//    self.alpha = 1.0;
}


@end
