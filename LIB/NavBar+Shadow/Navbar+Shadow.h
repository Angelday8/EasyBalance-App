//
//  Navbar+Shadow.h
//  Teste
//
//  Created by Daniel Bonates on 5/3/13.
//  Copyright (c) 2013 Daniel Bonates. All rights reserved.
//

#ifndef Teste_Navbar_Shadow_h
#define Teste_Navbar_Shadow_h

@interface UINavigationBar (dropshadow)

-(void) applyDefaultStyle;

@end

@implementation UINavigationBar (dropshadow)

-(void)willMoveToWindow:(UIWindow *)newWindow{
	[super willMoveToWindow:newWindow];
	[self applyDefaultStyle];
}

- (void)applyDefaultStyle {
	// add the drop shadow
	self.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.layer.shadowOffset = CGSizeMake(0.0, 3.0);
	self.layer.shadowOpacity = 0.25;
}
@end


#endif
