//
//  Carteiro.m
//  Aula5
//
//  Created by Daniel e Sabrina on 17/09/10.
//  Copyright 2010 DbonatesApp. All rights reserved.
//

#import "Carteiro.h"
#import "Valor.h"


@implementation Carteiro


- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}


#pragma mark -
#pragma mark email
-(void)showPicker {
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
			
			
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}


#pragma mark -
#pragma mark Compose Mail


-(id)initWithConta:(Conta *)conta eSaldoString:(NSString *)saldoString {
	
	// itens necessarios para se contruir um relatorio:
	// Titulo
	// nsfechedresultscontroller
	// saldo
	
	self.bodyStr = [[NSMutableString alloc] initWithString:@"<body>"];
	[self.bodyStr appendFormat:@"<b>%@ App - %@ %@</b>", NSLocalizedString(@"EasyBalance 2", @""),NSLocalizedString(@"Report", @""), [NSDate shortStyle:[NSDate date]]];
	[self.bodyStr appendFormat:@"<table border=0><td>"];
	[self.bodyStr appendFormat:@"<tr>"];
	[self.bodyStr appendFormat:@"<td>"];
	[self.bodyStr appendFormat:@"</td>"];
	[self.bodyStr appendFormat:@"</tr>"];
	[self.bodyStr appendFormat:@"<tr><td>&nbsp</td></tr>"];
	
    NSPredicate *receitasPredicate = [NSPredicate predicateWithFormat:@"conta ==[c] %@ AND receita ==[c] %@", conta, [NSNumber numberWithBool:YES]];
    NSPredicate *despesasPredicate = [NSPredicate predicateWithFormat:@"conta ==[c] %@ AND receita ==[c] %@", conta, [NSNumber numberWithBool:NO]];
    
 
    NSArray *secoes = @[@"Receipts", @"Expenses"];
    
    NSArray *receitasArray = [Valor MR_findAllWithPredicate:receitasPredicate];
    NSArray *despesasArray = [Valor MR_findAllWithPredicate:despesasPredicate];
    
    int total_de_secoes = secoes.count;
    int total_de_rows;
    
	for (int i=0; i<total_de_secoes; i++) {
		
        BOOL isReceita = (i==0);
        
		total_de_rows = isReceita ? receitasArray.count : despesasArray.count;
		
		[self.bodyStr appendFormat:@"<tr>"];
		[self.bodyStr appendFormat:@"<td>"];
        
        
		NSString *titSect = isReceita ? NSLocalizedString(@"Receipts", @"") : NSLocalizedString(@"Expenses", @"");
		
		[self.bodyStr appendFormat:@"[<b>%@</b>]", titSect];
		
		[self.bodyStr appendFormat:@"<tr>"];
		
		for (int j=0; j<total_de_rows; j++) {
			
			// o registro em questao
			NSString *infoString = isReceita ? [[receitasArray objectAtIndex:j] info] : [[despesasArray objectAtIndex:j] info];
			NSNumber *operando = isReceita ? [[receitasArray objectAtIndex:j] valor] : [[despesasArray objectAtIndex:j] valor];
			
			[self.bodyStr appendFormat:@"<tr>"];
			
			
			[self.bodyStr appendFormat:@"<td>"];
			[self.bodyStr appendFormat:@"%@", infoString];
			[self.bodyStr appendFormat:@"</td>"];
			
			[self.bodyStr appendFormat:@"<td>"];
			[self.bodyStr appendFormat:@"%@", [NSString currencyStringFromNumber:operando]];
			[self.bodyStr appendFormat:@"</td>"];
			
			[self.bodyStr appendFormat:@"</tr>"];
			
			
		}
		[self.bodyStr appendFormat:@"</td>"];
		[self.bodyStr appendFormat:@"</tr>"];
		
		
	}
	
	[self.bodyStr appendFormat:@"<tr>"];
	[self.bodyStr appendFormat:@"<td>"];
	[self.bodyStr appendFormat:@"<br><b>%@: %@</b>", NSLocalizedString(@"Balance", @""), saldoString];
	[self.bodyStr appendFormat:@"</td>"];
	[self.bodyStr appendFormat:@"</tr>"];
	
	[self.bodyStr appendFormat:@"</td></table>"];
	
	[self.bodyStr appendFormat:@"</body>"];
	
	return self;
}



// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:[NSString stringWithFormat: @"[%@] %@ %@", NSLocalizedString(@"EasyBalance 2", @""), NSLocalizedString(@"Report", @""), [NSDate shortStyle:[NSDate date]]]];
	
	// Fill out the email body text
	NSString *emailBody = self.bodyStr;
	[picker setMessageBody:emailBody isHTML:YES];
	
	[self.delegate showComposer:picker];
	
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[self.delegate emailSent:result];
	// Notifies users about errors associated with the interface
	
	
	
}

#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = [NSString stringWithFormat: @"mailto:?cc=&subject=[%@] %@", NSLocalizedString(@"EasyBalance 2", @""), NSLocalizedString(@"Report", @"")];
	NSString *body = [NSString stringWithFormat:@"&body=%@", self.bodyStr];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}




-(void)dealloc {
	self.delegate = nil;
}
@end
