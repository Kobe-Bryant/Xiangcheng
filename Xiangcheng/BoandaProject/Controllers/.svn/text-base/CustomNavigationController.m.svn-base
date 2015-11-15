//
//  CustomNavigationController.m
//  GuangXiOA
//
//  Created by zhang on 13-3-26.
//
//

#import "CustomNavigationController.h"

@implementation CustomNavigationController

-(BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return   [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

@end
