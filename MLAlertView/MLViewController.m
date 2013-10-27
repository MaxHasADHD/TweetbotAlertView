//
//  MLViewController.m
//  MLAlertView
//
//  Created by Maximilian Litteral on 10/26/13.
//  Copyright (c) 2013 Maximilian Litteral. All rights reserved.
//

#import "MLViewController.h"

#import "MLAlertView.h"

@interface MLViewController ()

@end

@implementation MLViewController

- (IBAction)showAlert {
    MLAlertView *alert = [[MLAlertView alloc] initWithTitle:@"Title" withMessage:@"Message" withCancelButtonTitle:@"Cancel"];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
