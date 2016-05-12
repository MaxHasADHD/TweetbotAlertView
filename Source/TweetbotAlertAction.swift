//
//  TweetbotAlertAction.swift
//  MLAlertView
//
//  Created by Maximilian Litteral on 5/11/16.
//  Copyright © 2016 Maximilian Litteral. All rights reserved.
//

import UIKit

@objc public enum TweetbotAlertActionStyle: Int {
    case Cancel
    case Default
}

public class TweetbotAlertAction: NSObject {
    // MARK: - Properties
    
    // Public
    public var actionTitle: String?
    public var actionStyle: TweetbotAlertActionStyle
    public var handler: ((action: TweetbotAlertAction) -> Void)?
    
    // Private
    
    // MARK: - Initialization
    
    public init(title: String?, style: TweetbotAlertActionStyle, handler: ((action: TweetbotAlertAction) -> Void)?) {
        self.actionTitle = title
        self.actionStyle = style
        self.handler = handler
    }
}
