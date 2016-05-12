//
//  MLViewController.m
//  MLAlertView
//
//  Copyright (c) 2013 Maximilian Litteral.
//  See LICENSE for full license agreement.
//

#import "MLViewController.h"

#import "TweetbotAlertController-Swift.h"

@implementation MLViewController

- (IBAction)mlalert2Buttons {
    TweetbotAlertController *alertController = [[TweetbotAlertController alloc] initWithTitle:@"Title" message:@"Message" preferredStyle:UIAlertControllerStyleAlert];
    
    TweetbotAlertAction *action = [[TweetbotAlertAction alloc] initWithTitle:@"Cancel" style:TweetbotAlertActionStyleCancel handler:^(TweetbotAlertAction * _Nonnull action) {
        NSLog(@"Tapped cancel action");
    }];
    [alertController addAction:action];
    
    TweetbotAlertAction *action2 = [[TweetbotAlertAction alloc] initWithTitle:@"Default" style:TweetbotAlertActionStyleDefault handler:^(TweetbotAlertAction * _Nonnull action) {
        NSLog(@"Tapped default action");
    }];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:NO completion:nil];
}

- (IBAction)mlalert3Buttons {
    TweetbotAlertController *alertController = [[TweetbotAlertController alloc] initWithTitle:@"Title" message:@"Message" preferredStyle:UIAlertControllerStyleAlert];
    
    TweetbotAlertAction *cancelAction = [[TweetbotAlertAction alloc] initWithTitle:@"Cancel" style:TweetbotAlertActionStyleCancel handler:^(TweetbotAlertAction * _Nonnull action) {
        NSLog(@"Tapped cancel action");
    }];
    [alertController addAction:cancelAction];
    
    TweetbotAlertAction *action = [[TweetbotAlertAction alloc] initWithTitle:@"Default" style:TweetbotAlertActionStyleDefault handler:^(TweetbotAlertAction * _Nonnull action) {
        NSLog(@"Tapped default action");
    }];
    [alertController addAction:action];
    
    TweetbotAlertAction *action2 = [[TweetbotAlertAction alloc] initWithTitle:@"Default 2" style:TweetbotAlertActionStyleDefault handler:^(TweetbotAlertAction * _Nonnull action) {
        NSLog(@"Tapped default action 2");
    }];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:NO completion:nil];
}

- (IBAction)alert2Buttons {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"Message" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Tapped cancel action");
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Tapped default action");
    }];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)alert3Buttons {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"Message" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Tapped cancel action");
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Tapped default action");
    }];
    [alertController addAction:action];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Destructive" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Tapped destructive action");
    }];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
