
//
//  OGL4Cube.swift
//  OpenGLTechDemoCollection
//
//  Created by Andreas Umbach on 05.08.2016.
//  Copyright © 2016 Andreas Umbach. All rights reserved.
//

import Cocoa
import OpenGL
import GLKit
import GLUT

class OGL4Cube : TechDemoProtocol
{
    var phi : Float = 0
    var chi : Float = 0
    var zPos : Float = 0.5

    var profile = NSOpenGLPixelFormatAttribute(NSOpenGLProfileVersion3_2Core)

    let glut = OpenGLUtilities(profile: .OpenGL32)
    
    var program : GLuint = 0
    
    func render(width width: CGFloat, height: CGFloat) {
        glut.checkError("before frame")
        glViewport(0, 0, GLsizei(width), GLsizei(height))
        glClearBufferfv(GLenum(GL_COLOR), 0, [0.8, 0.8, 0.8, 0])
        glClearBufferfi(GLenum(GL_DEPTH_STENCIL), 0, 1, 0)

        glUseProgram(program)
        // set uniforms for program
        
        let proj = GLKMatrix4MakePerspective( Float(M_PI) / 4.0, Float(width / height), 2, 100 * 2)
        let pLocation = glGetUniformLocation(program, "Pmatrix")
        glUniformMatrix4fv(pLocation, 1, GLboolean(GL_FALSE), glut.glMatrix(proj))
        
        let eye = GLKVector3Make(0.5, 5.5, 3.5)
        let viewPoint = GLKVector3Make(0.5, 0.5, 0.5)
        let up = GLKVector3Make(0, 0, 1)
        
        let view = GLKMatrix4MakeLookAt(
            eye.x, eye.y, eye.z,
            viewPoint.x, viewPoint.y, viewPoint.z,
            up.x, up.y, up.z
        )
        
        let t1 = GLKMatrix4MakeTranslation(-0.5, -0.5, -0.5)
        let t2 = GLKMatrix4MakeTranslation(0.5, 0.5, 0.5)
        let rotation =
            GLKMatrix4Multiply(
                GLKMatrix4MakeXRotation(chi / 360 * 2 * Float(M_PI)),
                GLKMatrix4MakeZRotation(phi / 360 * 2 * Float(M_PI)
                )
        )
        let model = GLKMatrix4Multiply(t2, GLKMatrix4Multiply(rotation, t1) )
        let modelView = GLKMatrix4Multiply(view, model)

        let mvLocation = glGetUniformLocation(program, "MVmatrix")
        glUniformMatrix4fv(mvLocation, 1, GLboolean(GL_FALSE), glut.glMatrix(modelView))
        
        let matNormal = GLKMatrix4GetMatrix3(modelView)

//        // since matNormal is orthonormal, the following is not necessary
//        var isInvertible : Bool = false
//        let invMatNormal = GLKMatrix3InvertAndTranspose(matNormal, &isInvertible)
//        assert(isInvertible)
        
        let invMVLocation = glGetUniformLocation(program, "matNormal")
        glUniformMatrix3fv(invMVLocation, 1, GLboolean(GL_FALSE), glut.glMatrix(matNormal))
        
        glEnable(GLenum(GL_DEPTH_TEST))
        glut.pushColoredCubeGeometry()
        
        glut.checkError("after pushSquareGeometry")
    }
    
    func prepareOpenGL()
    {
        glut.prepareOpenGL()
//        glut.checkError("after glut prepareOpenGL()")
        
        initShaders()
//        glut.checkError("after init shaders")

        
        var buffers : GLuint = 0
        glGenBuffers(1, &buffers)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), buffers)
    }
    
    func compileShader(filename: String, type: GLenum) -> GLuint {
        
        let shaderPath = NSBundle.mainBundle().pathForResource(filename, ofType: nil)
        assert(shaderPath != nil)
        
        var src: String? = nil
        do { try src = String(contentsOfFile: shaderPath!) }
        catch { assert(false) }
        
        let id = glCreateShader(type)
        var srcUTF8 = (src! as NSString).UTF8String
        glShaderSource(id, GLsizei(1), &srcUTF8, nil)
        glCompileShader(id)
        
        var compileStatus: GLint = 0
        glGetShaderiv(id, GLenum(GL_COMPILE_STATUS), &compileStatus)
        if (compileStatus == GL_FALSE) {
            var infoLog : [CChar] = [CChar](count: 1024, repeatedValue: 32)
            var infoLogLength : GLint = 0
            glGetShaderInfoLog(id, 1024, &infoLogLength, &infoLog)
            print("compile status: \(compileStatus), log: \(String.fromCString(infoLog))")
            return 0
        }
        return id
    }
    
    func initShaders() {
        let vertexShader: GLuint = self.compileShader("OGL4Cube.vs", type: GLenum(GL_VERTEX_SHADER))
        let fragmentShader: GLuint = self.compileShader("OGL4Cube.fs", type: GLenum(GL_FRAGMENT_SHADER))
        
        glut.checkError("before initShaders()")
        
        self.program = glCreateProgram()
        glAttachShader(program, vertexShader)
        glAttachShader(program, fragmentShader)
        
        glBindAttribLocation(program, 0, ("position" as NSString).UTF8String)
        glBindAttribLocation(program, 1, ("normal" as NSString).UTF8String)
        glBindAttribLocation(program, 2, ("vertexColor" as NSString).UTF8String)
        
        glLinkProgram(program);
        
        glut.checkError("after linking")
        
        var linkStatus : GLint = 0
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &linkStatus)
        
        if(linkStatus == GL_FALSE)
        {
            var infoLog : [CChar] = [CChar](count: 1024, repeatedValue: 32)
            var infoLogLength : GLint = 0
            glGetProgramInfoLog(program, 1024, &infoLogLength, &infoLog)
            print("link status: \(linkStatus), log: \(String.fromCString(infoLog))")
        }
        glut.checkError("after shader error checking")
        
        // Delete the shaders as the program has them now
        glDeleteShader(vertexShader)
        glDeleteShader(fragmentShader)
        
        glut.checkError("after shader deletion")
    }
}