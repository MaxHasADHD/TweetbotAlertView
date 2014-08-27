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
  MLAlertView *alert = [[MLAlertView alloc] initWithTitle:@"Travel Reward" message:@"Know exactly when you can travel for free! Simply take 8 paid journeys from Monday-Sunday with an Opal card and enjoy free travel for the rest of the week, exclusing the airport station access fee." delegate:self cancelButtonTitle:@"Got it!" otherButtonTitles:nil];
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

- (IBAction)alertUsingBlock:(id)sender {
  MLAlertView *alert = [[MLAlertView alloc] initWithTitle:@"Title" message:@"Message" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Open",@"Testing"] usingBlockWhenTapButton:^(MLAlertView *alertView, NSInteger buttonIndex) {
    NSLog(@"tap from block - %li",(long)buttonIndex);
    [alertView dismiss];
  }];
  
  [alert show];
}

- (IBAction)alertUsingBlock2:(id)sender {
  
  MLAlertView *alert = [[MLAlertView alloc] initWithTitle:@"Title" message:@"Message" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Open",@"Testing"]];
  
  alert.buttonDidTappedBlock = ^(MLAlertView *alertView, NSInteger buttonIndex) {
    NSLog(@"tap from block 2 - %li",(long)buttonIndex);
    [alertView dismiss];
  };
  
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
