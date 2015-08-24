//
//  MasterViewController.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 8/26/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#define iPad [self isPad]

#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "MasterViewController.h"
#import "Conta.h"
#import "Valor.h"
#import "UIViewController+MMDrawerController.h"
#import "ContaCell.h"
#import "IconCell.h"
#import "NovaContaViewController.h"
#import "ContentViewController.h"
#import "SSKeychain.h"
#import "DBViewContainer.h"
#import "SobreViewController.h"

#define IPAD_ROW_HEIGHT 84.0

#define DEFAULT_ROW_HEIGHT [self isPad] ? IPAD_ROW_HEIGHT : 68.0;
#define FACEBOOK_TEXT NSLocalizedString(@"Wanna know how much you have in hand? Be aware with the app EasyBalance 2 for iPhone ;)", @"")
#define SF_LINK @"https://itunes.apple.com/br/app/easy-balance/id393762832?l=br&mt=8"

static NSString *serviceName = @"com.bonates.saldofacil";
static NSString *serviceKey = @"contas.enabled";


@interface MasterViewController ()

@property (nonatomic, strong) UIButton *opcoesButton;
@property (nonatomic, strong) UIButton *contasButton;
@property (nonatomic, strong) UITableView *contasView;
@property (nonatomic, strong) ContentViewController *valoresView;
@property (nonatomic, strong) NSArray *contasArray;
@property (nonatomic, strong) NSString *contaSelecionadaCodigo;
@property (nonatomic, strong) Carteiro *carteiro;
@property (nonatomic, strong) UIAlertView *inappAlertView;
@end

@implementation MasterViewController


CGRect contasBtnFrameClosed;
CGRect contasBtnFrameOpened;
CGRect contasViewFrameClosed;
CGRect contasViewFrameOpened;

float statusBarHeigh;
float headerButtonHeight;

float currentY;
//NSIndexPath *lastIndexPathSelected;

NSMutableArray *toolsButtons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self iniciar];

}

- (void)iniciar
{
    if(!self.valoresView) {
        
        UINavigationController *nav;
        
        if (iPad)
            {
            nav = (UINavigationController *)self.viewContainer.contentViewController;
            }
        else
            {
            nav = (UINavigationController *)self.mm_drawerController.centerViewController;
            
            }
        self.valoresView = (ContentViewController *)[[nav viewControllers] objectAtIndex:0];
    }
    
    
    
    //    DDLogInfo(@"self.valoresView: %@", self.valoresView);
    [self checkContaDefault];
    
    [self buildDefaultButtons];
    [self buildContasTableView];
    [self fetchContasArray];
    [self updateList];

}

#pragma mark - view states
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [self iniciar];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}



# pragma mark - Preferencias: contaSelecionadaCodigo

- (void)checkContaDefault
{
//    contaSelecionadaCodigo
    NSString *contaDefault = [NSUserDefaults retrieveObjectForKey:@"contaSelecionadaCodigo"];
    if (contaDefault) {
        self.contaSelecionadaCodigo = contaDefault;
    }
    else
    {
        self.contaSelecionadaCodigo = nil;
    }
}

- (void)definirContaDefault:(NSString *)codigo
{
    self.contaSelecionadaCodigo = codigo;
    [NSUserDefaults saveObject:codigo forKey:@"contaSelecionadaCodigo"];
}


#pragma mark - building buttons/subviews

- (void)buildDefaultButtons
{
    
    // fix de compatibilidade: ios 7 em diante a area da uiview não subratrai o frame da statusbar
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        //        DDLogInfo(@"usando ios 6.1 ou <");
        statusBarHeigh = 0;
        currentY = 0;
        
        
        
    } else {
        //        DDLogInfo(@"usando ios 7.0 ou >");
        statusBarHeigh =[[UIApplication sharedApplication] statusBarFrame].size.height;
        currentY = statusBarHeigh;
    }
    
    
    NSArray *buttonLabels = @[
                              @{@"texto": NSLocalizedString(@"Print", @""), @"icone": @"\uf02f"},    // 0
                              @{@"texto": NSLocalizedString(@"Send", @""), @"icone": @"\uf0e0"},      // 1
                              @{@"texto": NSLocalizedString(@"Share", @""), @"icone": @"\uf082"},     // 2
                              @{@"texto": NSLocalizedString(@"About", @""), @"icone": @"\uf129"}];      // 3
    
    headerButtonHeight = (self.view.frame.size.height-statusBarHeigh)/(buttonLabels.count+2);
    
    if ([self isPad]) {
        headerButtonHeight = IPAD_ROW_HEIGHT;
    }
    
    
    // Calcula os frames para o menu aberto/fechado
    contasBtnFrameClosed = CGRectMake(0, self.view.frame.size.height-headerButtonHeight, LATERAL_MENU_WIDTH_IPHONE, headerButtonHeight);
    contasBtnFrameOpened = CGRectMake(0, headerButtonHeight+statusBarHeigh, LATERAL_MENU_WIDTH_IPHONE, headerButtonHeight);
    contasViewFrameClosed = CGRectMake(0, contasBtnFrameClosed.origin.y+headerButtonHeight, LATERAL_MENU_WIDTH_IPHONE, self.view.frame.size.height-((headerButtonHeight*2)+statusBarHeigh));
    contasViewFrameOpened = CGRectMake(0, (headerButtonHeight*2)+statusBarHeigh, LATERAL_MENU_WIDTH_IPHONE, self.view.frame.size.height-((headerButtonHeight*2)+statusBarHeigh));
    
    
    if ([self isPad]) {
        contasBtnFrameClosed = CGRectMake(0, IPAD_ROW_HEIGHT*buttonLabels.count+(IPAD_ROW_HEIGHT*1.5), LATERAL_MENU_WIDTH_IPAD, headerButtonHeight);
//        contasBtnFrameOpened = CGRectMake(0, headerButtonHeight+statusBarHeigh, LATERAL_MENU_WIDTH_IPAD, headerButtonHeight);
        contasViewFrameClosed = CGRectMake(0, contasBtnFrameClosed.origin.y+IPAD_ROW_HEIGHT, LATERAL_MENU_WIDTH_IPAD, self.view.frame.size.height-((contasBtnFrameClosed.origin.y+IPAD_ROW_HEIGHT )));
//        contasViewFrameOpened = CGRectMake(0, (headerButtonHeight*2)+statusBarHeigh, LATERAL_MENU_WIDTH_IPAD, self.view.frame.size.height-((headerButtonHeight*2)+statusBarHeigh));
    }
    
    
    // header button
    
    CGRect headerButtonFrame =CGRectMake(0, currentY, LATERAL_MENU_WIDTH_IPHONE, headerButtonHeight);
    
    
    if ([self isPad]) {
        
        self.view.backgroundColor = [UIColor dbMarinhoPlus];
        
        headerButtonFrame =CGRectMake(0, currentY, LATERAL_MENU_WIDTH_IPAD, IPAD_ROW_HEIGHT);
    }
    
    UIColor *bgColor = [self isPad] ? [UIColor dbMarinhoPlus] : [UIColor dbMarinho];
    UIColor *hlColor = [self isPad] ? [UIColor dbMarinho] : [UIColor dbMarinhoPlus];

    
    self.view.backgroundColor = bgColor;

    
    self.opcoesButton = [UIButton buttonWithLabel:@{@"texto": NSLocalizedString(@"Options", @""), @"icone": @"\uf013"}
                                        withFrame:headerButtonFrame
                                      bgWithColor:bgColor
                                   highLightColor:hlColor
                                       labelColor:[UIColor dbGray]
                                         alinhado:YES
                                     iconFontSize:0];
    [self.opcoesButton setTag:100];
    [self.opcoesButton addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.opcoesButton setEnabled:NO];
    [self.view addSubview:self.opcoesButton];
    
    currentY += headerButtonHeight;
    
    
    // other buttons
    
    float contentCanvasSpace = self.view.frame.size.height-(2*headerButtonHeight)-statusBarHeigh;
    
    float buttonHeight = contentCanvasSpace/buttonLabels.count;
    
    if ([self isPad]) {
        buttonHeight = IPAD_ROW_HEIGHT;
    }
    
    toolsButtons = [NSMutableArray array];
    
    for (int i=0; i<buttonLabels.count; i++) {
        
        
        NSDictionary *buttonInfo = [buttonLabels objectAtIndex:i];
        
        CGRect buttonFrame = CGRectMake(0, currentY, LATERAL_MENU_WIDTH_IPHONE, buttonHeight);
        
        
         if ([self isPad]) {
             buttonFrame = CGRectMake(0, currentY, LATERAL_MENU_WIDTH_IPAD, buttonHeight);
         }
        
        
        
       
        UIButton *btn = [UIButton buttonWithLabel:buttonInfo withFrame:buttonFrame bgWithColor:bgColor highLightColor:hlColor labelColor:[UIColor dbBranco] alinhado:YES
                                     iconFontSize:0];
        
        if (i == 0) { // imprimir
            [btn addTarget:self action:@selector(printContent:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 1) { //email
            [btn addTarget:self action:@selector(enviarEmail:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 2) { // facebook
            [btn addTarget:self action:@selector(shareOnFacebook:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 3) { // sobre
            [btn addTarget:self action:@selector(showAboutApp:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [toolsButtons addObject:btn];
        
        [self.view addSubview:btn];
        
        currentY += buttonHeight;
    }
    
    
    // bottom button
    
    if ([self isPad]) {
        
        
        
        self.contasButton = [UIButton buttonWithLabel:@{@"texto": NSLocalizedString(@"Accounts", @""), @"icone": @"\uf155"}
                                            withFrame:contasBtnFrameClosed
                                          bgWithColor:[UIColor dbMarinho]
                                       highLightColor:[UIColor dbMarinhoPlus]
                                           labelColor:[UIColor dbGray] alinhado:YES
                                         iconFontSize:0];
        
        [self.contasButton setEnabled:NO];
    } else {
        
        
        self.contasButton = [UIButton buttonWithLabel:@{@"texto": NSLocalizedString(@"Accounts", @""), @"icone": @"\uf155"}
                                            withFrame:contasBtnFrameClosed
                                          bgWithColor:[UIColor dbAzul]
                                       highLightColor:[UIColor dbAzulPlus]
                                           labelColor:[UIColor dbBranco] alinhado:YES
                                         iconFontSize:0];
        [self.contasButton addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    
    [self.contasButton setTag:101];
    [self.view addSubview:self.contasButton];
}


#pragma mark - contas tableview

- (void)buildContasTableView
{
    
    self.contasView = [[UITableView alloc] initWithFrame:contasViewFrameClosed style:UITableViewStylePlain];
    
    [self.contasView registerClass:[IconCell class] forCellReuseIdentifier:@"iconCellIdentifier"];
    [self.contasView registerClass:[ContaCell class] forCellReuseIdentifier:@"ContaCellIdentifier"];

    self.contasView.dataSource = self;
    self.contasView.delegate = self;
    self.contasView.backgroundColor = [UIColor dbMarinho];
    self.contasView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contasView.hidden = ![self isPad];
    [self.view addSubview:self.contasView];

}





#pragma mark - centralizando array de contas

- (void)fetchContasArray
{
    // poderia colocar num if só, entretanto ao deletar uma conta o array não é nulo apenas é zerado,
    // então se ele já existe eu não preciso criar um novo.
    if (self.contasArray == nil) {
        self.contasArray = [[NSArray alloc] init];
    }
    
    self.contasArray = [Conta MR_findAllSortedBy:@"data" ascending:NO];
    
    
    if (self.contasArray.count == 0) {
        
        
        DDLogWarn(@"CRIANDO CONTA DEFAULT");
        
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        
        
        Conta *novaConta = [Conta MR_createInContext:localContext];
        novaConta.nome = NSLocalizedString(@"Default account", nil);
        novaConta.data = [NSDate date];
        
        // conta padrão protegida contra exclusão usando codigo = default
        novaConta.codigo = @"default";
        
        [localContext MR_saveOnlySelfAndWait];
        
        [self definirContaDefault:novaConta.codigo];
        
        self.contasArray = [Conta MR_findAllSortedBy:@"data" ascending:NO];
  
    }
    
    
//    if (self.contasArray.count < 1) return;
    
    
    // executado quando existe conta no array mas não há uma conta selecionada
    // nesse caso a selecionada será a primeira
    if (self.contasArray.count > 0 && !self.contaSelecionadaCodigo) {
        self.contaSelecionadaCodigo = [[self.contasArray objectAtIndex:0] codigo];
        [self definirContaDefault:self.contaSelecionadaCodigo];
    }
}



#pragma mark - update table

- (void)updateList
{
    
    [self.contasView reloadData];

    
    if (self.contasArray.count < 1) return;

    if (!self.contaSelecionadaCodigo) {
        NSIndexPath *indexPathZero=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.contasView selectRowAtIndexPath:indexPathZero animated:YES  scrollPosition:UITableViewScrollPositionBottom];
        
        Conta *contaSelecionadaZero = [Conta MR_findFirst];
        [self exibirConta:contaSelecionadaZero];
        return;

    }
    
    int rowIndex=0;
    Conta *c;
    Conta *contaSelecionada;
    for (int i=0; i<self.contasArray.count; i++) {
        
        c = [self.contasArray objectAtIndex:i];
        
        if (c) {
            if ([c.codigo isEqualToString:self.contaSelecionadaCodigo]) {
                rowIndex = i;
                contaSelecionada = c;
            }
        }
    }

    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:rowIndex inSection:0];
    [self.contasView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];

    [self exibirConta:contaSelecionada];
}


#pragma mark - contas tableview  data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
        CellIdentifier = @"ContaCellIdentifier";
        ContaCell *contaCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        Conta *contaObject = [self.contasArray objectAtIndex:indexPath.row];
        
        contaCell.titleLabel.text = contaObject.nome;
        contaCell.dateLabel.text = [NSDate shortStyle:contaObject.data];
        contaCell.selectionStyle = UITableViewCellSelectionStyleNone;
        contaCell.conta = contaObject;
    
//        contaCell.ativa = [self.contaSelecionadaCodigo isEqualToString:contaCell.conta.codigo];
    
        return contaCell;

}


# pragma mark contas tableview delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    DDLogInfo(@"conta selecionada: %d", indexPath.row);
    
    ContaCell *contaCell = (ContaCell *)[tableView cellForRowAtIndexPath:indexPath];
    Conta *conta = contaCell.conta;
    self.contaSelecionadaCodigo = conta.codigo;
//    contaCell.ativa = YES;
    
    
    // definir conta corrente
    [self exibirConta:conta];
    
    // definir conta default
    [self definirContaDefault:self.contaSelecionadaCodigo];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DEFAULT_ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGRect frame = self.view.bounds;
    
     if ([self isPad]) {
         frame.size.width = LATERAL_MENU_WIDTH_IPAD;
     } else {
         frame.size.width = LATERAL_MENU_WIDTH_IPHONE;
     }
    
    
    frame.size.height = DEFAULT_ROW_HEIGHT;
    
    UIView *customFooterView = [[UIView alloc] initWithFrame:frame];
    
    UIButton *btn = [UIButton buttonWithLabel:@{@"texto": @"", @"icone": @"\uf0fe"}
                                    withFrame:frame
                                  bgWithColor: iPad ? [UIColor dbMarinho] : [UIColor dbMarinho]
                               highLightColor: iPad ? [UIColor dbMarinhoPlus] : [UIColor dbMarinhoPlus]
                                   labelColor:[UIColor dbBranco]
                                     alinhado:YES
                                 iconFontSize:0];

    
    // inApp purchase
    
    
//    if (![self contasEnabled]) {
//        [btn addUpperIcon:@"\uf023" withColor:[UIColor colorWithRed:1.0 green:204.0/255 blue:0 alpha:1.0] fontSize:15];
//        [btn addTarget:self action:@selector(showBuyResource:) forControlEvents:UIControlEventTouchUpInside];
//        
//    } else {
        [btn addTarget:self action:@selector(showNovaContaForm:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    
    
    
    [customFooterView addSubview:btn];
    
    return customFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return DEFAULT_ROW_HEIGHT;
}


#pragma mark - Define conta atual
- (void)exibirConta:(Conta *)conta
{
    [self.valoresView configurarConta:conta];
}


# pragma mark -
#pragma mark button tap / enable / disable

- (void)ButtonTapped:(id)sender
{
    UIButton *btn = sender;
    
    if (btn.tag == 100) {
        [self enableButton:self.contasButton];
        [self disableButton:self.opcoesButton];
    }
    else if(btn.tag == 101) {
        [self enableButton:self.opcoesButton];
        [self disableButton:self.contasButton];
    }
}

- (void)enableButton:(UIButton*)btn
{
    [btn configureButtonWithBackgroundColor:[UIColor dbAzul] andLabelColor:[UIColor dbBranco] enabled:YES];
    
    if ([btn isEqual:self.contasButton]) {
        
        
        for (UIButton *b in toolsButtons) {
            [b setEnabled:YES];
        }
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contasButton.frame = contasBtnFrameClosed;
            self.contasView.frame = contasViewFrameClosed;
        } completion:^(BOOL finished) {
            self.contasView.hidden = YES;
        }];

    } else
    {
        
        for (UIButton *b in toolsButtons) {
            [b setEnabled:NO];
        }
    }
    
}
- (void)disableButton:(UIButton *)btn
{
    UIColor *iPadDisabledColor = iPad ? [UIColor dbMarinhoPlus] : [UIColor dbMarinho];
    
    [btn configureButtonWithBackgroundColor:iPadDisabledColor andLabelColor:[UIColor dbGray] enabled:NO];
    
    if ([btn isEqual:self.contasButton]) {

        
        self.contasView.hidden = NO;
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contasButton.frame = contasBtnFrameOpened;
            self.contasView.frame = contasViewFrameOpened;
        } completion: nil];
        

    }
}


#pragma mark - exibe form para input de novo valor

- (void)showNovaContaForm:(id)sender
{

    float novaContaFormWidth = iPad ? 640 : [[UIApplication sharedApplication] keyWindow].frame.size.width;
    float novaContaFormWHeight = iPad ? 580 : [[UIApplication sharedApplication] keyWindow].frame.size.height;
    
    NovaContaViewController *vc = [[NovaContaViewController alloc] init];
    vc.view.frame = CGRectMake(0, 0, novaContaFormWidth, novaContaFormWHeight);
    vc.masterView = self;
    
        
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
    formSheet.cornerRadius = 0;
    formSheet.portraitTopInset = statusBarHeigh+headerButtonHeight;
    formSheet.presentedFormSheetSize = CGSizeMake(novaContaFormWidth, novaContaFormWHeight);

    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    };
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
    
}


#pragma mark - inserir conta


- (void)deletarConta:(Conta *)conta
{
//    DDLogInfo (@"deletarConta: %@", conta);
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    Conta *contaZumbi = [Conta MR_findFirstByAttribute:@"codigo" withValue:conta.codigo];
    [contaZumbi MR_deleteInContext:localContext];
    [localContext MR_saveOnlySelfAndWait];
    
    self.contaSelecionadaCodigo = nil;
    
    [self fetchContasArray];
    [self updateList];
    
    /*
     
     
    Nunca cairia nesse if uma vez que não será permitido deletar a conta padrão
     
    if (self.contasArray.count < 1) {
        [self.valoresView anunciarSemConta];
    } else {
        [self.valoresView exibirContaAtual];
    }
    

     */
}



- (void)atualizarContaDeCodigo:(NSString *)codigo comNome:(NSString *)nome
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    Conta *novaConta = [Conta MR_findFirstByAttribute:@"codigo" withValue:codigo];
    novaConta.nome = nome;
    novaConta.modificada_em = [NSDate date];
    
    [localContext MR_saveOnlySelfAndWait];
    
    [self definirContaDefault:novaConta.codigo];
    
    [self fetchContasArray];
    [self updateList];
    
    
    [self.valoresView exibirContaAtual];
}

- (void)inserirContaComNome:(NSString *)nome
{
    
//    DDLogInfo(@"Inserir conta com nome: %@", nome);
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    Conta *novaConta = [Conta MR_createInContext:localContext];
    novaConta.nome = nome;
    novaConta.data = [NSDate date];
    novaConta.codigo = [NSDate timeStampForDate:novaConta.data];
    
    [localContext MR_saveOnlySelfAndWait];
    
    [self definirContaDefault:novaConta.codigo];
    
    [self fetchContasArray];
    [self updateList];
    
}

- (void)cancelarInsercaoDeConta
{
//    [self.contasView selectRowAtIndexPath:lastIndexPathSelected animated:YES scrollPosition:lastIndexPathSelected.row];
}


#pragma mark - imprimir

-(NSString *)pageString {
	
	Conta *conta = [Conta MR_findFirstByAttribute:@"codigo" withValue:self.contaSelecionadaCodigo];
    
    
//    DDLogInfo(@"Imprimir relatorio da conta: %@", conta);
    
    if (!conta) {
        return nil;
    }
    
    NSMutableString *bodyStr = [[NSMutableString alloc] initWithString:@"<body>"];
	[bodyStr appendFormat:@"<b>%@ App - %@ %@</b>", NSLocalizedString(@"EasyBalance 2", @""),NSLocalizedString(@"Report", @""), [NSDate shortStyle:[NSDate date]]];
	[bodyStr appendFormat:@"<table border=0><td>"];
	[bodyStr appendFormat:@"<tr>"];
	[bodyStr appendFormat:@"<td>"];
	[bodyStr appendFormat:@"</td>"];
	[bodyStr appendFormat:@"</tr>"];
	[bodyStr appendFormat:@"<tr><td>&nbsp</td></tr>"];
	
    NSPredicate *receitasPredicate = [NSPredicate predicateWithFormat:@"conta ==[c] %@ AND receita ==[c] %@", conta, [NSNumber numberWithBool:YES]];
    NSPredicate *despesasPredicate = [NSPredicate predicateWithFormat:@"conta ==[c] %@ AND receita ==[c] %@", conta, [NSNumber numberWithBool:NO]];
    
    
    NSArray *secoes = @[NSLocalizedString(@"Receipts", @""), NSLocalizedString(@"Expenses", @"")];
    
    NSArray *receitasArray = [Valor MR_findAllWithPredicate:receitasPredicate];
    NSArray *despesasArray = [Valor MR_findAllWithPredicate:despesasPredicate];
    
    int total_de_secoes = secoes.count;
    int total_de_rows;
    
	for (int i=0; i<total_de_secoes; i++) {
		
        BOOL isReceita = (i==0);
        
		total_de_rows = isReceita ? receitasArray.count : despesasArray.count;
		
		[bodyStr appendFormat:@"<tr>"];
		[bodyStr appendFormat:@"<td>"];
        
        
		NSString *titSect = isReceita ? NSLocalizedString(@"Receipts", @"") : NSLocalizedString(@"Expenses", @"");
		
		[bodyStr appendFormat:@"[<b>%@</b>]", titSect];
		
		[bodyStr appendFormat:@"<tr>"];
		
		for (int j=0; j<total_de_rows; j++) {
			
			// o registro em questao
			NSString *infoString = isReceita ? [[receitasArray objectAtIndex:j] info] : [[despesasArray objectAtIndex:j] info];
			NSNumber *operando = isReceita ? [[receitasArray objectAtIndex:j] valor] : [[despesasArray objectAtIndex:j] valor];
			
			[bodyStr appendFormat:@"<tr>"];
			
			
			[bodyStr appendFormat:@"<td>"];
			[bodyStr appendFormat:@"%@", infoString];
			[bodyStr appendFormat:@"</td>"];
			
			[bodyStr appendFormat:@"<td>"];
			[bodyStr appendFormat:@"%@", [NSString currencyStringFromNumber:operando]];
			[bodyStr appendFormat:@"</td>"];
			
			[bodyStr appendFormat:@"</tr>"];
			
			
		}
		[bodyStr appendFormat:@"</td>"];
		[bodyStr appendFormat:@"</tr>"];
		
		
	}
	
	[bodyStr appendFormat:@"<tr>"];
	[bodyStr appendFormat:@"<td>"];
	[bodyStr appendFormat:@"<br><b>%@: %@</b>", NSLocalizedString(@"Balance", @""), conta.saldoString];
	[bodyStr appendFormat:@"</td>"];
	[bodyStr appendFormat:@"</tr>"];
	
	[bodyStr appendFormat:@"</td></table>"];
	
	[bodyStr appendFormat:@"</body>"];
    
    return bodyStr;
	
}

- (void)printContent:(id)sender {
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;

    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = [NSString stringWithFormat:NSLocalizedString(@"EasyBalance 2-Report-%@", @""), [NSDate shortStyle:[NSDate date]]];
    pic.printInfo = printInfo;
    
    UIMarkupTextPrintFormatter *htmlFormatter = [[UIMarkupTextPrintFormatter alloc]
                                                 initWithMarkupText:[self pageString]];
    htmlFormatter.startPage = 0;
    htmlFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    pic.printFormatter = htmlFormatter;
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) { // nao completou e houve erro
//            DDLogInfo(@"Printing could not complete because of error: %@", error);
            [self alert:NSLocalizedString(@"Printing", @"") msg:[NSString stringWithFormat:NSLocalizedString(@"It was not possible to print: %@", @""), error]];
        } else if (!completed && !error) { // nao completou mas nao houve erro
//            [self alert:@"Impressão" msg:@"Impressão cancelada."];
//            DDLogInfo(@"Impressão cancelada.");
        }
        else if(completed && !error) { // completou sem erros
            [self alert:NSLocalizedString(@"Printing", @"") msg:NSLocalizedString(@"Printed with success.", @"")];
        }
    };
    if (iPad) {
        UIButton *btn = (UIButton *)sender;
        [pic presentFromRect:btn.frame inView:self.view animated:YES completionHandler:completionHandler];
    }
    else {
        [pic presentAnimated:YES completionHandler:completionHandler];
    }
    
    
    
}


- (UIViewController *)printInteractionControllerParentViewController:   (UIPrintInteractionController *)printInteractionController
{
    return self.navigationController;
}
- (void)printInteractionControllerDidPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
    self.navigationController.topViewController.view.backgroundColor = [UIColor whiteColor];
}
#pragma mark - enviar email

- (void)enviarEmail:(id)sender
{
    
    Conta *conta = [Conta MR_findFirstByAttribute:@"codigo" withValue:self.contaSelecionadaCodigo];
    
    
//    DDLogInfo(@"Enviar email para a conta: %@", conta);
    
    if (!conta) {
        return;
    }
    
    self.carteiro = [[Carteiro alloc] initWithConta:conta eSaldoString:conta.saldoString];
    self.carteiro.delegate = (id)self;
    [self.carteiro showPicker];
}

-(void) showComposer:(MFMailComposeViewController *)picker {
	self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentViewController:picker animated:YES completion:nil];
}

-(void) emailSent:(MFMailComposeResult)result {
	
	switch (result)
	{
		case MFMailComposeResultCancelled:
//            DDLogInfo(@"Envio cancelado");
        //[self alert:@"Envio de email" msg:@"Envio cancelado."];
            break;
		case MFMailComposeResultSaved:
//            DDLogInfo(@"Mensagem salva");
            [self alert:NSLocalizedString(@"Sending email", @"") msg:NSLocalizedString(@"Draft saved.", @"")];
            break;
		case MFMailComposeResultSent:
//            DDLogInfo(@"Mensagem enviada.");
            [self alert:NSLocalizedString(@"Sending email", @"") msg:NSLocalizedString(@"Message sent.", @"")];
            break;
        case MFMailComposeResultFailed:
//            DDLogInfo(@"Erro ao enviar mensagem");
            [self alert:NSLocalizedString(@"Sending email", @"") msg:NSLocalizedString(@"Error sending message.", @"")];
            break;
		default:
            [self alert:NSLocalizedString(@"Sending email", @"") msg:NSLocalizedString(@"Message not sent.", @"")];
//            DDLogInfo(@"Mensagem não enviada");
            break;
	}
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - default alert

- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}



# pragma mark - share

- (void)shareOnFacebook:(id)sender
{
    ACAccountStore *accountsStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookAccountType = [accountsStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    id options = @{
                   ACFacebookAppIdKey: @"451992361580548",
                   ACFacebookPermissionsKey: @[ @"email", @"read_friendlists"],
                   ACFacebookAudienceKey: ACFacebookAudienceFriends
                   };
    
    [accountsStore requestAccessToAccountsWithType:facebookAccountType
                                           options:options
                                        completion:^(BOOL granted, NSError *error) {
                                            if (granted) {
//                                                NSLog(@"Acesseo liberado!");
                                                
                                            } else {
//                                                NSLog(@"Permissão negada :( %@", error);
                                            }
                                        }];
    
    SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [facebookSheet setInitialText:FACEBOOK_TEXT];
    
    [facebookSheet addURL:[NSURL URLWithString:SF_LINK]];
    
    // Imagem para o facebook
    UIImage *shot = [UIImage imageNamed:@"share_picture_v2_small.jpg"];
    
    [facebookSheet addImage:shot];
    
    
    [facebookSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        
        switch (result) {
            case SLComposeViewControllerResultCancelled:
//                DDLogInfo(@"Postagem efetuada!");
                break;
            case SLComposeViewControllerResultDone:
//                DDLogInfo(@"Postagem efetuada!");
                [self alert:@"Facebook" msg:NSLocalizedString(@"Thanks for sharing EasyBalance 2 tip with your friends!", @"")];
                break;
                
            default:
                break;
        }
    }];
    
    [self presentViewController:facebookSheet
                       animated:YES
                     completion:nil];
}



#pragma mark - about view

- (void)showAboutApp:(id)sender
{
    
    float sobreViewControllerWidth = iPad ? 640 : [[UIApplication sharedApplication] keyWindow].frame.size.width;
    float sobreViewControllerHeight = iPad ? 640 : [[UIApplication sharedApplication] keyWindow].frame.size.height;
    
    
    SobreViewController *vc = [[SobreViewController alloc] init];
    vc.view.frame = CGRectMake(0, 0, sobreViewControllerWidth, sobreViewControllerHeight);
    
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
    formSheet.cornerRadius = 0;
    formSheet.portraitTopInset = iPad ? ([[UIApplication sharedApplication] keyWindow].frame.size.height-640.0)/2: 0;
    formSheet.presentedFormSheetSize = CGSizeMake(sobreViewControllerWidth, sobreViewControllerHeight);
    
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    };
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
}

#pragma mark - In App Purchase procedures


- (BOOL)contasEnabled
{
    NSString *contasEnabledString = [SSKeychain passwordForService:serviceName account:serviceKey];
    
    if (!contasEnabledString) {
        return NO;
    }

    return YES;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DDLogWarn(@"MEMORY WARNING!");
}


- (BOOL)isPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}


@end
