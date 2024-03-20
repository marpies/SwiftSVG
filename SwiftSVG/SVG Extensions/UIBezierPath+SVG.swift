//
//  UIBezierPath+SVG.swift
//  SwiftSVG
//
//
//  Copyright (c) 2017 Michael Choe
//  http://www.github.com/mchoe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.



#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

/**
 Convenience initializer that can parse a single path string and returns a `UIBezierPath`
 */

public extension UIBezierPath {
    
    /**
     Parses a single path string. Parses synchronously.
     - Parameter pathString: The path `d` string to parse.
     */
    convenience init(pathString: String) {
        let singlePath = SVGPath(singlePathString: pathString)
        guard let cgPath = singlePath.svgLayer.path else {
            self.init()
            return
        }
        #if os(iOS) || os(tvOS)
        self.init(cgPath: cgPath)
        #elseif os(OSX)
        if #available(macOS 14.0, *) {
            self.init(cgPath: cgPath)
        } else {
            self.init()
            
            cgPath.applyWithBlock { ptr in
                let element = ptr.pointee
                let pointsPtr = element.points
                
                switch element.type {
                case .moveToPoint:
                    move(to: pointsPtr.pointee)
                    
                case .addLineToPoint:
                    line(to: pointsPtr.pointee)
                    
                case .addQuadCurveToPoint:
                    let point1 = pointsPtr.pointee
                    let point2 = pointsPtr.advanced(by: 1).pointee
                    addQuadCurve(to: point2, controlPoint: point1)
                    
                case .addCurveToPoint:
                    let point1 = pointsPtr.pointee
                    let point2 = pointsPtr.advanced(by: 1).pointee
                    let point3 = pointsPtr.advanced(by: 2).pointee
                    addCurve(to: point3, controlPoint1: point1, controlPoint2: point2)
                    
                case .closeSubpath:
                    close()
                    
                @unknown default:
                    return
                }
            }
        }
        #endif
    }
    
    /// :nodoc:
    @available(*, deprecated, message: "This method is deprecated. If you want to parse a single path, instantiate a new instance of SVGPath using the SVGPath(singlePathString:) initializer and pass the path string.")
    class func pathWithSVGURL(_ SVGURL: URL) -> UIBezierPath? {
        assert(false, "This method is deprecated")
        return nil
    }
    
}
