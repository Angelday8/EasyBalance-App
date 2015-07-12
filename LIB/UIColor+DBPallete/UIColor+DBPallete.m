//
//  UIColor+DBPallete.m
//  TourBrasil
//
//  Created by Daniel Bonates on 6/19/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "UIColor+DBPallete.h"

@implementation UIColor (DBPallete)

+ (UIColor *)dbVermelho
{
    return [self colorVersionForString:@"227,83,84"];
}
+ (UIColor *)dbVermelhoPlus
{
    return [self colorVersionForString:@"129,59,63"];
}
+ (UIColor *)dbMarinho
{
    return [self colorVersionForString:@"60,68,83"];
}
+ (UIColor *)dbMarinhoPlus
{
    return [self colorVersionForString:@"53,60,73"];
}
+ (UIColor *)dbVerde
{
    return [self colorVersionForString:@"91,200,134"];
}
+ (UIColor *)dbVerdePlus
{
    return [self colorVersionForString:@"109,164,131"];
}
+ (UIColor *)dbAzul
{
    return [self colorVersionForString:@"58,168,238"];
}
+ (UIColor *)dbAzulPlus
{
    return [self colorVersionForString:@"59,118,161"];
}


+ (UIColor *)dbGray
{
    return [self colorVersionForString:@"123,124,134"];
}
+ (UIColor *)dbBranco
{
    return [self colorVersionForString:@"247,247,247"];
}
+ (UIColor *)dbAzulLight
{
    return [self colorVersionForString:@"209,231,245"];
}



+ (UIColor *)colorVersionForString:(NSString *)stringValues
{
    NSArray *valuesArray = [stringValues componentsSeparatedByString:@","];
    float valueForRed = [[valuesArray objectAtIndex:0] floatValue]/255.0;
    float valueForGreen = [[valuesArray objectAtIndex:1] floatValue]/255.0;
    float valueForBlue = [[valuesArray objectAtIndex:2] floatValue]/255.0;
    return [UIColor colorWithRed: valueForRed
            green:valueForGreen
            blue:valueForBlue
            alpha:1.0];
}
@end
