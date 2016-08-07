//
//  TechDemoView
//  OpenGLReflectionDemo
//
//  Created by Andreas Umbach on 28.07.2016.
//  Copyright © 2016 Andreas Umbach. All rights reserved.
//

import Cocoa
import OpenGL
import GLKit
import GLUT
// let M_PI = Darwin.M_PI

class TechDemoView : NSOpenGLView
{
    var techDemo : TechDemoProtocol?
    
    required init?(coder: NSCoder)
    {
        // TODO: add some error checking
        super.init(coder: coder)
    }
    
    func createContext()
    {
        let pxfAttributes : [NSOpenGLPixelFormatAttribute] = [
            UInt32(NSOpenGLPFAColorSize), 32,
            UInt32(NSOpenGLPFADepthSize), 24,
            UInt32(NSOpenGLPFAStencilSize), 8,
            UInt32(NSOpenGLPFAAccelerated),
            UInt32(NSOpenGLPFAOpenGLProfile),
            techDemo!.profile,
            //          UInt32(NSOpenGLProfileVersionLegacy),
            //          UInt32(NSOpenGLProfileVersion3_2Core),
            0
        ]
        let pxf = NSOpenGLPixelFormat(attributes: pxfAttributes)
        let context = NSOpenGLContext(format: pxf!, shareContext: nil)
        self.openGLContext = context
        context?.makeCurrentContext()

    }
    override func prepareOpenGL() {
        techDemo?.prepareOpenGL()
    }
    
    override var acceptsFirstResponder: Bool { return true }
        
    override func drawRect(dirtyRect: NSRect) {
        techDemo?.render(width: dirtyRect.width, height: dirtyRect.height)
        glFlush()
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        var dx : Int32 = 0, dy : Int32 = 0
        CGGetLastMouseDelta(&dx, &dy)
        // Swift.print("delta: \(dx), \(dy)")
        
        techDemo?.phi += Float(-dx) * 0.5
        techDemo?.chi += Float(dy) * 0.5
        
        self.needsDisplay = true
    }
    
    
    override func keyDown(theEvent: NSEvent) {
        self.interpretKeyEvents([theEvent])
    }
    
    override func insertText(insertString: AnyObject) {
        switch(insertString as! String)
        {
        case " ": techDemo?.zPos += 0.1
        case "c": techDemo?.zPos -= 0.1
        default: break;
        }
        self.needsDisplay = true
    }
}
