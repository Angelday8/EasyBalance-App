//
//  NSObject+NSObjectTools.h
//  Publicacoes
//
//  Created by Daniel Bonates on 6/15/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObjectTools)

@property (nonatomic, readonly) BOOL currentOrientationIsLandscape;
@property (nonatomic, readonly) BOOL isIpad;
@property (nonatomic, readonly) CGRect fullFrame;

//- (void)postNotification:(NSString *)name object:(NSDictionary *)object;
- (CGRect)frameForCurrentOrientation;
@end
