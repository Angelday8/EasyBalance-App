//
//  Valor.h
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/3/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conta, Tag;

@interface Valor : NSManagedObject

@property (nonatomic, retain) NSDate * data;
@property (nonatomic, retain) NSString * codigo;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSNumber * receita;
@property (nonatomic, retain) NSNumber * valor;
//@property (nonatomic, retain) NSString * valorString;
@property (nonatomic, retain) Conta *conta;
@property (nonatomic, retain) Tag *tags;

@end
