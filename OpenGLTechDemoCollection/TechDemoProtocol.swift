//
//  TechDemoProtocol.swift
//  OpenGLTechDemoCollection
//
//  Created by Andreas Umbach on 05.08.2016.
//  Copyright © 2016 Andreas Umbach. All rights reserved.
//

import Cocoa

protocol TechDemoProtocol
{
    var phi : Float { get set }
    var chi : Float { get set }
    var zPos : Float { get set }

    var profile : NSOpenGLPixelFormatAttribute { get }
    
    func render(width width: CGFloat, height: CGFloat)
    func prepareOpenGL()
}