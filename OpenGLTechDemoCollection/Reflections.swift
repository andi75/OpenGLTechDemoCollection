//
//  Reflections.swift
//  OpenGLTechDemoCollection
//
//  Created by Andreas Umbach on 05.08.2016.
//  Copyright © 2016 Andreas Umbach. All rights reserved.
//

import Cocoa
import OpenGL
import GLKit
import GLUT

class Reflections : TechDemoProtocol
{
    var phi : Float = 0
    var chi : Float = 0
    var zPos : Float = 0.5

    var profile = NSOpenGLPixelFormatAttribute(NSOpenGLProfileVersionLegacy)
    
    let glut = OpenGLUtilities(profile: .OpenGL14)

    func prepareOpenGL() { glut.prepareOpenGL() }
    
    func setupCubeTransformation()
    {
        glTranslatef(0, 0, zPos);
        glTranslatef(0.5, 0.5, 0.5)
        glRotatef(chi, 1, 0, 0)
        glRotatef(phi, 0, 0, 1)
        glTranslatef(-0.5, -0.5, -0.5)
    }
    
    func setupSquareTransformation()
    {
        glTranslatef(0.5, 0.5, 0)
        glScalef(3.0, 3.0, 1.0)
        glTranslatef(-0.5, -0.5, 0)
    }

    func render(width width: CGFloat, height: CGFloat)
    {
        glClearColor(0.8, 0.8, 0.8, 0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT))
        
        glViewport(0, 0, GLsizei(width), GLsizei(height))
        
        // setup lighting
        glEnable(GLenum(GL_LIGHTING))
        glEnable(GLenum(GL_LIGHT0))
        glColorMaterial(GLenum(GL_FRONT_AND_BACK), GLenum(GL_AMBIENT_AND_DIFFUSE))
        glEnable( GLenum(GL_COLOR_MATERIAL) )
        let black : [Float] = [ 0, 0, 0, 0 ]
        glLightModelfv(GLenum(GL_LIGHT_MODEL_AMBIENT), black)
        
        // depth test is enabled throughout
        glEnable( GLenum(GL_DEPTH_TEST) )
        
        // setup matrices
        glMatrixMode(GLenum(GL_PROJECTION))
        let d : Float = 2.0
        let proj = GLKMatrix4MakePerspective( Float(M_PI) / 4.0, Float(width / height), d, 100 * d)
        glLoadMatrixf(glut.glMatrix(proj))
        
        glMatrixMode(GLenum(GL_MODELVIEW))
        glLoadIdentity()
        
        let eye = GLKVector3Make(0.5, 5.5, 3.5)
        let viewPoint = GLKVector3Make(0.5, 0.5, 0.5)
        let up = GLKVector3Make(0, 0, 1)
        
        let view = GLKMatrix4MakeLookAt(
            eye.x, eye.y, eye.z,
            viewPoint.x, viewPoint.y, viewPoint.z,
            up.x, up.y, up.z
        )
        glLoadMatrixf(glut.glMatrix(view))
        
        // draw a reflector to the stencil buffer
        glStencilOp(GLenum(GL_KEEP), GLenum(GL_KEEP), GLenum(GL_REPLACE))
        glStencilFunc(GLenum(GL_ALWAYS), 255, 255)
        glEnable(GLenum(GL_STENCIL_TEST))
        glDepthMask(GLboolean(GL_FALSE))
        glColorMask(GLboolean(GL_FALSE), GLboolean(GL_FALSE), GLboolean(GL_FALSE), GLboolean(GL_FALSE))
        
        glPushMatrix()
        setupSquareTransformation()
        glut.pushSquareGeometry()
        glPopMatrix()
        
        glColorMask(GLboolean(GL_TRUE), GLboolean(GL_TRUE), GLboolean(GL_TRUE), GLboolean(GL_TRUE))
        glDepthMask(GLboolean(GL_TRUE))
        glDisable(GLenum(GL_STENCIL_TEST))
        
        // setup clipplane
        let plane : [Double] = [ 0, 0, -1, 0 ]
        glClipPlane(GLenum(GL_CLIP_PLANE0), plane)
        glEnable(GLenum(GL_CLIP_PLANE0))
        
        // setup light direction for the reflected object
        let lightPosReflected : [Float] = [eye.x, eye.y, -eye.z, 0]
        glLightfv( GLenum(GL_LIGHT0), GLenum(GL_POSITION), lightPosReflected  )
        
        // setup reflection matrix
        glPushMatrix()
        glScalef(1, 1, -1)
        setupCubeTransformation()
        
        // draw the reflected object with stencil test
        glStencilOp(GLenum(GL_KEEP), GLenum(GL_KEEP), GLenum(GL_KEEP))
        glStencilFunc(GLenum(GL_LESS), 0, 255)
        glEnable(GLenum(GL_STENCIL_TEST))
        glut.pushColoredCubeGeometry()
        glDisable(GLenum(GL_STENCIL_TEST))
        
        // restore normal view matrix
        glPopMatrix()
        
        // disable clipplane
        glDisable(GLenum(GL_CLIP_PLANE0))
        
        // draw the reflector with blending
        glEnable(GLenum(GL_BLEND))
        glColor4f(1, 0, 0, 0.4)
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        glPushMatrix()
        setupSquareTransformation()
        glut.pushSquareGeometry()
        glPopMatrix()
        glDisable(GLenum(GL_BLEND))
        
        // draw the normal object
        let lightPos : [Float] = [eye.x, eye.y, eye.z, 0]
        glLightfv( GLenum(GL_LIGHT0), GLenum(GL_POSITION), lightPos  )
        glPushMatrix()
        setupCubeTransformation()
        glut.pushColoredCubeGeometry()
        glPopMatrix()
    }

}