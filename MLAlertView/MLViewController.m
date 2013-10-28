//
//  MLViewController.m
//  MLAlertView
//
//  Copyright (c) 2013 Maximilian Litteral.
//  See LICENSE for full license agreement.
//

#import "MLViewController.h"

#import "MLAlertView.h"

@interface MLViewController () <MLAlertViewDelegate>

@end

@implementation MLViewController

- (void)alertView:(MLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%li",(long)buttonIndex);
    [alertView dismiss];
}

- (IBAction)mlalert2Buttons {
    MLAlertView *alert = [[MLAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Open"]];
    [alert show];
}

- (IBAction)mlalert3Buttons {
    MLAlertView *alert = [[MLAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Open",@"Testing"]];
    [alert show];
}

- (IBAction)alert2Buttons {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open", nil];
    [alert show];
}

- (IBAction)alert3Buttons {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open",@"Testing", nil];
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
