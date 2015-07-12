//
//  Constantes.h
//  SaldoFacil
//
//  Created by Daniel Bonates on 8/26/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#ifndef SaldoFacil_Constantes_h
#define SaldoFacil_Constantes_h

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


#define TRANSITION_TIME .3
#define LATERAL_MENU_WIDTH_IPHONE 170.0
#define LATERAL_MENU_WIDTH_IPAD 220.0
#define LIST_WIDTH_IPAD 548.0

static inline BOOL isEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}


#endif
