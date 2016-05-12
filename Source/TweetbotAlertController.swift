//
//  TweetbotAlertController.swift
//  MLAlertView
//
//  Created by Maximilian Litteral on 5/11/16.
//  Copyright © 2016 Maximilian Litteral. All rights reserved.
//

import UIKit

// MARK: - Constants
private let Alertwidth: CGFloat = 280.0

// Button colors
private let RedColor = UIColor(red: 0.933, green: 0.737, blue: 0.745, alpha: 1.000)
private let RedTitleColor = UIColor(red: 0.769, green: 0.000, blue: 0.071, alpha: 1.000)
private let BlueColor = UIColor(red: 0.878, green: 0.933, blue: 0.992, alpha: 1.000)
private let BlueTitleColor = UIColor(red: 0.071, green: 0.431, blue: 0.965, alpha: 1.000)

// MARK: - Class

public class TweetbotAlertController: UIViewController {
    
    // MARK: - Properties
    
    // Public
    public var alertTitle: String? = nil {
        didSet {
            self.alertView.title = alertTitle
        }
    }
    public var alertMessage: String? = nil {
        didSet {
            self.alertView.message = alertMessage
        }
    }
    
    public var titleBackgroundColor: UIColor? {
        didSet {
            alertView.titleBackgroundColor = titleBackgroundColor
        }
    }
    
    public var titleForegroundColor: UIColor? {
        didSet {
            alertView.titleForegroundColor = titleForegroundColor
        }
    }
    
    public var highlightedCancelButtonBackgroundColor: UIColor? {
        didSet {
            alertView.highlightedCancelButtonBackgroundColor = highlightedCancelButtonBackgroundColor
        }
    }
    
    public var highlightedCancelButtonForegroundColor: UIColor? {
        didSet {
            alertView.highlightedCancelButtonForegroundColor = highlightedCancelButtonForegroundColor
        }
    }
    
    public var highlightedButtonBackgroundColor: UIColor? {
        didSet {
            alertView.highlightedButtonBackgroundColor = highlightedButtonBackgroundColor
        }
    }
    
    public var highlightedButtonForegroundColor: UIColor? {
        didSet {
            alertView.highlightedButtonForegroundColor = highlightedButtonForegroundColor
        }
    }
    
    // Private
    private var alertView: TweetbotAlertView
    
    // MARK: - Initialization
    
    public required init?(coder aDecoder: NSCoder) { fatalError("Please use init(title:message:preferredStyle:)") }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) { fatalError("Please use init(title:message:preferredStyle:)") }
    
    public init(title: String?, message: String?, preferredStyle style: UIAlertControllerStyle) {
        guard style == .Alert else { fatalError("ActionSheet style not yet supported.") }
        
        self.alertView = TweetbotAlertView(title: title, message: message)
        self.alertView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        // Configuration
        self.modalPresentationStyle = .OverFullScreen
        self.view.backgroundColor = UIColor.clearColor()
        
        // Set delegates
        alertView.delegate = self
        
        // Add subviews
        self.view.addSubview(alertView)
        
        // Constraints
        var constraints: [NSLayoutConstraint] = []
        constraints.append(alertView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor))
        constraints.append(alertView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor))
        constraints.append(alertView.widthAnchor.constraintEqualToConstant(Alertwidth))
        self.view.addConstraints(constraints)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure default colors
        titleBackgroundColor = UIColor(red: 0.063, green: 0.486, blue: 0.965, alpha: 1.000)
        titleForegroundColor = UIColor.whiteColor()
        highlightedCancelButtonBackgroundColor = RedColor
        highlightedCancelButtonForegroundColor = RedTitleColor
        highlightedButtonBackgroundColor = BlueColor
        highlightedButtonForegroundColor = BlueTitleColor
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        alertView.configure()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        alertView.show()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Actions
    
    public func addAction(action: TweetbotAlertAction) {
        alertView.addAction(action)
    }
}

extension TweetbotAlertController: TweetbotAlertViewDelegate {
    func dismissAlert() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
