//
//  MLAlertView.m
//  MLAlertView
//
//  Copyright (c) 2013 Maximilian Litteral.
//  See LICENSE for full license agreement.
//

#import "MLAlertView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface MLAlertView ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
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

- (void) setTitleBackgroundColor:(UIColor *)titleBackgroundColor {
    _titleBackgroundColor = titleBackgroundColor;
    self.topPart.backgroundColor = _titleBackgroundColor;
}

- (void) setTitleForegroundColor:(UIColor *)titleForegroundColor {
    _titleForegroundColor = titleForegroundColor;
    self.titleLabel.textColor = _titleForegroundColor;
}

- (void) setHighlightedCancelButtonBackgroundColor:(UIColor *)selectedCancelButtonBackgroundColor {
    _highlightedCancelButtonBackgroundColor = selectedCancelButtonBackgroundColor;
    [self.cancelButton setBackgroundImage:[self imageWithColor:_highlightedCancelButtonBackgroundColor] forState:UIControlStateHighlighted];
}

- (void) setHighlightedCancelButtonForegroundColor:(UIColor *)highlightedCancelButtonForegroundColor {
    _highlightedCancelButtonForegroundColor = highlightedCancelButtonForegroundColor;
    [self.cancelButton setTitleColor:highlightedCancelButtonForegroundColor forState:UIControlStateHighlighted];
}

- (void) setHighlightedButtonBackgroundColor:(UIColor *)highlightedButtonBackgroundColor {
    _highlightedButtonBackgroundColor = highlightedButtonBackgroundColor;
    for(UIButton *button in _otherButtons) {
        [button setBackgroundImage:[self imageWithColor:highlightedButtonBackgroundColor] forState:UIControlStateHighlighted];
    }
}

- (void) setHighlightedButtonForegroundColor:(UIColor *)highlightedButtonForegroundColor {
    _highlightedButtonForegroundColor = highlightedButtonForegroundColor;
    for(UIButton *button in _otherButtons) {
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
    }];
}

- (void)dismiss {
    
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
}

- (void)alertButtonWasTapped:(UIButton *)button {
  
  if(self.delegate!=nil)
  {
    [self.delegate alertView:self clickedButtonAtIndex:button.tag];
    
  } else if (self.buttonDidTappedBlock!=nil){
    self.buttonDidTappedBlock(self, button.tag);
  }
}

#pragma mark - initializers


- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
return [self initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles usingBlockWhenTapButton:(MLAlertTapButtonBlock)tapButtonBlock
{
  self = [self initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
  
  self.buttonDidTappedBlock = tapButtonBlock;
  
  return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    self = [super init];
    if (self) {
        _delegate = delegate;
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        
        CGFloat currentWidth = 280;
        CGFloat extraHeight = 0;
        if ((cancelButtonTitle && [otherButtonTitles count] <= 1) || ([otherButtonTitles count] < 2 && !cancelButtonTitle)) {
            //Cancel button and 1 other button, or 1/2 other buttons and no cancel button
            extraHeight = 40;
        }
        else if (cancelButtonTitle && [otherButtonTitles count] > 1) {
            extraHeight = 40 + [otherButtonTitles count]*40;
        }
        else {
            NSLog(@"failed both");
        }
        CGSize maximumSize = CGSizeMake(currentWidth, CGFLOAT_MAX);
        CGRect boundingRect = [message boundingRectWithSize:maximumSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : font} context:nil];
        CGFloat height = boundingRect.size.height + 16.0+40+extraHeight;

        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

        self.frame = CGRectMake(20, (screenHeight-height)/2, 280, height);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 13;
        
        //Title View
        self.topPart = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        self.titleBackgroundColor = [UIColor colorWithRed:0.063 green:0.486 blue:0.965 alpha:1.000];;
        [self addSubview:self.topPart];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        self.titleLabel.text = title;
        self.titleForegroundColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
        [self.topPart addSubview:self.titleLabel];
        
        
        //Message view
        UITextView *messageView = [[UITextView alloc] init];
        CGFloat newLineHeight = boundingRect.size.height + 16.0;
        messageView.frame = CGRectMake(0, 40, 280, newLineHeight);
        messageView.text = message;
        messageView.font = font;
        messageView.editable = NO;
        messageView.dataDetectorTypes = UIDataDetectorTypeAll;
        messageView.userInteractionEnabled = NO;
        messageView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:messageView];
        
        //buttons
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, height-extraHeight, 280, extraHeight)];
        
        CALayer *horizontalBorder = [CALayer layer];
        horizontalBorder.frame = CGRectMake(0.0f, 0.0f, buttonView.frame.size.width, 0.5f);
        horizontalBorder.backgroundColor = [UIColor colorWithRed:0.824 green:0.827 blue:0.831 alpha:1.000].CGColor;
        [buttonView.layer addSublayer:horizontalBorder];
        
        if ((cancelButtonTitle && [otherButtonTitles count] == 1) || ([otherButtonTitles count] <= 2 && !cancelButtonTitle)) {
            CALayer *centerBorder = [CALayer layer];
            centerBorder.frame = CGRectMake(buttonView.frame.size.width/2+0.5, 0.0f, 0.5f, buttonView.frame.size.height);
            centerBorder.backgroundColor = [UIColor colorWithRed:0.824 green:0.827 blue:0.831 alpha:1.000].CGColor;
            [buttonView.layer addSublayer:centerBorder];
        }
        [self addSubview:buttonView];
        
        if (cancelButtonTitle) {
            self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([otherButtonTitles count] == 1) {
                self.cancelButton.frame = CGRectMake(0, 0, 141, 40);
            }
            else self.cancelButton.frame = CGRectMake(0, CGRectGetHeight(buttonView.frame)-40, 280, 40);
            
            [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.highlightedCancelButtonForegroundColor = [UIColor colorWithRed:0.769 green:0.000 blue:0.071 alpha:1.000];
            self.highlightedCancelButtonBackgroundColor = [UIColor colorWithRed:0.933 green:0.737 blue:0.745 alpha:1.000];
            self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [self.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            self.cancelButton.tag = 0;
            [buttonView addSubview:self.cancelButton];
        }
        
        NSMutableArray *otherButtons = [[NSMutableArray alloc] initWithCapacity:[otherButtonTitles count]];
        for (int i=0; i<[otherButtonTitles count]; i++) {
            UIButton *otherTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [otherButtons addObject:otherTitleButton];
            
            if ([otherButtonTitles count] == 1 && !cancelButtonTitle) {
                //1 other button and no cancel button
                otherTitleButton.frame = CGRectMake(0, 0, 280, 40);
                otherTitleButton.tag = 0;
            }
            else if (([otherButtonTitles count] == 2 && !cancelButtonTitle) || ([otherButtonTitles count] == 1 && cancelButtonTitle)) {
                // 2 other buttons, no cancel or 1 other button and cancel
                otherTitleButton.tag = i+1;
                otherTitleButton.frame = CGRectMake(140, 0, 142, 40);
            }
            else if ([otherButtonTitles count] >= 2) {
            
                if (cancelButtonTitle) {
                    otherTitleButton.frame = CGRectMake(0, (i*40)+0.5, 280, 40);
                    otherTitleButton.tag = i+1;
                }
                else {
                    otherTitleButton.frame = CGRectMake(0, i*40, 280, 40);
                    otherTitleButton.tag = i;
                }
                CALayer *horizontalBorder = [CALayer layer];
                horizontalBorder.frame = CGRectMake(0.0f, otherTitleButton.frame.origin.y+39.5, buttonView.frame.size.width, 0.5f);
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
        self.highlightedButtonBackgroundColor = [UIColor colorWithRed:0.878 green:0.933 blue:0.992 alpha:1.000];
        self.highlightedButtonForegroundColor = [UIColor colorWithRed:0.071 green:0.431 blue:0.965 alpha:1.000];
        
        
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-20);
        horizontalMotionEffect.maximumRelativeValue = @(20);
        
        UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-20);
        verticalMotionEffect.maximumRelativeValue = @(20);
        
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        [self addMotionEffect:group];
        
    }
    return self;
}

@end
