//
//  MLAlertView.h
//  MLAlertView
//
//  Copyright (c) 2013 Maximilian Litteral.
//  See LICENSE for full license agreement.
//

#import <UIKit/UIKit.h>

@class MLAlertView;

@protocol MLAlertViewDelegate <NSObject>

- (void)alertView:(MLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface MLAlertView : UIView

@property (nonatomic, assign) id<MLAlertViewDelegate> delegate;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
- (void)show;
- (void)dismiss;

@end
