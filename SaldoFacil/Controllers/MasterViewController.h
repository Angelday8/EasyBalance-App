//
//  MasterViewController.h
//  SaldoFacil
//
//  Created by Daniel Bonates on 8/26/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Conta;
#import "Carteiro.h"
#import <StoreKit/StoreKit.h>

@class DBViewContainer;

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIPrintInteractionControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) DBViewContainer *viewContainer;

- (void)cancelarInsercaoDeConta;
- (void)inserirContaComNome:(NSString *)nome;
- (void)atualizarContaDeCodigo:(NSString *)codigo comNome:(NSString *)nome;
- (void)deletarConta:(Conta *)conta;


@end
