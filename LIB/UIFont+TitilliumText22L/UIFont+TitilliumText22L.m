//
//  UIFont+TitilliumText22L.m
//  FontViewer
//
//  Created by Daniel Bonates on 9/6/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "UIFont+TitilliumText22L.h"

@implementation UIFont (TitilliumText22L)
//NSArray *fontNames = @[@"TitilliumText22L-Thin", @"TitilliumText22L-Ligh", @"TitilliumText22L-Regular", @"TitilliumText22L-Medium", @"TitilliumText22L-Bold", @"TitilliumText22L-XBold"];
+ (UIFont *)titilliumW_T1:(float)fontSize {
    return [UIFont fontWithName:@"TitilliumText22L-Thin" size:fontSize];
}
+ (UIFont *)titilliumW_T250:(float)fontSize {
    return [UIFont fontWithName:@"TitilliumText22L-Light" size:fontSize];
}
+ (UIFont *)titilliumW_T400:(float)fontSize {
    return [UIFont fontWithName:@"TitilliumText22L-Regular" size:fontSize];
}
+ (UIFont *)titilliumW_T600:(float)fontSize {
    return [UIFont fontWithName:@"TitilliumText22L-Medium" size:fontSize];
}
+ (UIFont *)titilliumW_T800:(float)fontSize {
    return [UIFont fontWithName:@"TitilliumText22L-Bold" size:fontSize];
}
+ (UIFont *)titilliumW_T999:(float)fontSize {
    return [UIFont fontWithName:@"TitilliumText22L-XBold" size:fontSize];
}

+ (UIFont *)titilliumW_thin:(float)fontSize {
    return [UIFont fontWithName:@"TitilliumText22L-Thin" size:fontSize];
}
+ (UIFont *)titilliumW_light:(float)fontSize {
    return [UIFont fontWithName:@"TitilliumText22L-Light" size:fontSize];
}
+ (UIFont *)titilliumW_regular:(float)fontSize {
    return [UIFont fontWithName:@"TitilliumText22L-Regular" size:fontSize];
}
+ (UIFont *)titilliumW_medium:(float)fontSize {
    return [UIFont fontWithName:@"TitilliumText22L-Medium" size:fontSize];
}
+ (UIFont *)titilliumW_bold:(float)fontSize {
    return [UIFont fontWithName:@"TitilliumText22L-Bold" size:fontSize];
}
+ (UIFont *)titilliumW_xbold:(float)fontSize {
    return [UIFont fontWithName:@"TitilliumText22L-XBold" size:fontSize];
}

@end
