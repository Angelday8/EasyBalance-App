//
//  Carteiro.h
//  Aula5
//
//  Created by Daniel e Sabrina on 17/09/10.
//  Copyright 2010 DbonatesApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Conta.h"

@protocol CarteiroDelegate

-(void) emailSent:(MFMailComposeResult)result;
-(void) showComposer:(MFMailComposeViewController *)picker;
  
@end

@class Registro;

@interface Carteiro : NSObject <MFMailComposeViewControllerDelegate>
	
@property (nonatomic, strong) NSMutableString *bodyStr;
	
@property (nonatomic, assign) id <CarteiroDelegate> delegate;


// email stuff
-(void)showPicker;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;

-(id)initWithConta:(Conta *)conta eSaldoString:(NSString *)saldoString;

@end
