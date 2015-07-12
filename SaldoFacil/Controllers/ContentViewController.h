//
//  ContentViewController.h
//  SaldoFacil
//
//  Created by Daniel Bonates on 8/26/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@class Valor;
@class Conta;
@class DBViewContainer;

@interface ContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, XYPieChartDelegate, XYPieChartDataSource, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) DBViewContainer *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (void)configurarConta:(Conta *)conta;
- (void)updateList;
- (void)adicionarValor:(NSNumber *)number info:(NSString *)info receita:(NSNumber *)receita eData:(NSDate *)data;
- (void)atualizarValorComCodigo:(NSString *)codigo novoValor:(NSNumber *)novoValor info:(NSString *)info receita:(NSNumber *)receita eData:(NSDate *)data;
- (void)exibirContaAtual;
- (void)anunciarSemConta;
@end
