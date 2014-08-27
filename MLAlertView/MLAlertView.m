//
//  MLAlertView.m
//  MLAlertView
//
//  Copyright (c) 2013 Maximilian Litteral.
//  See LICENSE for full license agreement.
//

#import "MLAlertView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define kAlertwidth 280
#define kButtonHeight 41

#define kRedColor [UIColor colorWithRed:0.933 green:0.737 blue:0.745 alpha:1.000]
#define kRedTitleColor [UIColor colorWithRed:0.769 green:0.000 blue:0.071 alpha:1.000]
#define kBlueColor [UIColor colorWithRed:0.878 green:0.933 blue:0.992 alpha:1.000]
#define kBlueTitleColor [UIColor colorWithRed:0.071 green:0.431 blue:0.965 alpha:1.000]

@interface MLAlertView ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topPart;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSArray *otherButtons;
@end

@implementation MLAlertView

#pragma mark -

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Setters

- (void)setTitleBackgroundColor:(UIColor *)titleBackgroundColor {
    _titleBackgroundColor = titleBackgroundColor;
    self.topPart.backgroundColor = _titleBackgroundColor;
}

- (void)setTitleForegroundColor:(UIColor *)titleForegroundColor {
    _titleForegroundColor = titleForegroundColor;
    self.titleLabel.textColor = _titleForegroundColor;
}

- (void)setHighlightedCancelButtonBackgroundColor:(UIColor *)selectedCancelButtonBackgroundColor {
    _highlightedCancelButtonBackgroundColor = selectedCancelButtonBackgroundColor;
    [self.cancelButton setBackgroundImage:[self imageWithColor:_highlightedCancelButtonBackgroundColor] forState:UIControlStateHighlighted];
}

- (void)setHighlightedCancelButtonForegroundColor:(UIColor *)highlightedCancelButtonForegroundColor {
    _highlightedCancelButtonForegroundColor = highlightedCancelButtonForegroundColor;
    [self.cancelButton setTitleColor:highlightedCancelButtonForegroundColor forState:UIControlStateHighlighted];
}

- (void)setHighlightedButtonBackgroundColor:(UIColor *)highlightedButtonBackgroundColor {
    _highlightedButtonBackgroundColor = highlightedButtonBackgroundColor;
    for (UIButton *button in _otherButtons) {
        [button setBackgroundImage:[self imageWithColor:highlightedButtonBackgroundColor] forState:UIControlStateHighlighted];
    }
}

- (void)setHighlightedButtonForegroundColor:(UIColor *)highlightedButtonForegroundColor {
    _highlightedButtonForegroundColor = highlightedButtonForegroundColor;
    for (UIButton *button in _otherButtons) {
        [button setTitleColor:highlightedButtonForegroundColor forState:UIControlStateHighlighted];
    }
}

#pragma mark - Actions

- (void)show {
    self.alpha = 0.0;
    CGAffineTransform scale = CGAffineTransformMakeScale(5, 5);
    self.transform = scale;
    [[[UIApplication sharedApplication] windows][0] addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        self.transform = CGAffineTransformIdentity;
        
        self.window.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        self.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    }];
}

- (void)dismiss {
    self.userInteractionEnabled = NO;
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:[[UIApplication sharedApplication] windows][0]];
    
    CGPoint squareCenterPoint = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame));
    UIOffset attachmentPoint = UIOffsetMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self offsetFromCenter:attachmentPoint attachedToAnchor:squareCenterPoint];
    [animator addBehavior:attachmentBehavior];
    self.attachmentBehavior = attachmentBehavior;
    
    UIGravityBehavior *gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[self]];
    gravityBeahvior.magnitude = 4;
    gravityBeahvior.angle = DEGREES_TO_RADIANS(100);
    [animator addBehavior:gravityBeahvior];
    self.gravityBehavior = gravityBeahvior;
    
    self.animator = animator;
    [self performSelector:@selector(removeFromSuperview) withObject:self afterDelay:0.7];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.window.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    }];
    
}

- (void)alertButtonWasTapped:(UIButton *)button {
    if (self.delegate != nil) {
        [self.delegate alertView:self clickedButtonAtIndex:button.tag];
        
    } else if (self.buttonDidTappedBlock != nil) {
        self.buttonDidTappedBlock(self, button.tag);
    }
}

#pragma mark - Setup

- (void)setupTitleViewWithTitle:(NSString *)title {
    self.topPart = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAlertwidth, 41.5)];
    self.titleBackgroundColor = [UIColor colorWithRed:0.063 green:0.486 blue:0.965 alpha:1.000];;
    [_alertView addSubview:self.topPart];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kAlertwidth, 40)];
    self.titleLabel.text = title;
    self.titleForegroundColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [self.topPart addSubview:self.titleLabel];
}

- (CALayer *)lineAt:(CGRect)rect {
    CALayer *border = [CALayer layer];
    border.frame = rect;
    border.backgroundColor = [UIColor colorWithRed:0.824 green:0.827 blue:0.831 alpha:1.000].CGColor;
    return border;
}

#pragma mark - initializers

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    return [self initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles usingBlockWhenTapButton:(MLAlertTapButtonBlock)tapButtonBlock {
    self = [self initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
    
    self.buttonDidTappedBlock = tapButtonBlock;
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    self = [super init];
    if (self) {
        _delegate = delegate;
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        self.backgroundColor = [UIColor clearColor];
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        
        CGFloat extraHeight = 0;
        if ((cancelButtonTitle && [otherButtonTitles count] <= 1) ||
            ([otherButtonTitles count] < 2 && !cancelButtonTitle)) {
            // Cancel button and 1 other button, or 1/2 other buttons and no cancel button
            extraHeight = kButtonHeight;
        }
        else if (cancelButtonTitle && [otherButtonTitles count] > 1) {
            extraHeight = kButtonHeight + [otherButtonTitles count]*kButtonHeight;
        }
        else {
            NSLog(@"failed both");
        }
        
        CGSize maximumSize = CGSizeMake(270, CGFLOAT_MAX);
        CGRect boundingRect = [message boundingRectWithSize:maximumSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : font} context:nil];
        CGFloat height = boundingRect.size.height + 16.0+40+extraHeight;
        
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(20, (screenHeight-height)/2, kAlertwidth, height)];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 13;
        [self addSubview:_alertView];
        
        [self setupTitleViewWithTitle:title];
        
        UITextView *messageView = [[UITextView alloc] init];
        CGFloat newLineHeight = boundingRect.size.height + 16.0;
        messageView.frame = CGRectMake(0, CGRectGetHeight(self.topPart.frame), kAlertwidth, newLineHeight);
        messageView.text = message;
        messageView.font = font;
        messageView.editable = NO;
        messageView.dataDetectorTypes = UIDataDetectorTypeNone;
        messageView.userInteractionEnabled = NO;
        messageView.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:messageView];
        
        
        // Buttons
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, height-extraHeight, kAlertwidth, extraHeight)];
        
        CALayer *horizontalBorder = [self lineAt:CGRectMake(0, 0, buttonView.frame.size.width, 0.5)];
        [buttonView.layer addSublayer:horizontalBorder];
        
        // Adds border between 2 buttons
        if ((cancelButtonTitle && [otherButtonTitles count] == 1) ||
            ([otherButtonTitles count] <= 2 && !cancelButtonTitle)) {
            CALayer *centerBorder = [CALayer layer];
            centerBorder.frame = CGRectMake(140, 0.0f, 0.5f, 41.5f);
            centerBorder.backgroundColor = [UIColor colorWithRed:0.824 green:0.827 blue:0.831 alpha:1.000].CGColor;
            [buttonView.layer addSublayer:centerBorder];
        }
        [_alertView addSubview:buttonView];
        
        // Setup cancel button
        if (cancelButtonTitle) {
            self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([otherButtonTitles count] == 1) {
                // Cancel button & 1 other button
                self.cancelButton.frame = CGRectMake(0, 0, 140, kButtonHeight);
            }
            else {
                // Cancel button + multiple other buttons
                self.cancelButton.frame = CGRectMake(0, extraHeight-41+0.5, kAlertwidth, kButtonHeight);
            }
            
            [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.highlightedCancelButtonBackgroundColor = kRedColor;
            self.highlightedCancelButtonForegroundColor = kRedTitleColor;
            self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [self.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            self.cancelButton.tag = 0;
            [buttonView addSubview:self.cancelButton];
        }
        
        // Setup other buttons
        NSMutableArray *otherButtons = [[NSMutableArray alloc] init];
        for (int i=0; i<[otherButtonTitles count]; i++) {
            UIButton *otherTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [otherButtons addObject:otherTitleButton];
            
            if ([otherButtonTitles count] == 1 && !cancelButtonTitle) {
                //1 other button and no cancel button
                otherTitleButton.frame = CGRectMake(0, 0, kAlertwidth, kButtonHeight);
                otherTitleButton.tag = 0;
            }
            else if (([otherButtonTitles count] == 2 && !cancelButtonTitle) ||
                     ([otherButtonTitles count] == 1 && cancelButtonTitle)) {
                // 2 other buttons, no cancel or 1 other button and cancel
                otherTitleButton.tag = i+1;
                otherTitleButton.frame = CGRectMake(140.5, 0, 139.5, kButtonHeight);
            }
            else if ([otherButtonTitles count] >= 2) {
                if (cancelButtonTitle) {
                    otherTitleButton.frame = CGRectMake(0, (i*kButtonHeight)+0.5, kAlertwidth, kButtonHeight);
                    otherTitleButton.tag = i+1;
                }
                else {
                    otherTitleButton.frame = CGRectMake(0, i*kButtonHeight, kAlertwidth, kButtonHeight);
                    otherTitleButton.tag = i;
                }
                CALayer *horizontalBorder = [CALayer layer];
                CGFloat borderY = CGRectGetMaxY(otherTitleButton.frame)-0.5;
                horizontalBorder.frame = CGRectMake(0.0f, borderY, buttonView.frame.size.width, 0.5f);
                horizontalBorder.backgroundColor = [UIColor colorWithRed:0.824 green:0.827 blue:0.831 alpha:1.000].CGColor;
                [buttonView.layer addSublayer:horizontalBorder];
            }
            
            [otherTitleButton addTarget:self action:@selector(alertButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
            [otherTitleButton setTitle:otherButtonTitles[i] forState:UIControlStateNormal];
            [otherTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            otherTitleButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [buttonView addSubview:otherTitleButton];
        }
        self.otherButtons = [NSArray arrayWithArray:otherButtons];
        self.highlightedButtonBackgroundColor = kBlueColor;
        self.highlightedButtonForegroundColor = kBlueTitleColor;
        
        // Motion effects
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-10);
        horizontalMotionEffect.maximumRelativeValue = @(10);
        
        UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-10);
        verticalMotionEffect.maximumRelativeValue = @(10);
        
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        [_alertView addMotionEffect:group];
        
    }
    return self;
}

@end
