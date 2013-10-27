//
//  MLAlertView.h
//  MLAlertView
//
//  Created by Maximilian Litteral on 10/26/13.
//  Copyright (c) 2013 Maximilian Litteral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title withMessage:(NSString *)message withCancelButtonTitle:(NSString *)cancelButtontitle ;
- (void)show;

@end
