//
//  MLAlertView.m
//  MLAlertView
//
//  Created by Maximilian Litteral on 10/26/13.
//  Copyright (c) 2013 Maximilian Litteral. All rights reserved.
//

#import "MLAlertView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface MLAlertView () <UICollisionBehaviorDelegate>
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
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

- (void)hide {
    
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
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self]];
    //    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [animator addBehavior:collisionBehavior];
    self.collisionBehavior = collisionBehavior;
    
    self.animator = animator;
}

#pragma mark - setup

- (instancetype)initWithTitle:(NSString *)title withMessage:(NSString *)message withCancelButtonTitle:(NSString *)cancelButtontitle {
    self = [super init];
    if (self) {
        
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        
        CGFloat currentWidth = 280;
        CGSize maximumSize = CGSizeMake(currentWidth, CGFLOAT_MAX);
        CGRect boundingRect = [message boundingRectWithSize:maximumSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : font} context:nil];
        NSInteger height = boundingRect.size.height + 16.0+40+40;
        
        self.frame = CGRectMake(20, 568/2-height/2, 280, height);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 13;
        
        //Title View
        UIView *topPart = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        topPart.backgroundColor = [UIColor colorWithRed:0.063 green:0.486 blue:0.965 alpha:1.000];
        [self addSubview:topPart];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:19];
        [topPart addSubview:titleLabel];
        
        
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
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, height-40, 280, 40)];
        CALayer *TopBorder = [CALayer layer];
        TopBorder.frame = CGRectMake(0.0f, 0.0f, buttonView.frame.size.width, 0.5f);
        TopBorder.backgroundColor = [UIColor colorWithRed:0.824 green:0.827 blue:0.831 alpha:1.000].CGColor;
        [buttonView.layer addSublayer:TopBorder];
        CALayer *centerBorder = [CALayer layer];
        centerBorder.frame = CGRectMake(buttonView.frame.size.width/2+0.5, 0.0f, 0.5f, buttonView.frame.size.height);
        centerBorder.backgroundColor = [UIColor colorWithRed:0.824 green:0.827 blue:0.831 alpha:1.000].CGColor;
        [buttonView.layer addSublayer:centerBorder];
        [self addSubview:buttonView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, 141, 40);
        [cancelButton setTitle:cancelButtontitle forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:0.769 green:0.000 blue:0.071 alpha:1.000] forState:UIControlStateHighlighted];
        [cancelButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.933 green:0.737 blue:0.745 alpha:1.000]] forState:UIControlStateHighlighted];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:cancelButton];
        
        UIButton *otherTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        otherTitleButton.frame = CGRectMake(140, 0, 142, 40);
        [otherTitleButton setTitle:@"Open" forState:UIControlStateNormal];
        [otherTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [otherTitleButton setTitleColor:[UIColor colorWithRed:0.071 green:0.431 blue:0.965 alpha:1.000] forState:UIControlStateHighlighted];
        [otherTitleButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.878 green:0.933 blue:0.992 alpha:1.000]] forState:UIControlStateHighlighted];
        otherTitleButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [buttonView addSubview:otherTitleButton];
        
    }
    return self;
}

@end
