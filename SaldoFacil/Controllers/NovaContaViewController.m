//
//  NovaContaViewController.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/2/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "NovaContaViewController.h"
#import "Conta.h"

#define buttonHeight 64.0
#define labelFontSize 28.0

@interface NovaContaViewController ()
@property (nonatomic, strong) UITextField *nomeInput;
@property (nonatomic, strong) UIButton *confirmarButton;
@property (nonatomic, strong) UIButton *cancelarButton;


#define iPad [self isPad]


- (void)cancelar:(id)sender;
@end

@implementation NovaContaViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
}

- (BOOL)isPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
//    if (iPad) return;
    
    float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        statusBarHeight = 0;
    }
    
    NSDictionary* info = [aNotification userInfo];
    
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect selfFrame = self.view.frame;
    
    float masterHeight = [[UIApplication sharedApplication] keyWindow].frame.size.height;
    float heightQueSobra = masterHeight - kbFrame.size.height - statusBarHeight -selfFrame.origin.y;
    
    if (!iPad) { selfFrame.size.height = heightQueSobra; }
    
    
    // final frame
    CGRect confirmarBtnFrame = CGRectMake(buttonHeight, selfFrame.size.height-buttonHeight, self.view.frame.size.width-buttonHeight, buttonHeight);
    CGRect cancelarBtnFrame = CGRectMake(0, selfFrame.size.height-buttonHeight, buttonHeight, buttonHeight);
    
    // offscreen
    self.cancelarButton.frame = CGRectMake(-buttonHeight, selfFrame.size.height-buttonHeight, buttonHeight, buttonHeight);
    self.confirmarButton.frame = CGRectMake(selfFrame.size.width, selfFrame.size.height-buttonHeight, self.view.frame.size.width-buttonHeight, buttonHeight);

    
    CGRect textFieldFrame = selfFrame;
    
    textFieldFrame.size.height = 34.0; //system default
    textFieldFrame.origin.y = (selfFrame.size.height - buttonHeight - 34.0)/2;
    
    if (iPad) {
        textFieldFrame = self.nomeInput.frame;
    }
    
    self.cancelarButton.hidden = NO;
    self.confirmarButton.hidden = NO;
    
    [UIView animateWithDuration:TRANSITION_TIME/2
                     animations:^{
                         self.view.frame = selfFrame;
                         self.confirmarButton.frame = confirmarBtnFrame;
                         self.cancelarButton.frame = cancelarBtnFrame;
                         self.nomeInput.frame = textFieldFrame;
                     }];
    
    
    
}


- (void)addControls
{
    // confirmar
    CGRect confirmarBtnFrame = CGRectMake(buttonHeight, self.view.frame.size.height-buttonHeight, self.view.frame.size.width-buttonHeight, buttonHeight);
    
    self.confirmarButton = [UIButton buttonWithLabel:@{@"texto": NSLocalizedString(@"Confirm", @""), @"icone": @"\uf00c"}
                                           withFrame:confirmarBtnFrame
                                         bgWithColor:[UIColor dbVerde]
                                      highLightColor:[UIColor dbVerdePlus]
                                          labelColor:[UIColor dbBranco]
                                            alinhado:NO
                                        iconFontSize:0];
    self.confirmarButton.hidden = YES;
    [self.view addSubview:self.confirmarButton];
    
    // cancelar
    CGRect cancelarBtnFrame = CGRectMake(0, self.view.frame.size.height-buttonHeight, buttonHeight, buttonHeight);
    
    self.cancelarButton = [UIButton buttonWithLabel:@{@"texto": @"", @"icone": @"\uf057"}
                                          withFrame:cancelarBtnFrame
                                        bgWithColor:[UIColor dbVermelho]
                                     highLightColor:[UIColor dbVermelhoPlus]
                                         labelColor:[UIColor dbBranco]
                                           alinhado:NO
                                       iconFontSize:0];
    self.cancelarButton.hidden = YES;
    [self.cancelarButton addTarget:self action:@selector(cancelar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelarButton];
    
    // input field
    CGRect textFieldFrame = self.view.frame;
    textFieldFrame.origin.x += 40;
    textFieldFrame.size.width -= 80;
    UIFont *labelFont = [UIFont titilliumW_T999:labelFontSize];
    
    self.nomeInput = [[UITextField alloc] initWithFrame:textFieldFrame];
    self.nomeInput.font = labelFont;
    self.nomeInput.textColor = [UIColor dbAzul];
    self.nomeInput.textAlignment = NSTextAlignmentCenter;
    self.nomeInput.borderStyle = UITextBorderStyleNone;
    self.nomeInput.placeholder = NSLocalizedString(@"account name", @"");
    self.nomeInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.nomeInput];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self registerForKeyboardNotifications];
    
    self.view.backgroundColor = [UIColor dbBranco];
	
}

 - (void)viewWillAppear:(BOOL)animated
{
    [self addControls];
    
    
    CGRect confirmarBtnFrame = CGRectMake(buttonHeight, self.view.frame.size.height-buttonHeight, self.view.frame.size.width-buttonHeight, buttonHeight);
    CGRect cancelarBtnFrame = CGRectMake(0, self.view.frame.size.height-buttonHeight, buttonHeight, buttonHeight);
    CGRect textFieldFrame = CGRectMake(0, (self.view.frame.size.height-buttonHeight-33)/2, self.view.frame.size.width, buttonHeight);
    self.nomeInput.frame = textFieldFrame;
    [UIView animateWithDuration:TRANSITION_TIME animations:^{
        self.confirmarButton.frame = confirmarBtnFrame;
        self.cancelarButton.frame = cancelarBtnFrame;
    }];
    
    if (self.conta == nil) { // adicionando conta
        [self.confirmarButton addTarget:self action:@selector(confirmarAdicao:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self configurarContaParaEdicao];
        [self.confirmarButton addTarget:self action:@selector(confirmarEdicao:) forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)configurarContaParaEdicao
{
    self.nomeInput.text = self.conta.nome;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.nomeInput becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmarEdicao:(id)sender {
    [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        if (![self.nomeInput.text isBlank]) {
            [self.masterView atualizarContaDeCodigo:self.conta.codigo comNome:self.nomeInput.text];
        }
        else
            {
            [self.masterView cancelarInsercaoDeConta];
            }
        
    }];
}

- (void)confirmarAdicao:(id)sender {
    [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
        if (![self.nomeInput.text isBlank]) {
            [self.masterView inserirContaComNome:self.nomeInput.text];
        }
        else
        {
            [self.masterView cancelarInsercaoDeConta];
        }
        
    }];
}
- (void)cancelar:(id)sender {
    [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        [self.masterView cancelarInsercaoDeConta];
    }];
}
@end
