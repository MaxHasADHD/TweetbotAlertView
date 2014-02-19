//
//  MLAlertView.h
//  MLAlertView
//
//  Copyright (c) 2013 Maximilian Litteral.
//  See LICENSE for full license agreement.
//

#import <UIKit/UIKit.h>

@class MLAlertView;

typedef void (^MLAlertTapButtonBlock)(MLAlertView *alertView, NSInteger buttonIndex);

@protocol MLAlertViewDelegate <NSObject>

- (void)alertView:(MLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface MLAlertView : UIView

@property (nonatomic, assign) id<MLAlertViewDelegate> delegate;

@property (nonatomic, copy) MLAlertTapButtonBlock buttonDidTappedBlock;


@property (nonatomic, assign) UIColor *titleBackgroundColor;

@property (nonatomic, assign) UIColor *titleForegroundColor;

@property (nonatomic, assign) UIColor *highlightedCancelButtonBackgroundColor;

@property (nonatomic, assign) UIColor *highlightedCancelButtonForegroundColor;

@property (nonatomic, assign) UIColor *highlightedButtonBackgroundColor;

@property (nonatomic, assign) UIColor *highlightedButtonForegroundColor;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles usingBlockWhenTapButton:(MLAlertTapButtonBlock)tapButtonBlock;


- (void)show;

- (void)dismiss;

@end
