//
//  Tag.h
//  SaldoFacil
//
//  Created by Daniel Bonates on 8/26/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSSet *valor;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addValorObject:(NSManagedObject *)value;
- (void)removeValorObject:(NSManagedObject *)value;
- (void)addValor:(NSSet *)values;
- (void)removeValor:(NSSet *)values;

@end
