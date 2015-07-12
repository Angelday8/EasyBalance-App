//
//  ContentViewController.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 8/26/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//



#import "ContentViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "NovoValorViewController.h"
#import "Conta.h"
#import "Valor.h"
#import "ValorCell.h"
#import "XYPieChart.h"
#import "NovaContaViewController.h"
#import "MasterViewController.h"
#import "DBViewContainer.h"

#define iPad [self isPad]
#define IPAD_WIDTH 548.0

#define SETA_UP @"\uf077"
#define SETA_DOWN @"\uf078"

#define HEIGHT_FOR_TEXTFIELD 33.0
#define HEIGHT_FOR_SMALL_BUTTON 32.0
#define HEIGHT_FOR_BUTTON 64.0


#define HEIGHT_FOR_IPAD_KEYBOARD 264.0
#define HEIGHT_FOR_IPHONE_KEYBOARD 216.0

#define IS_IPHONE5 (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height==568)

#import "NovaContaCell.h"

@interface ContentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataModifiedLabel;
@property (strong, nonatomic) UITableView *valoresTableView;
@property (strong, nonatomic) NSArray *valoresArray;
@property (nonatomic, strong) Conta *conta;
@property (weak, nonatomic) IBOutlet UILabel *saldoLabel;
@property (weak, nonatomic) IBOutlet XYPieChart *saldoChart;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIButton *deletarContaBtn;
@property (nonatomic, strong) UIButton *editarContaBtn;

// bottomView layout itens

@property (weak, nonatomic) IBOutlet UILabel *receitaTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *despesaTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *receitaTotalValorLabel;
@property (weak, nonatomic) IBOutlet UILabel *despesaTotalValorLabel;
@property (strong, nonatomic) UIButton *openCloseBottomView;

// gesture recognizer

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureDown;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureLeft;

@end

@implementation ContentViewController

float statusBarHeigh;

float porcentagemReceita;
float porcentagemDespesa;

float bottonViewClosedHeight;
float bottonViewOpenedHeight;

CGRect bottomViewFrameClosed;
CGRect bottomViewFrameOpened;

CGRect tableViewFrameSmall;
CGRect tableViewFrameBig;


BOOL bottomViewIsOpened;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - inicialização

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bottomViewIsOpened = NO;
    
    [self configuraViews];
    
    if (![self isPad]) {
        [self setupLeftMenuButton];
    } else {
        [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
    }

    
    [self setupRightMenuButton];
    
    self.title = NSLocalizedString(@"EasyBalance 2", @"");
    
    // configurando o chart
    [self.saldoChart setShowLabel:NO];
    [self.saldoChart setDelegate:self];
    [self.saldoChart setDataSource:self];
    [self.saldoChart setStartPieAngle:M_PI_2];	//optional
    [self.saldoChart setAnimationSpeed:1.0];	//optional
    [self.saldoChart setPieBackgroundColor:[UIColor whiteColor]];	//optional
    [self.saldoChart setPieCenter:CGPointMake(24, 24)];	//optional
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self exibirContaAtual];
}

- (void)configuraViews
{
    bottonViewClosedHeight = 83.0; //self.bottomView.frame.size.height/2;
    bottonViewOpenedHeight = 153.0; //self.bottomView.frame.size.height;
    
    float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect tableFrame = self.view.bounds;
    
    if (iPad) {
        tableFrame.size.width = IPAD_WIDTH;
    }
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        statusBarHeight = 0;
    }
    

    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        tableFrame.size.height -= (navBarHeight+statusBarHeight+bottonViewClosedHeight);
         tableFrame.origin.y = statusBarHeight;
    } else {
        tableFrame.size.height -= (navBarHeight+statusBarHeight+bottonViewClosedHeight);
         tableFrame.origin.y = statusBarHeight+navBarHeight;
    }
    
    
    
    if (iPad) {
        

        
        CGRect bottomViewFrameForced = CGRectMake(20, 853.0, 508, 151);
        self.bottomView.frame = bottomViewFrameForced;
    
        
        
        tableFrame.size.height = self.view.frame.size.height - navBarHeight - statusBarHeight - self.bottomView.frame.size.height-20;
    }
    tableViewFrameBig = tableFrame;
    tableViewFrameSmall = tableViewFrameBig;
    
    if (self.valoresTableView == nil) {
        self.valoresTableView = [[UITableView alloc] initWithFrame:tableViewFrameBig style:UITableViewStylePlain];
    }
    
    [self.view addSubview:self.valoresTableView];
    self.valoresTableView.dataSource = self;
    self.valoresTableView.delegate = self;
    
    self.view.backgroundColor = [UIColor dbBranco];
    self.valoresTableView.backgroundColor = [UIColor dbBranco];
    
    
    
    CGRect bottomViewFrame = self.bottomView.frame;
    bottomViewFrame.origin.y = tableFrame.origin.y + tableFrame.size.height;
    if (!iPad) self.bottomView.frame = bottomViewFrame;
    
    
    bottomViewFrameClosed = bottomViewFrame;
    bottomViewFrameClosed.size.height = bottonViewClosedHeight;
    
    bottomViewFrameOpened = bottomViewFrame;
    bottomViewFrameOpened.size.height = bottonViewOpenedHeight;
    bottomViewFrameOpened.origin.y -= (bottonViewOpenedHeight-bottonViewClosedHeight);
    
    
    tableViewFrameSmall.size.height -= (bottonViewOpenedHeight-bottonViewClosedHeight);

    
    
//    if (iPad) {
//        CGRect iPadBottomViewFrame = CGRectMake(0, 0, IPAD_WIDTH, bottonViewOpenedHeight);
//        self.bottomView.frame = iPadBottomViewFrame;
//    }
    

    [self configureBottomView];
    
    [self.valoresTableView registerClass:[ValorCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.valoresTableView registerClass:[NovaContaCell class] forCellReuseIdentifier:@"NovaContaCell"];

//    self.valoresTableView.hidden = YES;
    
    [self.valoresTableView setSeparatorColor:[UIColor dbAzulLight]];
    
    self.bottomView.backgroundColor = [UIColor dbBranco];
    
//    
//    UITableViewController *tableViewController = [[UITableViewController alloc] init];
//    tableViewController.tableView = self.valoresTableView;
//    
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(updateList) forControlEvents:UIControlEventValueChanged];
//    tableViewController.refreshControl = self.refreshControl;
//    
    if (!iPad) [self configureGestureRecognizers];
    
    
}


- (void)configureGestureRecognizers {
    
    
    self.swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestured:)];
    self.swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    self.swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestured:)];
    self.swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    //    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestured:)];
    
    [self.bottomView addGestureRecognizer:self.swipeGestureUp];
    [self.bottomView addGestureRecognizer:self.swipeGestureDown];
    //    [self.bottomView addGestureRecognizer:self.tapGesture];
    
//    self.swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
//    self.swipeGestureUp.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.valoresTableView addGestureRecognizer:self.swipeGestureLeft];
}


- (void)cellSwiped:(UISwipeGestureRecognizer *)gesture
{
    DDLogInfo(@"swiped!");
}

#pragma mark - bottomView

- (void)configureBottomView
{
    
    UIFont *saldoFont = [UIFont titilliumW_bold:38.0];
    self.saldoLabel.font = saldoFont;
    
    UIFont *labelFont = [UIFont titilliumW_regular:15];
    
    self.receitaTotalLabel.font = labelFont;
    self.receitaTotalLabel.textColor = [UIColor dbAzul];
    self.receitaTotalLabel.text = NSLocalizedString(@"Receipts:", @"");
    
    self.despesaTotalLabel.font = labelFont;
    self.despesaTotalLabel.textColor = [UIColor dbAzul];
    self.despesaTotalLabel.text = NSLocalizedString(@"Expenses:", @"");
    
    UIFont *valorFont = [UIFont titilliumW_regular:17];
    
    self.receitaTotalValorLabel.font = valorFont;
    self.receitaTotalValorLabel.textColor = [UIColor dbGray];
    
    self.despesaTotalValorLabel.font = valorFont;
    self.despesaTotalValorLabel.textColor = [UIColor dbGray];
    
    if (!iPad) {
        self.openCloseBottomView = [UIButton buttonWithLabel:@{@"texto": @"", @"icone": SETA_UP}
                                                        withFrame:CGRectMake((self.bottomView.frame.size.width-21.0)/2, 5, 21.0, 21.0)
                                         // withFrame:CGRectMake(0, 5, self.bottomView.frame.size.width, 21.0)
                                                      bgWithColor:[UIColor clearColor]
                                                   highLightColor:[UIColor clearColor]
                                                       labelColor:[UIColor blackColor]
                                                         alinhado:NO
                                                     iconFontSize:10.0];
        [self.bottomView addSubview:self.openCloseBottomView];
    //    [openCloseBottomView addTarget:self action:@selector(toggleBottomView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    // deletar conta
    self.deletarContaBtn = [UIButton buttonWithLabel:@{@"texto": @"", @"icone": @"\uf014"}
                                           withFrame:iPad? CGRectMake(548-20-37*3.0-20.0, 110, 37.0, 37.0) : CGRectMake(215, 90, 37.0, 37.0)
                                               bgWithColor:[UIColor dbBranco]
                                            highLightColor:[UIColor clearColor]
                                                labelColor:[UIColor dbAzul]
                                                  alinhado:NO
                                              iconFontSize:20.0];
    [self.bottomView addSubview:self.deletarContaBtn];
    [self.deletarContaBtn addTarget:self action:@selector(showAlertDeletarConta:) forControlEvents:UIControlEventTouchUpInside];
    
    // editar conta
    self.editarContaBtn = [UIButton buttonWithLabel:@{@"texto": @"", @"icone": @"\uf044"}
                                                withFrame:iPad? CGRectMake(548-20-37.0-20.0, 112, 37.0, 37.0) : CGRectMake(260, 92, 37.0, 37.0)
                                              bgWithColor:[UIColor dbBranco]
                                           highLightColor:[UIColor clearColor]
                                               labelColor:[UIColor dbAzul]
                                                 alinhado:NO
                                             iconFontSize:20.0];
    
    [self.editarContaBtn addTarget:self action:@selector(showEditarContaForm:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.editarContaBtn];

    
}


- (void)showAlertDeletarConta:(id)send
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete this account?", @"")
                                                    message:NSLocalizedString(@"All data will be removed. Maybe you wanna send it by email or print before doing this, as a backup for future reference.", @"")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                          otherButtonTitles:NSLocalizedString(@"Delete", @""), nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deletarEstaConta];
    }
}

- (void)toggleBottomView:(id)sender
{
    if (iPad) {
        return;
    }
    if (bottomViewIsOpened) {
        
        [UIView animateWithDuration:TRANSITION_TIME/2
                         animations:^{
                             self.bottomView.frame = bottomViewFrameClosed;
                             self.valoresTableView.frame = tableViewFrameBig;
                             
                         } completion:^(BOOL finished) {
                             bottomViewIsOpened = NO;
                             [self.openCloseBottomView setIcon:SETA_UP];
                         }];
    }
    else {
        [UIView animateWithDuration:TRANSITION_TIME/2
                         animations:^{
                             self.bottomView.frame = bottomViewFrameOpened;
                             self.valoresTableView.frame = tableViewFrameSmall;
                             
                         } completion:^(BOOL finished) {
                             bottomViewIsOpened = YES;
                             [self.openCloseBottomView setIcon:SETA_DOWN];
                         }];
    }
}


#pragma mark - navigationController

- (void)setupRightMenuButton
{
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showNewValorForm:)];
    
    self.navigationItem.rightBarButtonItem = addBtn;
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    //if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [leftDrawerButton setMenuButtonColor:[UIColor dbAzul] forState:UIControlStateNormal];
    //}
    
    
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (void)leftDrawerButtonPress:(id)sender
{

    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



# pragma mark - configura a conta atual
 
- (void)configurarConta:(Conta *)conta
{
    
    if(![self.conta isEqual:conta])
    {
    
        self.conta = conta;
    
        [self exibirContaAtual];
    
    
    }
}


- (void)anunciarSemConta
{
//    DDLogInfo(@"anunciarSemConta");
    self.contaNameLabel.text = @"";
    self.dataModifiedLabel.text = @"";
    self.title = NSLocalizedString(@"EasyBalance 2", @"");
    
    self.conta = nil;
    
    [self updateList];
    
    

}
- (void)exibirContaAtual
{
//    self.contaNameLabel.text = self.conta.nome;
    
    NSDateFormatter *dateFormatter;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.dataModifiedLabel.text = [dateFormatter stringFromDate:self.conta.data];
    
    
    [self atualizarContaInfo];
    
    //        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    
    [self updateList];
    //[self fetchValoresArray];
}

#pragma mark - centralizando array de valores

- (void)fetchValoresArray
{
    if (self.valoresArray == nil) {
        self.valoresArray = [[NSArray alloc] init];
    }
    
    self.valoresArray = [Valor MR_findByAttribute:@"conta" withValue:self.conta andOrderBy:@"data" ascending:NO];

}

# pragma mark - calculando os valores
- (void)atualizarSaldo
{
    float saldo = 0;
    float positivos = 0;
    float negativos = 0;
    
    for (Valor *v in self.valoresArray) {
        
        float val = [v.valor floatValue];
        if ([v.receita boolValue]) {
            saldo += val;
            positivos += val;
        } else if (![v.receita boolValue]) {
            saldo -= val;
            negativos += val;
        }
    }
    
    
    UIColor *corDoSaldo;
    
    corDoSaldo = (saldo > 0) ? [UIColor dbVerde] : [UIColor dbVermelho];
    
    
    NSNumber *saldoNumber = [NSNumber numberWithFloat:saldo];
    NSNumber *positivosNumber = [NSNumber numberWithFloat:positivos];
    NSNumber *negativosNumber = [NSNumber numberWithFloat:negativos];
    
    
    
    [UIView animateWithDuration:.15 animations:^{
        
        self.saldoLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        self.saldoLabel.text = [NSString currencyStringFromNumber:saldoNumber];
        
        [UIView animateWithDuration:.15 animations:^{
            self.saldoLabel.textColor =  corDoSaldo;
            self.saldoLabel.alpha = 1.0;
            
        }];
        
        
    }];
    
    
    
    self.conta.saldoString = self.saldoLabel.text;
    
    self.receitaTotalValorLabel.text = [NSString currencyStringFromNumber:positivosNumber];
    self.despesaTotalValorLabel.text = [NSString currencyStringFromNumber:negativosNumber];
    
    [self updatePorcentagemGeralComPositivos:positivos eNegativos:negativos];
    
}

- (void)updatePorcentagemGeralComPositivos:(float)positivos eNegativos:(float)negativos
{
//    DDLogInfo(@"positivos: %f", positivos);
//    DDLogInfo(@"negativos: %f", negativos);
    
    float total = positivos+negativos;
//    DDLogInfo(@"total: %f", total);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    
    porcentagemReceita = (positivos/total)*100;
//    DDLogInfo(@"porcentagemReceita: %ld", lroundf(porcentagemReceita));
    
    porcentagemDespesa = (negativos/total)*100;
//    DDLogInfo(@"porcentagemReceita: %ld", lroundf(porcentagemDespesa));
    
    [self.saldoChart reloadData];
}

#pragma mark contas tableview  data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.conta || self.valoresArray.count < 1) {
        return 1;
    }
    return self.valoresArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.conta) {
        
        static NSString *NovaContaCellIdentifier = @"NovaContaCell";
        
        
        NovaContaCell *novaContaCell = [tableView dequeueReusableCellWithIdentifier:NovaContaCellIdentifier forIndexPath:indexPath];
        
        if (novaContaCell == nil) {
            novaContaCell = [[NovaContaCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NovaContaCellIdentifier];
        }
        
        novaContaCell.selectionStyle = UITableViewCellSelectionStyleNone;
        novaContaCell.infoLabel.text  = NSLocalizedString(@"Add an account", @"");
        
        return novaContaCell;

    }
    
    if (self.valoresArray.count < 1) {
        
        
        static NSString *NovaContaCellIdentifier = @"NovaContaCell";
        
        
        NovaContaCell *novaContaCell = [tableView dequeueReusableCellWithIdentifier:NovaContaCellIdentifier forIndexPath:indexPath];
        
        if (novaContaCell == nil) {
            novaContaCell = [[NovaContaCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NovaContaCellIdentifier];
        }
        
//        novaContaCell.selectionStyle = UITableViewCellSelectionStyleNone;
        novaContaCell.infoLabel.text  = NSLocalizedString(@"Add an entry", @"");
        
        return novaContaCell;
    }
    
    
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
   
    ValorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ValorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Valor *valor = [self.valoresArray objectAtIndex:indexPath.row];
    //    DDLogInfo(@"configurar meu valor: %@", valor.info);
    [cell configurarValor:valor];
    
    return cell;
}

# pragma mark contas tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DDLogInfo(@"valor selecionado: %d", indexPath.row);
    
    
//    if (!self.conta || self.valoresArray.count < 1) return;
    
    if(self.valoresArray.count < 1) {
        [self showNewValorForm:self];
        return;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ValorCell *vc = (ValorCell *)[tableView cellForRowAtIndexPath:indexPath];
   
    [self showEditarValorForm:vc.valor];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !(self.valoresArray.count < 1);
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        DDLogInfo(@"DELETAR: valor selecionado: %d", indexPath.row);
        
        ValorCell *vc = (ValorCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        
        Valor *valor = [Valor MR_findFirstByAttribute:@"codigo" withValue:vc.valor.codigo];
        
        // deleta o objeto
        if (valor) {
            [valor MR_deleteInContext:localContext];
        }
        
        
        [localContext MR_saveToPersistentStoreAndWait];

        [self updateList];
    }
}



#pragma mark - exibe form para input de novo valor

- (void)showNewValorForm:(id)sender
{

    //keyboard size = iPhone: {320, 216}, iPad: {768, 264}
    
    
    float novaContaFormWidth = iPad ? 440 : 320;
    
    
    float fullHeight = [[UIApplication sharedApplication] keyWindow].frame.size.height;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        //        DDLogInfo(@"usando ios 6.1 ou <");
        statusBarHeigh = 0;
        fullHeight -= [[UIApplication sharedApplication] statusBarFrame].size.height;
        
    } else {
        //        DDLogInfo(@"usando ios 7.0 ou >");
        statusBarHeigh =[[UIApplication sharedApplication] statusBarFrame].size.height;

    }
    
    
    float neededHeight = iPad ? (HEIGHT_FOR_SMALL_BUTTON*2)+64.0+(HEIGHT_FOR_TEXTFIELD*2)+(HEIGHT_FOR_TEXTFIELD*3) :
                                [self getFormHeight] ;
    
    float heighForiPhone    = neededHeight;
    float heighForiPad      = neededHeight;
    
    
    float topForiPhone = fullHeight - HEIGHT_FOR_IPHONE_KEYBOARD - neededHeight; // colado com o keyboard
    float topForiPad = (fullHeight - HEIGHT_FOR_IPAD_KEYBOARD - neededHeight)/2; // calculado para ficar no centro entre o topo e o keyboard
    
    float novaContaFormWHeight = iPad ? heighForiPad : heighForiPhone;

    
    NovoValorViewController *vc = [[NovoValorViewController alloc] init];
    vc.view.frame = CGRectMake(0, 0, novaContaFormWidth, novaContaFormWHeight);
    vc.parent = self;

    

    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
    formSheet.cornerRadius = 0;
    formSheet.portraitTopInset = iPad ? topForiPad : topForiPhone;
    formSheet.presentedFormSheetSize = iPad ? CGSizeMake(novaContaFormWidth, novaContaFormWHeight) : CGSizeMake(320, heighForiPhone);
    
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    };
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        
    }];
}



- (void)showEditarValorForm:(Valor *)val
{
    
    float novaContaFormWidth = iPad ? 440 : 320;
    
    
    float fullHeight = [[UIApplication sharedApplication] keyWindow].frame.size.height;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        //        DDLogInfo(@"usando ios 6.1 ou <");
        statusBarHeigh = 0;
        fullHeight -= [[UIApplication sharedApplication] statusBarFrame].size.height;
        
    } else {
        //        DDLogInfo(@"usando ios 7.0 ou >");
        statusBarHeigh =[[UIApplication sharedApplication] statusBarFrame].size.height;
        
    }
    
    
    float neededHeight = iPad ? (HEIGHT_FOR_SMALL_BUTTON*2)+64.0+(HEIGHT_FOR_TEXTFIELD*2)+(HEIGHT_FOR_TEXTFIELD*3) :
    [self getFormHeight] ;
    
    float heighForiPhone    = neededHeight;
    float heighForiPad      = neededHeight;
    
    
    float topForiPhone = fullHeight - HEIGHT_FOR_IPHONE_KEYBOARD - neededHeight; // colado com o keyboard
    float topForiPad = (fullHeight - HEIGHT_FOR_IPAD_KEYBOARD - neededHeight)/2; // calculado para ficar no centro entre o topo e o keyboard
    
    float novaContaFormWHeight = iPad ? heighForiPad : heighForiPhone;
    
    NovoValorViewController *vc = [[NovoValorViewController alloc] init];
    vc.view.frame = CGRectMake(0, 0, novaContaFormWidth, novaContaFormWHeight);
    vc.parent = self;
    vc.valor = val;
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
    formSheet.cornerRadius = 0;
    formSheet.portraitTopInset = iPad ? topForiPad : topForiPhone;
    formSheet.presentedFormSheetSize = iPad ? CGSizeMake(novaContaFormWidth, novaContaFormWHeight) : CGSizeMake(320, heighForiPhone);
    
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    };
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        
    }];
}


- (float)getFormHeight
{
    if (IS_IPHONE5) {
        return (HEIGHT_FOR_SMALL_BUTTON*2)+64.0+(HEIGHT_FOR_TEXTFIELD*2)+(HEIGHT_FOR_TEXTFIELD*3);
    }
    
    return (HEIGHT_FOR_SMALL_BUTTON*2)+64.0+(HEIGHT_FOR_TEXTFIELD*2);
}

// nao enviado: conta, data (atualizar modificada_em), codigo
- (void)atualizarValorComCodigo:(NSString *)codigo novoValor:(NSNumber *)novoValor info:(NSString *)info receita:(NSNumber *)receita eData:(NSDate *)data;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    Valor *valor = [Valor MR_findFirstByAttribute:@"codigo" withValue:codigo];
    if (valor) {
        
        valor.valor = novoValor;
        //    valor.valorString = valorString;
        valor.info = info;
        valor.receita = receita;
        //valor.codigo = [NSDate timeStampForDate:valor.data];
        
        Conta *conta = self.conta;
        
        valor.conta = conta;
        
        // atualizada conta.modificada_em
        valor.conta.modificada_em = data;
        valor.data = data;
        //    DDLogInfo (@"SALVANDO: : %@", valor.info);
        
        [localContext MR_saveToPersistentStoreAndWait];
        
        
        //[self fetchValoresArray];
        [self updateList];

    }
    
}


// nao enviado: conta, data (atualizar modificada_em), codigo
- (void)adicionarValor:(NSNumber *)number  info:(NSString *)info receita:(NSNumber *)receita eData:(NSDate *)data;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    Valor *valor = [Valor MR_createInContext:localContext];
    
    valor.valor = number;
//    valor.valorString = valorString;
    valor.info = info;
    valor.receita = receita;
    valor.data = data;
    valor.codigo = [NSDate timeStampForDate:valor.data];
    
    Conta *conta = self.conta;
    
    valor.conta = conta;
    
    // atualizada conta.modificada_em
    valor.conta.modificada_em = valor.data;
    
    //    DDLogInfo (@"SALVANDO: : %@", valor.info);
    
    [localContext MR_saveToPersistentStoreAndWait];
    
    
    //[self fetchValoresArray];
    [self updateList];
    
}

#pragma mark - exibe form para input de novo valor

- (void)showEditarContaForm:(id)sender
{
    
//    float novaContaFormWidth = [[UIApplication sharedApplication] keyWindow].frame.size.width;
//    float novaContaFormWHeight = [[UIApplication sharedApplication] keyWindow].frame.size.height/2;
    float novaContaFormWidth = iPad ? 640 : [[UIApplication sharedApplication] keyWindow].frame.size.width;
    float novaContaFormWHeight = iPad ? 580 : [[UIApplication sharedApplication] keyWindow].frame.size.height/2;
    
    NovaContaViewController *vc = [[NovaContaViewController alloc] init];
    vc.view.frame = CGRectMake(0, 0, novaContaFormWidth, novaContaFormWHeight);
    
    MasterViewController *nav;
    if (iPad) {
        nav = (MasterViewController *)self.viewContainer.masterViewController;
    } else {
        nav = (MasterViewController *)self.mm_drawerController.leftDrawerViewController;
    }
    
    vc.masterView = nav; //(MasterViewController *)[[nav viewControllers] objectAtIndex:0];
    vc.conta = self.conta;
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
    formSheet.cornerRadius = 0;
    formSheet.portraitTopInset = statusBarHeigh+64.0;
    formSheet.presentedFormSheetSize = CGSizeMake(novaContaFormWidth, novaContaFormWHeight);
    
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    };
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
    
}



- (void)atualizarContaInfo
{
    
    if (!self.conta) {
        self.contaNameLabel.text = @"";
        self.dataModifiedLabel.text = @"";
        self.title = NSLocalizedString(@"EasyBalance 2", @"");
        return;
    }
//    DDLogInfo (@"atualizarContaDefaultEmMaster:");
    self.contaNameLabel.text = self.conta.nome;
    self.title = self.conta.nome;
}

- (void)deletarEstaConta
{
    MasterViewController *master;
    
    if  (iPad) {
        master = (MasterViewController *)self.viewContainer.masterViewController;
    } else {
        master = (MasterViewController *)self.mm_drawerController.leftDrawerViewController;
    }
    
    [master deletarConta:self.conta];
    
}


- (void)updateList
{
    [self fetchValoresArray];
    
    [self.editarContaBtn setVisualEnabled:![self.conta.codigo isEqualToString:@"default"]];
    [self.deletarContaBtn setVisualEnabled:![self.conta.codigo isEqualToString:@"default"]];
//    self.navigationItem.rightBarButtonItem.enabled = !(self.valoresArray.count < 1);

    
    [self.valoresTableView reloadData];
    
    [self atualizarSaldo];
    
    [self atualizarContaInfo];
    
    [self cancelRefreshControl];
}


- (void)cancelRefreshControl
{
    if(self.refreshControl) [self.refreshControl endRefreshing];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return 2;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    // 0 = despesa, 1 = vermelho
    return index == 0 ? lroundf(porcentagemDespesa) : lroundf(porcentagemReceita);
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return index == 0 ? [UIColor dbVermelho] : [UIColor dbVerde];
}


#pragma mark - Gesture delegate

- (void)gestured:(UIGestureRecognizer *)gesture
{
    
    [self toggleBottomView:self];
}

- (BOOL)isPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
