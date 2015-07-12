//
//  NovoValorViewController.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 8/28/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "NovoValorViewController.h"
#import "Valor.h"
#import "Formatter.h"


#define buttonHeight 64.0
#define labelFontSize 28.0
#define MARGEM 30.0

#define HEIGHT_FOR_TEXTFIELD 33.0
#define HEIGHT_FOR_SMALL_BUTTON 32.0
#define HEIGHT_FOR_BUTTON 64.0


#define HEIGHT_FOR_IPAD_KEYBOARD 264.0
#define HEIGHT_FOR_IPHONE_KEYBOARD 216.0

#define IS_IPHONE5 (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height==568)

#define iPad [self isPad]

@interface NovoValorViewController ()
@property (strong, nonatomic) UITextField *infoInput;
@property (strong, nonatomic) UITextField *valorInput;
@property (strong, nonatomic) UISegmentedControl *inputMode;
@property (nonatomic, strong) UIButton *confirmarButton;
@property (nonatomic, strong) UIButton *cancelarButton;
@property (nonatomic, strong) UIButton *despesaButton;
@property (nonatomic, strong) UIButton *receitaButton;
@property (nonatomic, strong) UIButton *dataButton;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong) NSDate *novaData;
@end

@implementation NovoValorViewController


BOOL receita;
BOOL loaded;


- (BOOL)isPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}


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



- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (loaded) {
        return;
    }
    
    loaded = YES;
    return;
    
    float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        statusBarHeight = 0;
    }
    
    NSDictionary* info = [aNotification userInfo];
    
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect selfFrame = self.view.frame;
    
//    DDLogInfo(@"KeyboardSize: %@", NSStringFromCGRect(kbFrame));
    
    // Keyboard sizes
    
    // iPhone
    // 3.5 iOS 7    = {{0, 480}, {320, 216}}
    // 3.5 iOS 6.1  = {{0, 480}, {320, 216}}
    // 4 iOS 7      = {{0, 568}, {320, 216}}
    // 4 iOS 6.1    = {{0, 568}, {320, 216}}
    
    // iPad
    // NR iOS 7     = {{0, 1024}, {768, 264}}
    // NR iOS 6.1   = {{0, 1024}, {768, 264}}
    // R iOS 7      = {{0, 1024}, {768, 264}}
    // R iOS 6.1    = {{0, 1024}, {768, 264}}
    
    // ou seja, size = iPhone: {320, 216}, iPad: {768, 264}
    
    
    float masterHeight = [[UIApplication sharedApplication] keyWindow].frame.size.height;
    float heightQueSobra = masterHeight - kbFrame.size.height - statusBarHeight -selfFrame.origin.y;
    
    if (!iPad) { selfFrame.size.height = heightQueSobra; }
    
    
    // final frame
    CGRect confirmarBtnFrame = CGRectMake(buttonHeight, selfFrame.size.height-buttonHeight, self.view.frame.size.width-buttonHeight, buttonHeight);
    CGRect cancelarBtnFrame = CGRectMake(0, selfFrame.size.height-buttonHeight, buttonHeight, buttonHeight);
    
    // offscreen
    self.cancelarButton.frame = CGRectMake(-buttonHeight, selfFrame.size.height-buttonHeight, buttonHeight, buttonHeight);
    self.confirmarButton.frame = CGRectMake(selfFrame.size.width, selfFrame.size.height-buttonHeight, self.view.frame.size.width-buttonHeight, buttonHeight);
    
    CGRect valorFrame = CGRectMake(MARGEM, (self.view.frame.size.height - (buttonHeight/2) - buttonHeight)/2-17.0, self.view.frame.size.width-(MARGEM*2), 34.0);
    
    /*
    CGRect valorFrame = selfFrame;
    valorFrame.size.height = 34.0; //system default
    valorFrame.origin.y = (selfFrame.size.height - buttonHeight - 68.0)/2+(buttonHeight/2);
    valorFrame.origin.x += MARGEM;
    valorFrame.size.width -= (MARGEM*2);
    */
    
    CGRect infoFrame = valorFrame;
    infoFrame.origin.y += 34.0;
    
    self.cancelarButton.hidden = NO;
    self.confirmarButton.hidden = NO;
    
    self.valorInput.hidden = NO;
    self.infoInput.hidden = NO;
    
    [UIView animateWithDuration:TRANSITION_TIME/2
                     animations:^{
                         self.view.frame = selfFrame;
                         self.confirmarButton.frame = confirmarBtnFrame;
                         self.cancelarButton.frame = cancelarBtnFrame;
                         self.valorInput.frame = valorFrame;
                         self.infoInput.frame = infoFrame;
                     }];
    
    CGRect full = self.view.frame;
    full.size.height += kbFrame.size.height;
    self.view.frame = full;
}

- (void)setupFormatter
{
    if (self.formatter == nil) {
        
            self.formatter = [[NSNumberFormatter alloc] init];
            [self.formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [self.formatter setGeneratesDecimalNumbers:YES];
            NSString *localCurrencySymbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
            
            [self.formatter setCurrencySymbol:[localCurrencySymbol stringByAppendingString:@" "]];
            [self.formatter setLenient:YES];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupFormatter];
    
    receita = NO;
    loaded = NO;
    
    [self registerForKeyboardNotifications];
    
    self.view.backgroundColor = [UIColor dbBranco];

    

}

- (void)buildControls
{
    // confirmar
    CGRect confirmarBtnFrame = CGRectMake(buttonHeight, self.view.frame.size.height-buttonHeight, self.view.frame.size.width-buttonHeight, buttonHeight);
    
//    DDLogInfo(@"self.view.frame.size.height: %f", self.view.frame.size.height);
    
    self.confirmarButton = [UIButton buttonWithLabel:@{@"texto": NSLocalizedString(@"Confirm", @""), @"icone": @"\uf00c"}
                                           withFrame:confirmarBtnFrame
                                         bgWithColor:[UIColor dbVerde]
                                      highLightColor:[UIColor dbVerdePlus]
                                          labelColor:[UIColor dbBranco]
                                            alinhado:NO
                                        iconFontSize:0];
    self.confirmarButton.hidden = NO;
    
    
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
    self.cancelarButton.hidden = NO;
    [self.cancelarButton addTarget:self action:@selector(closeMe:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelarButton];
    
    
    // despesa
    CGRect despesaBtnFrame = CGRectMake(0, 0, self.view.frame.size.width/2, buttonHeight/2);
    
    self.despesaButton = [UIButton buttonWithLabel:@{@"texto": NSLocalizedString(@"Expense", @""), @"icone": @""}
                                         withFrame:despesaBtnFrame
                                       bgWithColor:[UIColor dbMarinho]
                                    highLightColor:[UIColor dbBranco]
                                        labelColor:[UIColor dbBranco]
                                          alinhado:NO
                                      iconFontSize:0];
    self.despesaButton.hidden = NO;
    [self.despesaButton addTarget:self action:@selector(definirDespesa:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.despesaButton];
    
    
    // despesa
    CGRect receitaBtnFrame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, buttonHeight/2);
    
    self.receitaButton = [UIButton buttonWithLabel:@{@"texto": NSLocalizedString(@"Receipt", @""), @"icone": @""}
                                         withFrame:receitaBtnFrame
                                       bgWithColor:[UIColor whiteColor]
                                    highLightColor:[UIColor dbBranco]
                                        labelColor:[UIColor dbGray]
                                          alinhado:NO
                                      iconFontSize:0];
    self.receitaButton.hidden = NO;
    [self.receitaButton addTarget:self action:@selector(definirReceita:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.receitaButton];
    
    
    
    
    // valor field
    
//    float textHeightSpace = self.view.frame.size.height - HEIGHT_FOR_SMALL_BUTTON*2 - HEIGHT_FOR_BUTTON;
//    DDLogInfo(@"textHeightSpace: %f", textHeightSpace);
    
    CGRect textFieldFrame = self.view.frame;
    textFieldFrame.origin.x += MARGEM;
    textFieldFrame.size.width -= (MARGEM*2);
    UIFont *labelFont = [UIFont titilliumW_T999:labelFontSize];
    
    CGRect valorFieldFrame;
    if (iPad || IS_IPHONE5) {
        valorFieldFrame = CGRectMake(MARGEM, HEIGHT_FOR_TEXTFIELD*3+(HEIGHT_FOR_TEXTFIELD/2), self.view.frame.size.width-(2*MARGEM), HEIGHT_FOR_TEXTFIELD);
    } else {
        valorFieldFrame = CGRectMake(MARGEM, HEIGHT_FOR_TEXTFIELD*2, self.view.frame.size.width-(2*MARGEM), HEIGHT_FOR_TEXTFIELD);
    }
    
    
    self.valorInput = [[UITextField alloc] initWithFrame:valorFieldFrame];
    self.valorInput.font = labelFont;
    self.valorInput.textColor = [UIColor dbAzul];
    self.valorInput.textAlignment = NSTextAlignmentRight;
    self.valorInput.borderStyle = UITextBorderStyleNone;
    NSDecimalNumber *amount = (NSDecimalNumber*) [self.formatter numberFromString:@"0"];
    self.valorInput.placeholder = [self.formatter stringFromNumber:amount];;
    self.valorInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.valorInput.keyboardType = UIKeyboardTypeDecimalPad;
    self.valorInput.tag = 1;
    self.valorInput.delegate = self;
    [self.view addSubview:self.valorInput];
    
    
    // info
    
    CGRect infoFieldFrame;
    if (iPad || IS_IPHONE5) {
        infoFieldFrame = CGRectMake(MARGEM, HEIGHT_FOR_TEXTFIELD*5-(HEIGHT_FOR_TEXTFIELD/2), self.view.frame.size.width-(2*MARGEM), HEIGHT_FOR_TEXTFIELD);
    } else {
        infoFieldFrame = CGRectMake(MARGEM, HEIGHT_FOR_TEXTFIELD*3, self.view.frame.size.width-(2*MARGEM), HEIGHT_FOR_TEXTFIELD);
    }
    self.infoInput = [[UITextField alloc] initWithFrame:infoFieldFrame];
    self.infoInput.font = labelFont;
    self.infoInput.textColor = [UIColor dbAzul];
    self.infoInput.textAlignment = NSTextAlignmentRight;
    self.infoInput.borderStyle = UITextBorderStyleNone;
    self.infoInput.placeholder = NSLocalizedString(@"label", @"");
    self.infoInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.infoInput];

    
    
    // data
    
    self.novaData = [NSDate date];
    CGRect dataBtnFrame = despesaBtnFrame;
    dataBtnFrame.origin.y += dataBtnFrame.size.height;
    dataBtnFrame.size.width *= 2;
    
    self.dataButton = [UIButton buttonWithLabel:@{@"texto": [NSDate shortStyle:self.novaData], @"icone": @""}
                                           withFrame:dataBtnFrame
                                         bgWithColor:[UIColor dbBranco]
                                      highLightColor:[UIColor whiteColor]
                                          labelColor:[UIColor dbGray]
                                            alinhado:NO
                                        iconFontSize:0];
    
    [self.dataButton addTarget:self action:@selector(definirData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dataButton];
    
    
    
}

- (void)definirData:(id)sender
{
    if (!iPad) {
        [self.valorInput endEditing:YES];
        [self.infoInput endEditing:YES];
    }
    
    
    if(!self.datePicker)
    {
        self.datePicker = [[UIDatePicker alloc] init];
        [self.datePicker addTarget:self
                          action:@selector(datePickerDateChanged:)
                forControlEvents:UIControlEventValueChanged];
    
        self.datePicker.date = self.valor? self.valor.data : self.novaData;
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;

    }
    
    else
    {
        return;
    }
    
    self.datePicker.backgroundColor = [UIColor dbBranco];
//    //find the date picker size
    CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
//
//    CGRect screenRect = [self.view frame];
//    
//    //set the picker frame
    CGRect pickerRect = CGRectMake((self.view.frame.size.width-pickerSize.width)/2,
                                   self.cancelarButton.frame.origin.y + self.cancelarButton.frame.size.height,
                                   pickerSize.width,
                                   pickerSize.height);
    self.datePicker.frame = pickerRect;
    
    CGRect selfFrame = self.view.frame;
    selfFrame.size.height += HEIGHT_FOR_IPHONE_KEYBOARD;
    if (iPad) {
        selfFrame.origin.y -= (HEIGHT_FOR_IPHONE_KEYBOARD/2);
        selfFrame.size.width = self.view.frame.size.width;
    }
    [self.view addSubview:self.datePicker];
    [UIView animateWithDuration:TRANSITION_TIME
                     animations:^{
                         self.view.frame = selfFrame;
                     } completion:^(BOOL finished) {
                         
                     }];


    
    }

- (void)datePickerDateChanged:(UIDatePicker *)paramDatePicker
{
//    NSLog(@"Selected date = %@", paramDatePicker.date);
    [self.dataButton setTitle:[NSDate shortStyle:paramDatePicker.date]];
    self.valor.data = paramDatePicker.date;
    self.novaData = paramDatePicker.date;
}

- (void)viewWillAppear:(BOOL)animated
{
//    DDLogInfo(@"self.valor: %@", self.valor);
    
    
    [self buildControls];
    
    if (self.valor == nil) { // adicionando valor
        [self.confirmarButton addTarget:self action:@selector(adicionarValor:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.confirmarButton addTarget:self action:@selector(atualizarValor:) forControlEvents:UIControlEventTouchUpInside];
        [self configurarValorParaEdicao];
    }
    
    if (!self.valor) {
        
        NSDecimalNumber *amount = (NSDecimalNumber*) [self.formatter numberFromString:@"0"];
        self.valorInput.text = [self.formatter stringFromNumber:amount];


    }
    
    
    [self.valorInput becomeFirstResponder];
}

- (void)configurarValorParaEdicao
{
    [self.valor.receita boolValue] ? [self definirReceita:self] : [self definirDespesa:self];
    
    self.valorInput.text = [self.formatter stringFromNumber:self.valor.valor];
    
    self.infoInput.text = self.valor.info;
    
    [self.dataButton setTitle:[NSDate shortStyle:self.valor.data]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)definirReceita:(id)sender
{
    receita = YES;
    [self enableButton:self.despesaButton];
    [self disableButton:self.receitaButton];
}

- (void)definirDespesa:(id)sender
{
    receita = NO;
    [self enableButton:self.receitaButton];
    [self disableButton:self.despesaButton];
}

- (void)adicionarValor:(id)sender {


    
    if ([[self.formatter numberFromString:self.valorInput.text] floatValue] <= 0 ) {

        [self closeMe:self];
        return;
    }
    
    [self.parent adicionarValor:[self.formatter numberFromString:self.valorInput.text]
                           info:self.infoInput.text.length > 1 ? self.infoInput.text : NSLocalizedString(@"New entry", @"")
                        receita:[NSNumber numberWithBool:receita]
                         eData:self.novaData];
    
    [self closeMe:self];
    

}

- (void)atualizarValor:(id)sender {
    
    if ([[self.formatter numberFromString:self.valorInput.text] floatValue] <= 0 ) {

        [self closeMe:self];
        return;
    }
    
    
    [self.parent atualizarValorComCodigo:self.valor.codigo
                               novoValor:[self.formatter numberFromString:self.valorInput.text]
                                    info:self.infoInput.text.length > 1 ? self.infoInput.text : NSLocalizedString(@"New entry", @"")
                                 receita:[NSNumber numberWithBool:receita]
                                   eData:self.valor.data];
    
    [self closeMe:self];
}


- (void)closeMe:(id)sender {
    
    [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        [self.parent updateList];
    }];
}


- (void)enableButton:(UIButton*)btn
{
    [btn configureButtonWithBackgroundColor:[UIColor whiteColor] andLabelColor:[UIColor dbGray] enabled:YES];
    
}
- (void)disableButton:(UIButton *)btn
{
    [btn configureButtonWithBackgroundColor:[UIColor dbMarinho] andLabelColor:[UIColor dbBranco] enabled:NO];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
         NSString *replaced = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSDecimalNumber *amount = (NSDecimalNumber*) [self.formatter numberFromString:replaced];
        if (amount == nil)
            {
            // Something screwed up the parsing. Probably an alpha character.
            return NO;
            }
        // If the field is empty (the inital case) the number should be shifted to
        // start in the right most decimal place.
        short powerOf10 = 0;
        if ([textField.text isEqualToString:@""])
            {
            powerOf10 = -self.formatter.maximumFractionDigits;
            }
        // If the edit point is to the right of the decimal point we need to do
        // some shifting.
        else if (range.location + self.formatter.maximumFractionDigits >= textField.text.length)
            {
            // If there's a range of text selected, it'll delete part of the number
            // so shift it back to the right.
            if (range.length) {
                powerOf10 = -range.length;
            }
            // Otherwise they're adding this many characters so shift left.
            else {
                powerOf10 = [string length];
            }
            }
        amount = [amount decimalNumberByMultiplyingByPowerOf10:powerOf10];
        
        // Replace the value and then cancel this change.
        textField.text = [self.formatter stringFromNumber:amount];
        return NO;

}

 
 
 @end
