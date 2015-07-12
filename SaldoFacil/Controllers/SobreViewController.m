//
//  SobreViewController.m
//  SaldoFacil
//
//  Created by Daniel Bonates on 9/13/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#import "SobreViewController.h"

#define DEFAULT_CONTROL_HEIGHT 64.0

@interface SobreViewController ()

@end

@implementation SobreViewController

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
	
}


- (void) viewWillAppear:(BOOL)animated
{
    [self setupView];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor dbMarinho];
    
    [self addItens];
}

- (void)addItens
{
    CGRect frame = self.view.bounds;
    frame.origin.y = frame.size.height-DEFAULT_CONTROL_HEIGHT;
    frame.size.height = DEFAULT_CONTROL_HEIGHT;
    UIButton *okBtn = [UIButton buttonWithLabel:@{@"texto": @"ok"}
                                      withFrame:frame
                                    bgWithColor:[UIColor dbAzul]
                                 highLightColor:[UIColor dbAzulPlus]
                                     labelColor:[UIColor whiteColor]
                                       alinhado:NO
                                   iconFontSize:0];
    
    [okBtn addTarget:self action:@selector(closeMe:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:okBtn];
    
    
    frame = self.view.bounds;
    frame.origin.y = 0;
    frame.origin.x = DEFAULT_CONTROL_HEIGHT/2;
    frame.size.height = DEFAULT_CONTROL_HEIGHT;
    frame.size.width = frame.size.width-DEFAULT_CONTROL_HEIGHT;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    UIFont *titleFont = [UIFont titilliumW_thin:38];
    titleLabel.font = titleFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = NSLocalizedString(@"EasyBalance 2", @"");
    
    [self.view addSubview:titleLabel];
    
    
    frame.origin.y = frame.origin.y + frame.size.height*0.7;
    frame.size.height /= 2;
    
    UILabel *desenvLabel = [[UILabel alloc] initWithFrame:frame];
    UIFont *desenvFont = [UIFont titilliumW_thin:18];
    desenvLabel.font = desenvFont;
    desenvLabel.textAlignment = NSTextAlignmentCenter;
    desenvLabel.backgroundColor = [UIColor clearColor];
    desenvLabel.textColor = [UIColor whiteColor];
    desenvLabel.text = NSLocalizedString(@"by Daniel Bonates", @"");
    
    [self.view addSubview:desenvLabel];
    
    
    
    
    
    frame.origin.y = frame.origin.y + frame.size.height;
    frame.size.height = okBtn.frame.origin.y-frame.origin.y;
    frame.origin.x = 0;
    frame.size.width = self.view.bounds.size.width;

    UITextView *creditosView = [[UITextView alloc] initWithFrame:frame];
    UIFont *creditosFont = [UIFont titilliumW_light:13];
    creditosView.font = creditosFont;
    creditosView.backgroundColor = [UIColor dbBranco];
    creditosView.textColor = [UIColor dbMarinho];
    creditosView.editable = NO;
    creditosView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    creditosView.clipsToBounds = YES;
    creditosView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 20.0f, 0.0f);
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"creditos" ofType:@"txt"];
    creditosView.text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.view addSubview:creditosView];
}



- (void)closeMe:(id)sender
{
    [self dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
