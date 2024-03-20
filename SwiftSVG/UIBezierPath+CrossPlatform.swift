//
//  UIBezierPath+CrossPlatform.swift
//  SwiftSVG
//
//  Created by Marcel Piešťanský on 03/20/2024.
//  Copyright © 2024 Strauss LLC. All rights reserved.
//  
//  This program is free software. You can redistribute and/or modify it in
//  accordance with the terms of the accompanying license agreement.
//  

#if os(iOS) || os(tvOS)
import UIKit

public extension UIBezierPath {
    var asCGPath: CGPath { cgPath }
}
#endif
