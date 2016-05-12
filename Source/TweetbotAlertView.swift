//
//  TweetbotAlertView.swift
//  MLAlertView
//
//  Created by Maximilian Litteral on 5/11/16.
//  Copyright © 2016 Maximilian Litteral. All rights reserved.
//

import UIKit
import GLKit

// MARK: - Constants

private let ButtonHeight = 41

// MARK: - Protocols

protocol TweetbotAlertViewDelegate: class {
    func dismissAlert()
}

/// Used to send up the chain of views to dismiss the alert
protocol BottonTappedProtocol: class {
    func buttonWasTapped()
}

// MARK: - Classes

public class TweetbotAlertView: UIView, BottonTappedProtocol {
    
    // MARK: - Properties
    
    // Public
    weak var delegate: TweetbotAlertViewDelegate?
    var title: String? {
        didSet {
            topView.title = title
        }
    }
    var message: String? {
        didSet {
            messageView.message = message
        }
    }
    
    public var titleBackgroundColor: UIColor? {
        didSet {
            topView.titleBackgroundColor = titleBackgroundColor
        }
    }
    
    public var titleForegroundColor: UIColor? {
        didSet {
            topView.titleForegroundColor = titleForegroundColor
        }
    }
    
    public var highlightedCancelButtonBackgroundColor: UIColor? {
        didSet {
            actionsView.highlightedCancelButtonBackgroundColor = highlightedCancelButtonBackgroundColor
        }
    }
    
    public var highlightedCancelButtonForegroundColor: UIColor? {
        didSet {
            actionsView.highlightedCancelButtonForegroundColor = highlightedCancelButtonForegroundColor
        }
    }
    
    public var highlightedButtonBackgroundColor: UIColor? {
        didSet {
            actionsView.highlightedButtonBackgroundColor = highlightedButtonBackgroundColor
        }
    }
    
    public var highlightedButtonForegroundColor: UIColor? {
        didSet {
            actionsView.highlightedButtonForegroundColor = highlightedButtonForegroundColor
        }
    }
    
    // Private
    private let topView: TitleView
    private let messageView: MessageView
    private let actionsView: BottomView
    
    private var animator: UIDynamicAnimator?
    private var attachmentBehavior: UIAttachmentBehavior?
    private var gravityBehavior: UIGravityBehavior?
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) { fatalError() }
    
    override init(frame: CGRect) { fatalError() }
    
    public init(title: String?, message: String?) {
        self.title = title
        self.message = message
        
        self.topView = TitleView(title: title)
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        self.messageView = MessageView(message: message)
        self.messageView.translatesAutoresizingMaskIntoConstraints = false
        self.actionsView = BottomView()
        self.actionsView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: CGRect.zero)
        
        self.alpha = 0.0
        
        // Configure view
        self.backgroundColor = UIColor.whiteColor()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 13
        
        // Add subviews
        self.addSubview(topView)
        self.addSubview(messageView)
        self.actionsView.delegate = self
        self.addSubview(actionsView)
        
        // Constraints
        var constraints: [NSLayoutConstraint] = []
        // Top view
        constraints.append(topView.topAnchor.constraintEqualToAnchor(self.topAnchor))
        constraints.append(topView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor))
        constraints.append(topView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor))
        constraints.append(topView.heightAnchor.constraintEqualToConstant(41.5))
        
        // Message view
        constraints.append(messageView.topAnchor.constraintEqualToAnchor(topView.bottomAnchor))
        constraints.append(messageView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor))
        constraints.append(messageView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor))
        
        // Actions view
        constraints.append(actionsView.topAnchor.constraintEqualToAnchor(messageView.bottomAnchor))
        constraints.append(actionsView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor))
        constraints.append(actionsView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor))
        constraints.append(actionsView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor))
        
        self.addConstraints(constraints)
    }
    
    // MARK: - Actions
    
    // Public interface
    
    func addAction(action: TweetbotAlertAction) {
        actionsView.addAction(action)
    }
    
    /// Use to lay out alert buttons
    func configure() {
        actionsView.configure()
    }
    
    /// Use to display alert
    func show() {
        let scale = CGAffineTransformMakeScale(5, 5)
        self.transform = scale
        UIView.animateWithDuration(0.3) { 
            self.alpha = 1.0
            self.transform = CGAffineTransformIdentity
            self.window?.tintAdjustmentMode = .Dimmed
        }
    }
    
    // Private interface
    
    private func wait(seconds seconds: Double, block: (() -> Void)) {
        let delay = seconds * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
            block()
        })
    }
    
    private func dismiss() {
        self.userInteractionEnabled = false
        
        let window = UIApplication.sharedApplication().windows[0]
        let animator = UIDynamicAnimator(referenceView: window)
        
        let squareCenterPoint = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame))
        let attachmentPoint = UIOffsetMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame))
        
        let attachmentBehavior = UIAttachmentBehavior(item: self, offsetFromCenter: attachmentPoint, attachedToAnchor: squareCenterPoint)
        animator.addBehavior(attachmentBehavior)
        self.attachmentBehavior = attachmentBehavior
        
        let gravityBeahvior = UIGravityBehavior(items: [self])
        gravityBeahvior.magnitude = 4
        gravityBeahvior.angle = CGFloat(GLKMathDegreesToRadians(100))
        animator.addBehavior(gravityBeahvior)
        self.gravityBehavior = gravityBeahvior
        
        // Begin to animate
        self.animator = animator
        
        wait(seconds: 0.5) { 
            self.delegate?.dismissAlert()
        }
        
        UIView.animateWithDuration(0.3) {
            self.window?.tintAdjustmentMode = .Normal
        }
        
    }
    
    // MARK: - BottonTappedProtocol
    
    func buttonWasTapped() {
        self.dismiss()
    }
}

private class TitleView: UIView {
    // MARK: - Properties
    
    // Public
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var titleBackgroundColor: UIColor? {
        didSet {
            self.backgroundColor = titleBackgroundColor
        }
    }
    
    var titleForegroundColor: UIColor? {
        didSet {
            titleLabel.textColor = titleForegroundColor
        }
    }
    
    // Private
    private let titleLabel: UILabel
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override init(frame: CGRect) { fatalError() }
    
    init(title: String?) {
        self.title = title
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.boldSystemFontOfSize(19)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: CGRect.zero)
        
//        self.backgroundColor = UIColor(red: 0.063, green: 0.486, blue: 0.965, alpha: 1.000)
        
        // Add subviews
        self.addSubview(titleLabel)
        
        // Constraints
        let constraints: [NSLayoutConstraint] = [
            titleLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor)
        ]
    
        self.addConstraints(constraints)
    }
}

private class MessageView: UIView {
    // MARK: - Properties
    
    // Public
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    // Private
    private let messageLabel: UILabel
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override init(frame: CGRect) { fatalError() }
    
    init(message: String?) {
        self.message = message
        
        messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: CGRect.zero)
        
        let hairlineView = HairlineView()
        
        // Add subviews
        self.addSubview(messageLabel)
        self.addSubview(hairlineView)
        
        // Constraints
        let constraints: [NSLayoutConstraint] = [
            messageLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5),
            messageLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 5),
            messageLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: -5),
            messageLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -5),
            
            hairlineView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor),
            hairlineView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor),
            hairlineView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor),
            hairlineView.heightAnchor.constraintEqualToConstant(0.5),
        ]
        
        self.addConstraints(constraints)
    }
}

private class BottomView: UIView {
    // MARK: - Properties
    
    // Public
    weak var delegate: BottonTappedProtocol?
    
    var highlightedCancelButtonBackgroundColor: UIColor?
    var highlightedCancelButtonForegroundColor: UIColor?
    var highlightedButtonBackgroundColor: UIColor?
    var highlightedButtonForegroundColor: UIColor?

    // Private
    private var actions: [TweetbotAlertAction] = []
    private let stackView: UIStackView
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override init(frame: CGRect) { fatalError() }
    
    init() {
        stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.distribution = .FillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: CGRect.zero)
        
        self.addSubview(stackView)
        
        // Constraints
        let constraints: [NSLayoutConstraint] = [
            stackView.topAnchor.constraintEqualToAnchor(self.topAnchor),
            stackView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor),
            stackView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor),
            stackView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor),
        ]
        self.addConstraints(constraints)
    }
    
    // MARK: - Actions
    
    // Public
    
    func addAction(action: TweetbotAlertAction) {
        actions.append(action)
    }
    
    /// Use to lay out alert buttons
    func configure() {
        let defaultActions = actions.filter { $0.actionStyle == .Default }
        let cancelActions = actions.filter { $0.actionStyle == .Cancel }
        
        let totalActions = actions.count
        let cancelActionsCount = cancelActions.count
        
        guard cancelActions.count <= 1 else { fatalError("TweetbotAlertController can only have one action with a style of TweetbotAlertActionStyleCancel") }
        
        // Used between 2 buttons
        let showMidlineSeparator: Bool
        // Used between 3+ buttons
        let showBottomSeparator: Bool
        
        if totalActions <= 2 {
            stackView.axis = .Horizontal
            showMidlineSeparator = true
            showBottomSeparator = false
        }
        else {
            stackView.axis = .Vertical
            showMidlineSeparator = false
            showBottomSeparator = true
        }
        
        if showMidlineSeparator {
            let hairlineView = HairlineView()
            self.addSubview(hairlineView)
            let constraints: [NSLayoutConstraint] = [
                hairlineView.topAnchor.constraintEqualToAnchor(self.topAnchor),
                hairlineView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor),
                hairlineView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor),
                hairlineView.widthAnchor.constraintEqualToConstant(0.5),
            ]
            self.addConstraints(constraints)
        }
        
        // Default
        if cancelActionsCount == 0 && totalActions > 1 {
            for (index, action) in defaultActions.enumerate() {
                var showBottomBorder = true
                if index == totalActions-1 {
                    showBottomBorder = false
                }
                let button = configureDefaultButtonForAction(action, showBottomBorder: showBottomBorder)
                stackView.addArrangedSubview(button)
            }
        }
        else {
            for action in defaultActions {
                let button = configureDefaultButtonForAction(action, showBottomBorder: showBottomSeparator)
                stackView.addArrangedSubview(button)
            }
        }
        
        // Cancel
        if let cancelAction = cancelActions.first {
            let button = configureCancelButtonForAction(cancelAction)
            
            if totalActions <= 2 {
                stackView.insertArrangedSubview(button, atIndex: 0)
            }
            else {
                stackView.addArrangedSubview(button)
            }
        }
    }
    
    // Private

    func configureCancelButtonForAction(action: TweetbotAlertAction) -> UIButton {
        let button = ActionButton(action: action)
        button.setTitle(action.actionTitle, forState: .Normal)
        button.setTitleColor(.blackColor(), forState: .Normal)
        button.setBackgroundColor(highlightedCancelButtonBackgroundColor, forState: .Highlighted)
        button.setTitleColor(highlightedCancelButtonForegroundColor, forState: .Highlighted)
        button.setTitleLabelFont(UIFont.boldSystemFontOfSize(18))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.delegate = self.delegate
        return button
    }
    
    func configureDefaultButtonForAction(action: TweetbotAlertAction, showBottomBorder: Bool) -> UIButton {
        let button = ActionButton(action: action, showBottomBorder: showBottomBorder)
        button.setTitle(action.actionTitle, forState: .Normal)
        button.setTitleColor(.blackColor(), forState: .Normal)
        button.setBackgroundColor(highlightedButtonBackgroundColor, forState: .Highlighted)
        button.setTitleColor(highlightedButtonForegroundColor, forState: .Highlighted)
        button.setTitleLabelFont(UIFont.boldSystemFontOfSize(18))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.delegate = self.delegate
        return button
    }
}

private class ActionButton: UIButton {
    // MARK: - Properties
    
    // Public
    weak var delegate: BottonTappedProtocol?
    
    // Private
    private let action: TweetbotAlertAction
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override init(frame: CGRect) { fatalError() }
    
    init(action: TweetbotAlertAction, showBottomBorder: Bool = false) {
        self.action = action
        
        super.init(frame: CGRect.zero)
        
        // Constraints
        var constraints: [NSLayoutConstraint] = [
            self.heightAnchor.constraintEqualToConstant(41)
        ]
        
        if showBottomBorder {
            let hairlineView = HairlineView()
            self.addSubview(hairlineView)
            constraints += [
                hairlineView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor),
                hairlineView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor),
                hairlineView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor),
                hairlineView.heightAnchor.constraintEqualToConstant(0.5),
            ]
        }
    
        self.addConstraints(constraints)
        
        // Actions
        self.addTarget(self, action: #selector(ActionButton.touchUpInside), forControlEvents: .TouchUpInside)
    }
    
    // MARK: - Actions
    
    // Public
    
    // Private
    
    @objc func touchUpInside() {
        delegate?.buttonWasTapped()
        action.handler?(action: action)
    }
}

// MARK: - Extensions

extension UIButton {
    func setBackgroundColor(color: UIColor?, forState state: UIControlState) {
        let image = imageWithColor(color)
        self.setBackgroundImage(image, forState: state)
    }
    
    func setTitleLabelFont(font: UIFont) {
        self.titleLabel?.font = font
    }
    
    private func imageWithColor(color: UIColor?) -> UIImage? {
        guard let color = color else { return nil }
        let rect = CGRectMake(0, 0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image;
    }
}

// MARK: - Global functions

private func HairlineView() -> UIView {
    let view = UIView()
    view.backgroundColor = UIColor(red: 0.824, green: 0.827, blue: 0.831, alpha: 1.000)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}
