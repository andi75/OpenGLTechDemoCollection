//
//  OpenGLUtilities.swift
//  OpenGLReflectionDemo
//
//  Created by Andreas Umbach on 28.07.2016.
//  Copyright © 2016 Andreas Umbach. All rights reserved.
//

//import Foundation
//import CoreGraphics
//import Cocoa
//import GLKit
//import OpenGL
import Cocoa
import OpenGL
import GLKit
import GLUT
let M_PI = Darwin.M_PI

// sides bottom top left right are from (1.5, 0.5, 0.5) viewing in direction (-1, 0, 0)

let cubeVertices : [Float] = [
    0, 0, 0, // bottom
    0, 1, 0,
    1, 1, 0,
    1, 0, 0,
    0, 0, 1, // top
    1, 0, 1,
    1, 1, 1,
    0, 1, 1,
    0, 0, 0, // left
    1, 0, 0,
    1, 0, 1,
    0, 0, 1,
    0, 1, 0, // right
    0, 1, 1,
    1, 1, 1,
    1, 1, 0,
    1, 0, 0, // front
    1, 1, 0,
    1, 1, 1,
    1, 0, 1,
    0, 0, 0, // back
    0, 0, 1,
    0, 1, 1,
    0, 1, 0
];

let cubeNormals : [Float] = [
    0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, // bottom
    0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, // top
    0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, // left
    0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, // right
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, // front
    -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0 // back
]

let cubeColors : [Float] = [
    1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, // bottom: purple
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, // top: red
    1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, // left: yellow
    0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, // right: green
    0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, // front: blue
    0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1  // back: cyan
]

let cubeIndices : [UInt32] = [
    0, 1, 2, 0, 2, 3, // bottom
    4, 5, 6, 4, 6, 7, // top
    8, 9, 10, 8, 10, 11, // left
    12, 13, 14, 12, 14, 15, // right
    16, 17, 18, 16, 18, 19, // front
    20, 21, 22, 20, 22, 23 // back
];

let squareVertices : [Float] = [
    0, 0, 0,
    0, 1, 0,
    1, 1, 0,
    1, 0, 0
];

let squareNormals : [Float] = [
    0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1
];

class OpenGLUtilities
{
    enum ProfileType { case OpenGL14, OpenGL32 }
    
    enum BufferIndices : Int { case
        CubeVertices = 0, CubeNormals = 1, CubeColors = 2,
        SquareVertices = 3, SquareNormals = 4,
        CubeIndices = 5,
        NumBuffers = 6 }
    
    var vbos : [GLuint] = [GLuint](count: BufferIndices.NumBuffers.rawValue, repeatedValue: 0)
    var vao : GLuint = 0
    
    var profile : ProfileType
    init(profile : ProfileType)
    {
        self.profile = profile
        
    }
    
    func vbo(buffer : BufferIndices) -> GLuint
    {
        return self.vbos[buffer.rawValue]
    }
    
    func prepareOpenGL()
    {
        switch(self.profile)
        {
        case .OpenGL14:
            break
        case .OpenGL32:
            glGenBuffers(GLsizei(vbos.count), &vbos)
            
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo(.CubeVertices))
            glBufferData(GLenum(GL_ARRAY_BUFFER), 4 * cubeVertices.count, cubeVertices, GLenum(GL_STATIC_DRAW))

            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo(.CubeNormals))
            glBufferData(GLenum(GL_ARRAY_BUFFER), 4 * cubeNormals.count, cubeNormals, GLenum(GL_STATIC_DRAW))
            
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo(.CubeColors))
            glBufferData(GLenum(GL_ARRAY_BUFFER), 4 * cubeColors.count, cubeColors, GLenum(GL_STATIC_DRAW))

            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo(.SquareVertices))
            glBufferData(GLenum(GL_ARRAY_BUFFER), 4 * squareVertices.count, squareVertices, GLenum(GL_STATIC_DRAW))

            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo(.SquareNormals))
            glBufferData(GLenum(GL_ARRAY_BUFFER), 4 * squareNormals.count, squareNormals, GLenum(GL_STATIC_DRAW))
            
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), vbo(.CubeIndices))
            glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), 4 * cubeIndices.count, cubeIndices, GLenum(GL_STATIC_DRAW))
            
            glGenVertexArrays(1, &vao)
        }
    }
    
    func glMatrix(mat : GLKMatrix4) -> [Float]
    {
        return [
            mat.m00, mat.m01, mat.m02, mat.m03,
            mat.m10, mat.m11, mat.m12, mat.m13,
            mat.m20, mat.m21, mat.m22, mat.m23,
            mat.m30, mat.m31, mat.m32, mat.m33
        ]
    }
    
    func glMatrix(mat : GLKMatrix3) -> [Float]
    {
        return [
            mat.m00, mat.m01, mat.m02,
            mat.m10, mat.m11, mat.m12,
            mat.m20, mat.m21, mat.m22
        ]
    }
    
    func pushColoredCubeGeometry()
    {
        switch(self.profile)
        {
        case .OpenGL14:
            glColorPointer(3, GLenum(GL_FLOAT), 0, cubeColors)
            glEnableClientState(GLenum(GL_COLOR_ARRAY))
            pushCubeGeometry()
            glDisableClientState(GLenum(GL_COLOR_ARRAY))
        case .OpenGL32:
            glBindVertexArray(vao)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo(.CubeColors))
            glVertexAttribPointer(2, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
            glEnableVertexAttribArray(2)
            pushCubeGeometry()
            glDisableVertexAttribArray(2)
        }
    }
    
    func pushCubeGeometry()
    {
        switch(self.profile)
        {
        case .OpenGL14:
            glVertexPointer(3, GLenum(GL_FLOAT), 0, cubeVertices)
            glNormalPointer(GLenum(GL_FLOAT), 0, cubeNormals)
            glEnableClientState(GLenum(GL_VERTEX_ARRAY))
            glEnableClientState(GLenum(GL_NORMAL_ARRAY))
            glDrawElements(GLenum(GL_TRIANGLES), GLsizei(cubeIndices.count), GLenum(GL_UNSIGNED_INT), cubeIndices)
            glDisableClientState(GLenum(GL_NORMAL_ARRAY))
            glDisableClientState(GLenum(GL_VERTEX_ARRAY))
        case .OpenGL32:
            checkError("before binding vertex array")
            glBindVertexArray(vao)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo(.CubeVertices))
            glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo(.CubeNormals))
            glVertexAttribPointer(1, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
            glEnableVertexAttribArray(0)
            glEnableVertexAttribArray(1)
            checkError("after enabling vertex arrays")
            
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), vbo(.CubeIndices))
            glDrawElements(GLenum(GL_TRIANGLES), GLsizei(cubeIndices.count), GLenum(GL_UNSIGNED_INT), nil)
            checkError("after drawElements()")
    
            glDisableVertexAttribArray(0)
            glDisableVertexAttribArray(1)
        }
    }
    
    func pushSquareGeometry()
    {
        switch(self.profile)
        {
        case .OpenGL14:
            glVertexPointer(3, GLenum(GL_FLOAT), 0, squareVertices)
            glNormalPointer(GLenum(GL_FLOAT), 0, squareNormals)
            glEnableClientState(GLenum(GL_VERTEX_ARRAY))
            glEnableClientState(GLenum(GL_NORMAL_ARRAY))
            glDrawArrays(GLenum(GL_QUADS), 0, 4)
            glDisableClientState(GLenum(GL_NORMAL_ARRAY))
            glDisableClientState(GLenum(GL_VERTEX_ARRAY))
        case .OpenGL32:
            glBindVertexArray (vao)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo(.SquareVertices))
            glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo(.SquareNormals))
            glVertexAttribPointer(1, 3, GLenum(GL_FLOAT), 0, 0, squareNormals)
            glEnableVertexAttribArray(0)
            glEnableVertexAttribArray(1)
            glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, 4)
            glDisableVertexAttribArray(0)
            glDisableVertexAttribArray(1)
        }
    }
    
    func checkError(s : String)
    {
        let err = glGetError()
        if(err != GLenum(GL_NO_ERROR))
        {
            print("error \(err) after \(s)")
        }
    }
}

