//
//  UITouch+Location.swift
//  TouchSynthesis
//
//  Created by Mikey Ward on 2/11/19.
//  Copyright © 2019 Mikey Ward. All rights reserved.
//

import UIKit

public extension UITouch {
    
    /// Defines errors which might be thrown
    enum Error: Swift.Error {
        
        /// The view has no window, and so can't receieve touches
        case noWindow
    }
    
    /// Select a location (relative to a touch's target view) where a touch should land.
    @objc enum Location: Int{
        public typealias RawValue = Int
        
        /// The center point of the view.
        case center
        
        /// The view's origin, `CGPoint(x: 0, y: 0)`.
        case origin
    }
    
}
