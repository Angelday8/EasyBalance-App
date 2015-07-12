//
//  Conta.h
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/6/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Valor;

@interface Conta : NSManagedObject

@property (nonatomic, retain) NSString * codigo;
@property (nonatomic, retain) NSDate * data;
@property (nonatomic, retain) NSDate * modificada_em;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSSet *valores;
@property (nonatomic, retain) NSString * saldoString;
@property (nonatomic, retain) NSString * senha;
@end

@interface Conta (CoreDataGeneratedAccessors)

- (void)addValoresObject:(Valor *)value;
- (void)removeValoresObject:(Valor *)value;
- (void)addValores:(NSSet *)values;
- (void)removeValores:(NSSet *)values;

@end
