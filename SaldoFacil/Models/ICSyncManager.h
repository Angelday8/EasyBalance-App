//
//  ICSyncManager.h
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/14/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

@interface ICSyncManager : NSObject

+ (ICSyncManager *)sharedManager;
- (void)checkCloudToken;

@end
